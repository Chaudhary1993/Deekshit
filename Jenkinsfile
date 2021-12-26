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
                        sh 'export SONAR_USER_HOME=$(pwd)'
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