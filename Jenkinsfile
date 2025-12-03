pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kraj234/sampledeployapp"
        IMAGE_TAG = "${BUILD_NUMBER}"
        GIT_REPO = "https://github.com/kraj234/SampleDeployApp.git"
        GIT_BRANCH = "master"
		DOCKER_BUILDKIT = "0"
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
        echo 'Building Docker image...'
        bat """
        set DOCKER_BUILDKIT=0
        docker build -t kraj234/sampledeployapp:24 -t kraj234/sampledeployapp:latest .
        """
    }
}


        stage('Push to Docker Hub') {
            steps {
                echo "Pushing Docker images to Docker Hub..."

                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker_credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    bat """
                        echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                        docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
                        docker push ${DOCKER_IMAGE}:latest
                    """
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
