pipeline {
    agent any

    environment {
        DEV_SERVER = "54.227.31.24"
        STG_SERVER = "13.218.132.220"
        PRD_SERVER = "54.167.115.131"
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

                    else if (env.BRANCH_NAME == "stage") {
                        deployApp(STG_SERVER)
                    }

                    else if (env.BRANCH_NAME == "production") {
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
    sudo docker stop myapp || true
    sudo docker rm myapp || true
    sudo docker rmi myapp || true

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

    sudo docker build --no-cache -t myapp .
    sudo docker run -d -p 8080:80 --name myapp myapp
    
    '
    """
}
