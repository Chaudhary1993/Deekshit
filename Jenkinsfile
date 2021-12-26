pipeline{
    agent any
    stages{
        stage("Sonar Quality Check"){
            agent{
                docker {
                    image 'openjdk:16'
                }
            }
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'Sonar-Token') {
                        sh 'chmod +x gradlew'
                        sh './gradlew sonarqube --stacktrace'
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