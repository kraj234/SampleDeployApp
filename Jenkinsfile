pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kraj234/sampledeployapp"
        IMAGE_TAG = "${BUILD_NUMBER}"
        GIT_REPO = "https://github.com/kraj234/SampleDeployApp.git"
        GIT_BRANCH = "master"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out code from GitHub..."
                git branch: "${GIT_BRANCH}", url: "${GIT_REPO}"
            }
        }

        stage('Build .NET Project') {
            steps {
                echo "Building .NET project..."
                dir('SampleDeployApp') {
                    bat "dotnet restore"
                    bat "dotnet build --configuration Release"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                dir('SampleDeployApp') {
                    bat """
                        docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} -t ${DOCKER_IMAGE}:latest .
                    """
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Pushing Docker images to Docker Hub..."

                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    bat 'docker login -u %DOCKER_USER% -p %DOCKER_PASS%'

                    bat "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"
                    bat "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }
    }

    post {
        success {
            echo "Build, Docker image creation, and push successful!"
            echo "Docker: ${DOCKER_IMAGE}:${IMAGE_TAG}"
            echo "Docker: ${DOCKER_IMAGE}:latest"
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}
