pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'kraj234/SampleDeployApp'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }
        
        stage('Build .NET Project') {
            steps {
                echo 'Building .NET project...'
                script {
                    dir('SomeRubbishAPI') {
                        bat "dotnet restore"
                        bat "dotnet build --configuration Release"
                    }
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                script {
                    dir('SampleDeployApp') {
                        bat "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} -t ${DOCKER_IMAGE}:latest ."
                    }
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing Docker image to Docker Hub...'
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker_credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        bat "docker login -u %DOCKER_USER% -p %DOCKER_PASS%"
                        bat "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"
                        bat "docker push ${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Docker Desktop Kubernetes...'
                script {
                    withCredentials([file(credentialsId: 'kube-config', variable: 'KUBECONFIG')]) {
                        bat "kubectl apply -f backend-deploy.yml --kubeconfig=%KUBECONFIG%"
                        bat "kubectl rollout restart deployment/somerubbishapi-deployment --kubeconfig=%KUBECONFIG%"
                        bat "kubectl rollout status deployment/somerubbishapi-deployment --kubeconfig=%KUBECONFIG%"
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo 'Build, Docker image creation, push, and deployment successful!'
            echo 'API accessible at http://localhost:7155'
            echo 'Products endpoint: http://localhost:7155/api/Products'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}