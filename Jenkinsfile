pipeline {
    agent any
    tools {
        jdk 'jdk21'
        nodejs 'node20'
    }

    environment {
        IMAGE_NAME = "kirubarp/final_repo"  // Your Docker repository
        CONTAINER_NAME = "static-website-container"  // ✅ Fixed container name (no underscores)
        TAG = "latest"
        DEPLOYMENT_FILE = "deployment.yaml"  // Kubernetes deployment file
    }

    stages {
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
                        url: 'https://github.com/Kiruba-Prakasan/final_repo.git'  // Change to your repo URL
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                        sh "docker build -t ${IMAGE_NAME}:${TAG} ."
                        sh "docker push ${IMAGE_NAME}:${TAG}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh "kubectl apply -f ${DEPLOYMENT_FILE}"
                }
            }
        }
    }

    post {
        success {
            echo "Deployment Successful! Website is live at http://<k8s-cluster-ip>"
        }
        failure {
            echo "Deployment Failed! Check logs for errors."
        }
    }
}

