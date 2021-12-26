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
                        sh 'mkdir $(pwd)/sonar'
                        sh 'export SONAR_USER_HOME=$(pwd)/sonar'
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