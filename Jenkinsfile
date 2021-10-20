
pipeline {
  agent any 
   tools {
     maven "M3"
   }
  
  stages {
    stage ("clone repository") {
      steps {
        script {
           git url: 'https://github.com/RKuete-5/spring-boot-sample';
        }
      }
    }

    stage ("sonarQube scan") {
        environment {
            TOKEN = "6bbc71b0aa564e080ac9980eae2b3d7b565acf72"
        }

        steps {
            script {
                def scannerHome = tool name: 'SonarQube';
                    withSonarQubeEnv('SonarQube') {
                        sh "${tool("SonarQube")}/bin/sonar-scanner \
                        -Dsonar.sources=. \
                        -Dsonar.ts.coverage.lcovReportPath=coverage/lcov.info \
                        -Dsonar.host.url=https://sonarqubes.tools.beopenit.com \
                        -Dsonar.login=${TOKEN} \
                        -Dsonar.projectKey=nappyme" 
                    }
                }
        }
    }
    
    stage ("scan and build branch") {
        parallel {
            stage("build and test for features branch") {
                 when {
                        not {
                            anyOf {
                                branch 'master'
                                branch 'dev'
                            }
                        }
                 }

                 steps {
                    sh 'make mvn_build VERSION=${VERSION}'
                 }
            }

            stage("build and test for dev branch") {
                when {
                    branch 'dev'
                }

                steps {
                    sh 'make mvn_build VERSION=${VERSION}'
                }
            }

            stage("build and test for master branch") {
                
                when {
                    branch 'master'
                }

                steps {
                    sh 'make mvn_build VERSION=${VERSION}'
                }
            }
        }
    }

    stage ("build and push image") {
        parallel {
            stage("dev branch") {
                when {
                    branch 'dev'
                }

                steps {
                     withCredentials([usernamePassword(credentialsId: 'rdy-docker-credentials', passwordVariable: 'password', usernameVariable: 'username')]) {
                            sh 'docker login -u $username -p $password'
                     }

                    sh 'make build_image_dev VERSION=${VERSION}'
                    sh 'make push_image_dev VERSION=${VERSION}'
                }
            }

            stage("master branch") {
                when {
                    branch 'master'
                }

                steps {
                     withCredentials([usernamePassword(credentialsId: 'modou-docker-credentials', passwordVariable: 'password', usernameVariable: 'username')]) {
                            sh 'docker login -u $username -p $password'
                     }

                    sh 'make build_image_master VERSION=${VERSION}'
                    sh 'make push_image_master VERSION=${VERSION}'
                }
            }
        }
    }


  }
  
}