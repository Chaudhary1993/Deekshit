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
        stage("Pushing the Helm Chart to Nexus"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'docker_pass', variable: 'docker_password')]) {
                    dir('kubernetes/') {
                        sh '''
                        helmversion=$(helm show chart myapp | grep version | cut -d: -f 2 | tr -d ' ')
                        tar -czvf myapp-${helmversion}.tgz myapp/
                        curl -u admin:$docker_password http://65.2.4.99:8081/repository/helm-hosted/ --upload-file myapp-${helmversion}.tgz -v 
                    '''
                    }
                  }
                }
            }
        }
        stage('deploying on k8s cluster') {
            steps {
                script{
                    withCredentials([kubeconfigFile(credentialsId: 'kubernetes-config', variable: 'KUBECONFIG')]) {
                        dir('kubernetes/') {
                        sh 'helm upgrade --install --set image.repository="65.2.4.99:8083/springapp" --set image.tag="${VERSION}" myjavaapp myapp/'
                    }
                  }
                }
            }
        }
        stage('verifying app deployment'){
            steps{
                script{
                     withCredentials([kubeconfigFile(credentialsId: 'kubernetes-config', variable: 'KUBECONFIG')]) {
                         sh 'kubectl run curl --image=curlimages/curl -i --rm --restart=Never -- curl myjavaapp-myapp:8080'

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