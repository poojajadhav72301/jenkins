pipeline {
    agent any

    environment {
       STG_SERVER = "54.163.56.145"
       PRD_SERVER = "3.91.150.78"
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

                    if (env.BRANCH_NAME == "stage") {
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

def deployApp() {
    sh """
    ssh -o StrictHostKeyChecking=no ec2-user@54.163.56.145 '
    
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
    scp -o StrictHostKeyChecking=no -r * ec2-user@54.163.56.145:/home/ec2-user/app/

    # Build and run on server
    ssh -o StrictHostKeyChecking=no ec2-user@54.163.56.145 '
    
    cd /home/ec2-user/app

    docker build -t myapp .
    docker run -d -p 80:80 --name myapp myapp
    
    '
    """
}
