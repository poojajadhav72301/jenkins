pipeline {
    agent any

    environment {
        DEV_SERVER = "54.164.61.216"
        STG_SERVER = "34.201.99.182"
        PRD_SERVER = "52.87.171.158"
        USER = "ec2-user"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Deploy Based on Branch') {
            steps {
                script {

                    if (env.BRANCH_NAME == "dev") {
                        deployApp(DEV_SERVER)
                    }

                    else if (env.BRANCH_NAME == "stg") {
                        deployApp(STG_SERVER)
                    }

                    else if (env.BRANCH_NAME == "prd") {
                        deployApp(PRD_SERVER)
                    }
                }
            }
        }
    }
}

def deployApp(SERVER_IP) {
    sh """
    ssh -o StrictHostKeyChecking=no ec2-user@${SERVER_IP} '
    
    # Clean old app
    docker stop myapp || true
    docker rm myapp || true
    docker rmi myapp || true

    # Create app directory
    mkdir -p /home/ec2-user/app
    cd /home/ec2-user/app

    # Remove old files
    rm -rf *

    '
    
    # Copy project files to server
    scp -o StrictHostKeyChecking=no -r * ec2-user@${SERVER_IP}:/home/ec2-user/app/

    # Build and run on server
    ssh -o StrictHostKeyChecking=no ec2-user@${SERVER_IP} '
    
    cd /home/ec2-user/app

    docker build -t myapp .
    docker run -d -p 8081:80 --name myapp myapp
    
    '
    """
}
