pipeline {
    agent any
    tools {
        jdk 'jdk21'
        nodejs 'node20'
    }

    environment {
        IMAGE_NAME = "kirubarp/final_repo"  // Your Docker repository
        CONTAINER_NAME = "static_website_container"
        TAG = "latest"
        HOST_PORT = "9090"  // Change this to your preferred port
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
                        sh "docker build -t ${IMAGE_NAME} ."
                        sh "docker tag ${IMAGE_NAME} ${IMAGE_NAME}:${TAG}"
                        sh "docker push ${IMAGE_NAME}:${TAG}"
                    }
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    // Stop and remove existing container if running
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"

                    // Run the new container on a different port
                    sh "docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:80 ${IMAGE_NAME}:${TAG}"
                }
            }
        }
    }

    post {
        success {
            echo "Deployment Successful! Website is live at http://<server-ip>:${HOST_PORT}"
        }
        failure {
            echo "Deployment Failed! Check logs for errors."
        }
    }
}

