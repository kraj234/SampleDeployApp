pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'kraj234/SampleDeployApp'
        IMAGE_TAG = "${BUILD_NUMBER}"
        GIT_REPO = 'https://github.com/kraj234/SampleDeployApp.git'
        GIT_BRANCH = 'main'  // Change to 'master' if that's your default branch
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                git branch: "${GIT_BRANCH}", 
                    url: "${GIT_REPO}"
            }
        }
        
        stage('Build .NET Project') {
            steps {
                echo 'Building .NET project...'
                script {
                    dir('SampleDeployApp') {
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
        
        // Deployment stage skipped
        // stage('Deploy to Kubernetes') {
        //     steps {
        //         echo 'Deploying to Docker Desktop Kubernetes...'
        //         script {
        //             withCredentials([file(credentialsId: 'kube-config', variable: 'KUBECONFIG')]) {
        //                 bat "kubectl apply -f backend-deploy.yml --kubeconfig=%KUBECONFIG%"
        //                 bat "kubectl rollout restart deployment/somerubbishapi-deployment --kubeconfig=%KUBECONFIG%"
        //                 bat "kubectl rollout status deployment/somerubbishapi-deployment --kubeconfig=%KUBECONFIG%"
        //             }
        //         }
        //     }
        // }
    }
    
    post {
        success {
            echo 'Build, Docker image creation, and push successful!'
            echo 'Docker image: ${DOCKER_IMAGE}:${IMAGE_TAG}'
            echo 'Docker image: ${DOCKER_IMAGE}:latest'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}