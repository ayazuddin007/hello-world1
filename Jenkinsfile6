def ansibleServerIP = '172.31.7.186'
def kubernetesServerIP = '172.31.37.2'
def pushDockerImage = 'ansible-playbook -i hosts p11.yml'
def createDockerContainer = 'ansible-playbook -i hosts p12.yml'
def createK8SDeployment = 'ansible-playbook -i hosts kubernetes-valaxy-deployment.yml'
def createK8Service = 'ansible-playbook -i hosts kubernetes-valaxy-service.yml'

pipeline {
    agent any
    
    environment {
        PATH = "/opt/maven/bin:$PATH"
        
    }
    
    stages {
        stage("Git Clone") {
            steps {
                git branch: 'master', credentialsId: 'gitCredentials', url: 'https://github.com/ayazuddin007/hello-world1.git'
            }
        }
        stage("Maven Build") {
            steps {
                sh "mvn clean install"
                sh "mv webapp/target/*.war webapp/target/myweb.war"
            }
        }
        stage("Copy war to Ansible") {
            steps {
                sshagent(['ansibleCredentials']) {
                    // Copy war file to Ansible Server
                    sh "scp -o StrictHostKeyChecking=no webapp/target/*.war ec2-user@${ansibleServerIP}:/home/ec2-user/"
                }
            }
        }
        stage("Push Docker Image to Docker Hub") {
            steps {
                sshagent(['ansibleCredentials']) {
                        // Copy Dockerfile,hosts and p11.yml to Ansible Server
                        sh "scp -o StrictHostKeyChecking=no Dockerfile hosts p11.yml ec2-user@${ansibleServerIP}:/home/ec2-user/"
                        // Push Docker Image to Docker Hub by Runnning p11.yml on localhost(Ansible)
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${ansibleServerIP} ${pushDockerImage}"
                }
            }
        }
        stage('Deploy to Kubernetes Cluster') {
            steps {
                sshagent(['ansibleCredentials']) {
                        // Copy valaxy-deploy.yml,valaxy-service.yml,kubernetes-valaxy-deployment.yml and kubernetes-valaxy-service.yml to Ansible Server
                        sh "scp -o StrictHostKeyChecking=no valaxy-deploy.yml valaxy-service.yml kubernetes-valaxy-deployment.yml kubernetes-valaxy-service.yml ec2-user@${ansibleServerIP}:/home/ec2-user/"
                        // Create valaxy-deployment on K8S Server by running playbook on Ansible Server
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${ansibleServerIP} ${createK8SDeployment}"
                        // Create valaxy-service on K8S Server by running playbook on Ansible Server
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${ansibleServerIP} ${createK8Service}"     
                    
                }
            }
        }
        
    }
}
