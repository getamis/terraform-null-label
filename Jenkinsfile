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
            defaultContainer 'builder'
        }
    }

    options {
        // timestamps requires a jenkins plugin
        timestamps()
        timeout(time: 120, unit: 'MINUTES')
    }

    stages {
        stage('test') {
            parallel {
                stage('terraform-fmt') {
                    agent {
                        kubernetes {
                            yamlFile 'jenkins/agent.yaml'
                            defaultContainer 'builder'
                        }
                    }
                    steps {
                        sh 'terraform --version'
                        sh 'terraform fmt -recursive -check'
                    }
                }
                stage('terraform-validate') {
                    agent {
                        kubernetes {
                            yamlFile 'jenkins/agent.yaml'
                            defaultContainer 'builder'
                        }
                    }
                    steps {
                        sh 'terraform --version'
                        sh 'terraform validate'
                    }
                }
                stage('terragrunt-fmt') {
                    agent {
                        kubernetes {
                            yamlFile 'jenkins/agent.yaml'
                            defaultContainer 'builder'
                        }
                    }
                    steps {
                        sh 'terragrunt --version'
                        sh 'terragrunt hclfmt --terragrunt-check'
                    }
                }
                stage('tflint') {
                    agent {
                        kubernetes {
                            yamlFile 'jenkins/agent.yaml'
                            defaultContainer 'builder'
                        }
                    }
                    steps {
                        sh 'tflint --version'
                        sh 'tflint -f checkstyle > checkstyle-result.xml'
                    }
                    post {
                        always {
                            sh 'cat checkstyle-result.xml'
                            recordIssues(
                                tools: [
                                    checkStyle(pattern: 'checkstyle-result.xml')
                                ]
                            )
                        }
                    }
                }
            }
        }
    }
}
