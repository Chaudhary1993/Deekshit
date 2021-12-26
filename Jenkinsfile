pipeline{
    agent any
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
    }
    post{
        always{
            echo "success"
        }
    }
}