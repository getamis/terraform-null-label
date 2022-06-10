#!groovy
// vim:filetype=groovy:sw=4:ts=4:sts=4:
@Library('jenkins-library@v2.0') _

import groovy.transform.Field

// Update the project name from the PR title
if (env.CHANGE_TITLE) {
    currentBuild.rawBuild.project.displayName = "${env.BRANCH_NAME} | ${env.CHANGE_TITLE}"
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
        ANSI_COLORS_DISABLED = 'true' // checkov output
    }

    stages {
        stage('terraform-init') {
            agent {
                kubernetes {
                    yamlFile 'jenkins/agent.yaml'
                    defaultContainer 'runner'
                }
            }
            steps {
                sshagent(['ghe-ssh-mai-gitops']) {
                    script {
                        sh 'terraform init -backend=false -no-color'
                        sh 'terraform validate -no-color'
                    }
                }
            }
        }
        stage('test') {
            parallel {
                stage('terraform-fmt') {
                    agent {
                        kubernetes {
                            yamlFile 'jenkins/agent.yaml'
                            defaultContainer 'runner'
                        }
                    }
                    steps {
                        sh 'terraform --version'
                        sh 'terraform fmt -recursive -check'
                    }
                }
                stage('terragrunt-fmt') {
                    agent {
                        kubernetes {
                            yamlFile 'jenkins/agent.yaml'
                            defaultContainer 'runner'
                        }
                    }
                    steps {
                        sh 'terragrunt --version'
                        sh 'terragrunt hclfmt --terragrunt-check'
                    }
                }
                stage('checkov') {
                    agent {
                        kubernetes {
                            yamlFile 'jenkins/agent.yaml'
                            defaultContainer 'runner'
                        }
                    }
                    steps {
                        sshagent(['ghe-ssh-mai-gitops']) {
                            sh 'checkov --version'
                            sh 'checkov --download-external-modules True -d . -o junitxml > checkov-result.xml || true'
                            junit(allowEmptyResults: true, testResults: 'checkov-result.xml')
                        }
                    }
                }
                stage('tfsec') {
                    agent {
                        kubernetes {
                            yamlFile 'jenkins/agent.yaml'
                            defaultContainer 'runner'
                        }
                    }
                    steps {
                        sh 'tfsec --version'
                        sh 'tfsec -f checkstyle > tfsec-result.xml || true'
                    }
                    post {
                        always {
                            sh 'cat tfsec-result.xml'
                            recordIssues(
                                tools: [
                                    checkStyle(id: 'tfsec-checkstyle', pattern: 'tfsec-result.xml')
                                ]
                            )
                        }
                    }
                }
                stage('terrascan') {
                    agent {
                        kubernetes {
                            yamlFile 'jenkins/agent.yaml'
                            defaultContainer 'runner'
                        }
                    }
                    steps {
                        sh 'terrascan version'
                        sh 'terrascan scan -d . -i terraform --use-terraform-cache --show-passed --use-colors f -o junit-xml > terrascan-result.xml || true'
                        junit(testResults: 'terrascan-result.xml')
                    }
                }
                stage('tflint') {
                    agent {
                        kubernetes {
                            yamlFile 'jenkins/agent.yaml'
                            defaultContainer 'runner'
                        }
                    }
                    steps {
                        sh 'tflint --version'
                        sh 'tflint -f checkstyle > tflint-result.xml'
                    }
                    post {
                        always {
                            sh 'cat tflint-result.xml'
                            recordIssues(
                                tools: [
                                    checkStyle(id: 'tflint-checkstyle', pattern: 'tflint-result.xml')
                                ]
                            )
                        }
                    }
                }
            }
        }
    }
}
