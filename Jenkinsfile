pipeline{
    agent any
    environment{
        VERSION="${env.BUILD_ID}"
    }
    stages{
        stage("Sonar Quality Check"){
            agent{
                docker {
                    image 'openjdk:11'
                }
            }
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'Sonar-Token') {
                        sh 'chmod +x gradlew'
                        sh './gradlew sonarqube -Dsonar.userHome=`pwd`/.sonar'
                     }
                     timeout(time: 10, unit: 'MINUTES') {
                         def qg = waitForQualityGate()
                         if (qg.status != 'OK'){
                             error "Pipeline aborted due to quality gate failure: ${qg.status}"
                         }
                       }
                }
            }
        }
        stage("Docker Build & Docker push"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'docker_pass', variable: 'docker_password')]) {
                        sh '''
                     docker build -t 65.2.4.99:8083/springapp:${VERSION} .
                     docker login -u admin -p $docker_password 65.2.4.99:8083
                     docker push 65.2.4.99:8083/springapp:${VERSION}
                     docker rmi 65.2.4.99:8083/springapp:${VERSION}
                    '''
                    }
                    
                }
            }
        }
        stage ("Identify misconfigs with datree for helm"){
            steps{
                script{
                    dir('kubernetes/') {
                        sh 'helm datree test myapp/'
                    }
                }
            }
        }
    }
    post{
        always{
            echo "success"
        }
    }
}