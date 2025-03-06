pipeline {
    agent any

    environment {
        KEYSTORE_DIR="./cert_mgmt/keystores"
        CERT_DIR="./cert_mgmt/certificates"
        KEYSTORE="test01Keystore.jks"
        PKCS_KEYSTORE_DIR="./certs/p12_cert"
        PKCS_KEYSTORE="test01Keystore.p12"
        PEM_KEYSTORE_DIR="./certs/pem_cert"
        PEMDEC_KEYSTORE_DIR="./certs/dec_cert"
        PEM_KEYSTORE="test01Keystore.pem"
        STOREPASS="admin123"
        KEYPASS="admin123"
        ALIAS_PREFIX="vishal_dev"
        CERT_ALIAS="vishal_dev_1"

        AWS_REGION = 'us-east-1'  // Replace with your AWS region
        ECR_REPO_NAME = 'node-app-repo'  // Replace with your ECR repository name
        ECS_CLUSTER_NAME = 'node-app-cluster'  // Replace with your ECS cluster name
        ECS_SERVICE_NAME = 'node-app-service'  // Replace with your ECS service name
        ECS_TASK_DEFINITION = 'node-app-task'  // Replace with your ECS task definition
        registryCredential = 'ecr:us-east-1:awscreds'
        appRegistry = "296062569588.dkr.ecr.us-east-1.amazonaws.com/node-app-repo"
        moveinRegistry = "https://296062569588.dkr.ecr.us-east-1.amazonaws.com"

        PEM_SECRET = credentials('PEM_FILE')  // GitHub secret containing the base64 encoded PEM file
    }

    stages {
        stage('Fetch code') {
            steps {
               git branch: 'main', url: 'https://github.com/svishal16/node-app.git'
            }
        }

        stage('Generate Certificates') {
            steps{
                sh 'chmod +x ./cert_mgmt/gen_cert.sh'
                sh './cert_mgmt/gen_cert.sh'
            }
        }

        stage('Checking Certificate Expiry') {
            steps{
                sh 'chmod +x ./cert_mgmt/cert_exp.sh'
                sh './cert_mgmt/cert_exp.sh'
            }
        }

        stage('Export to PKCS12') {
            steps{
                sh 'chmod +x ./cert_mgmt/export.sh'
                sh './cert_mgmt/export.sh'
            }
        }

        stage('Retrieve and Decode PEM') {
            steps {
                script {
                    mkdir -p ./certs/dec_cert
                    // Decode the PEM file from base64 GitHub secret
                    writeFile file: "$PEMDEC_KEYSTORE_DIR/$PEM_KEYSTORE", text: sh(script: "echo ${env.PEM_SECRET} | base64 --decode", returnStdout: true)
                    echo "PEM file successfully decoded."
                }
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
