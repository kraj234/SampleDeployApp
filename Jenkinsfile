pipeline {
    agent any

    environment {
        GIT_REPO   = "https://github.com/kraj234/SampleDeployApp.git"
        GIT_BRANCH = "master"
        DOCKER_IMAGE = "kraj234/sampledeployapp"      // must be lowercase
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out repository..."
                git branch: "${GIT_BRANCH}", url: "${GIT_REPO}"
            }
        }

        stage('Build .NET Project') {
            steps {
                echo "Building .NET project..."
                dir("SampleDeployApp") {       // 👈 Correct folder name
                    bat "dotnet restore"
                    bat "dotnet build --configuration Release"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                dir("SampleDeployApp") {       // 👈 Dockerfile is *inside* this folder
                    bat """
                        docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ^
                                     -t ${DOCKER_IMAGE}:latest .
                    """
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                withCredentials([
