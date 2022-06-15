#!groovy
// vim:filetype=groovy:sw=4:ts=4:sts=4:
@Library('jenkins-library@v3.0') _

import groovy.transform.Field

// Update the project name from the PR title
if (env.CHANGE_TITLE) {
    currentBuild.rawBuild.project.displayName = "${env.BRANCH_NAME} | ${env.CHANGE_TITLE}"
}

@Field def s3CacheConfig = [
    bucket: 'base-jenkins-cache',
    role: 'jenkins-cache',
]

def traverseDir(Closure body) {
  def files = findFiles()
  files.each { f ->
    if (f.directory) {
      dir(f.name) {
        body()
      }
    }
  }
}

pipeline {
    agent {
        kubernetes {
            yamlFile 'jenkins/agent.yaml'
            defaultContainer 'runner'
        }
    }

    options {
        // timestamps requires a jenkins plugin
        timestamps()
        timeout(time: 120, unit: 'MINUTES')
    }

    environment {
        VAULT_ADDR = 'http://localhost' // vault provider require vault address
        TF_PLUGIN_CACHE_DIR="${WORKSPACE}/.terraform.d/plugin-cache" // global shared plugin cache to repository root
        TERRAGRUNT_DOWNLOAD="${WORKSPACE}/.terragrunt-cache" // global shared cache to repository root
    }

    stages {
        stage('terraform-init') {
            steps {
                sh 'mkdir -p ${TF_PLUGIN_CACHE_DIR}'
                sh 'mkdir -p ${TERRAGRUNT_DOWNLOAD}'

                sh '''
                terraform -v | head -n 1 >> terraform-checksum.txt
                terragrunt -v >> terraform-checksum.txt
                cat terraform-checksum.txt
                '''
                // FIXME: checksum plugin usage across modules

                extractCache(
                    prefix: 'tf-null-label-v1',
                    checksumFile: 'terraform-checksum.txt',
                    paths: ["${WORKSPACE}/.terraform.d/plugin-cache", "${WORKSPACE}/.terragrunt-cache"],
                    s3: s3CacheConfig,
                ) {
                    sshagent(['ghe-ssh-mai-gitops']) {
                        dir('modules') {
                            traverseDir() {
                                sh 'terraform init -backend=false -no-color'
                            }
                        } // modules
                        sh 'terraform init -backend=false -no-color'
                    }
                }
                sshagent(['ghe-ssh-mai-gitops']) {
                    dir('modules') {
                        traverseDir() {
                            sh 'terraform init -backend=false -no-color'
                        }
                    } // modules
                    sh 'terraform init -backend=false -no-color'
                }
            }
        }
        stage('test') {
            parallel {
                stage('terraform-fmt') {
                    steps {
                        sh 'terraform --version'
                        sh 'terraform fmt -recursive -check'
                    }
                }
                stage('terraform-validate') {
                    steps {
                        sh 'terraform --version'
                        dir('modules') {
                            traverseDir() {
                                sh 'terraform validate -no-color'
                            }
                        } // modules
                        sh 'terraform validate -no-color'
                    }
                }
                stage('terragrunt-fmt') {
                    steps {
                        sh 'terragrunt --version'
                        sh 'terragrunt hclfmt --terragrunt-check'
                    }
                }
                stage('checkov') {
                    environment {
                        ANSI_COLORS_DISABLED = 'true'
                        EXTERNAL_MODULES_DOWNLOAD_PATH = "${WORKSPACE}/.external_modules"
                    }
                    steps {
                        // checkov will download all modules. cache this ?
                        sshagent(['ghe-ssh-mai-gitops']) {
                            sh 'checkov --version'
                            sh "checkov -d . --download-external-modules True --soft-fail -o junitxml > checkov-result.xml"
                        }
                    }
                    post {
                        always {
                            junit((allowEmptyResults: true, testResults: 'checkov-result.xml')
                        }
                    }
                }
                stage('tfsec') {
                    steps {
                        sh 'tfsec --version'
                        sh 'tfsec --soft-fail -f checkstyle > tfsec-result.xml'
                    }
                    post {
                        always {
                            sh 'cat tfsec-result.xml'
                            recordIssues(
                                tools: [
                                    checkStyle(id: 'tfsec-checkstyle', name: 'Tfsec Checkstyle', pattern: 'tfsec-result.xml')
                                ]
                            )
                        }
                    }
                }
                stage('terrascan') {
                    steps {
                        sh 'terrascan version'
                        sh 'terrascan scan -i terraform -d . --use-terraform-cache --show-passed --use-colors f -o junit-xml > terrascan-result.xml || true'
                    }
                    post {
                        always {
                            junit(testResults: 'terrascan-result.xml')
                        }
                    }
                }
                stage('tflint') {
                    steps {
                        sh 'tflint --version'
                        sh 'tflint -f checkstyle > tflint-result.xml'
                    }
                    post {
                        always {
                            sh 'cat tflint-result.xml'
                            recordIssues(
                                tools: [
                                    checkStyle(id: 'tflint-checkstyle', name: 'Tflint Checkstyle', pattern: 'tflint-result.xml')
                                ]
                            )
                        }
                    }
                }
            }
        }
    }
}
