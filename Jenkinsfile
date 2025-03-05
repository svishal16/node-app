pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'  // Replace with your AWS region
        ECR_REPO_NAME = 'node-app-repo'  // Replace with your ECR repository name
        ECS_CLUSTER_NAME = 'node-app-cluster'  // Replace with your ECS cluster name
        ECS_SERVICE_NAME = 'node-app-service'  // Replace with your ECS service name
        ECS_TASK_DEFINITION = 'node-app-task'  // Replace with your ECS task definition
        registryCredential = 'ecr:us-east-1:awscreds'
        appRegistry = "296062569588.dkr.ecr.us-east-1.amazonaws.com/node-app-repo"
        moveinRegistry = "https://296062569588.dkr.ecr.us-east-1.amazonaws.com"
    }

    stages {
        stage('Fetch code') {
            steps {
               git branch: 'main', url: 'https://github.com/svishal16/node-app.git'
            }
        }
        
        stage('Build App Image') {
            steps {
                script {
                    echo "Building new Docker image..."
                    dockerImage = docker.build( appRegistry + ":$BUILD_NUMBER", ".")
                }
            }
    
        }

        stage('Upload App Image') {
            steps{
                script {
                    echo "Logging into AWS ECR and Pushing new Docker image..."
                    docker.withRegistry( moveinRegistry, registryCredential ) {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Deploy to ecs') {
            steps {
                echo "Deploying to AWS ECS..."
                withAWS(credentials: 'awscreds', region: 'us-east-1') {
                    sh 'aws ecs update-service --cluster ${ECS_CLUSTER_NAME} --service ${ECS_SERVICE_NAME} --force-new-deployment'
                }
            }
        }

    }

    post {
        success {
            echo 'Deployment succeeded!'
        }

        failure {
            echo 'Deployment failed!'
        }
    }
}
