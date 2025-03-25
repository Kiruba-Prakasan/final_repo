pipeline {
    agent any
    tools {
        jdk 'jdk21'
        nodejs 'node20'
    }

    environment {
        IMAGE_NAME = "kirubarp/final_repo"
        CONTAINER_NAME = "static-website-container"
        TAG = "latest"
        DEPLOYMENT_FILE = "deployment.yaml"
        KUBECONFIG = "/var/lib/jenkins/.kube/config"  // ✅ Ensure Jenkins uses Minikube kubeconfig
    }

    stages {
        stage('Setup Minikube Docker') {
            steps {
                script {
                    sh "eval \$(minikube docker-env)"  // ✅ Use Minikube's Docker
                }
            }
        }

        stage('Clean Workspace') {
            steps {
                script {
                    echo "Cleaning workspace..."
                    deleteDir()
                }
            }
        }

        stage('Git Checkout') {
            steps {
                script {
                    git branch: 'main', 
                        credentialsId: 'github_seccred', 
                        url: 'https://github.com/Kiruba-Prakasan/final_repo.git'
                }
            }
        }

        stage('Docker Build & Push to Minikube') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${TAG} ."
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    sh "kubectl apply --validate=false -f ${DEPLOYMENT_FILE}"
                }
            }
        }
    }

    post {
        success {
            script {
                def minikube_ip = sh(script: 'minikube ip', returnStdout: true).trim()
                echo "✅ Deployment Successful! Website is live at http://${minikube_ip}:30080"
            }
        }
        failure {
            echo "❌ Deployment Failed! Check logs for errors."
        }
    }
}
