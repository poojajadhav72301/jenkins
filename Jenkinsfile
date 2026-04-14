pipeline {
    agent any

    environment {
        STG_SERVER = "52.91.43.161"
        PRD_SERVER = "3.88.228.242"
        USER = "ec2-user"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Deploy to STG') {
            when { branch 'stage' }
            steps {
                sh '''
                scp -o StrictHostKeyChecking=no index.html $USER@$STG_SERVER:/tmp/index.html
                ssh -o StrictHostKeyChecking=no $USER@$STG_SERVER "
                    sudo yum install httpd -y
                    sudo systemctl start httpd
                    sudo systemctl enable httpd
                    sudo cp /tmp/index.html /var/www/html/index.html
                    sudo systemctl restart httpd
                "
                '''
            }
        }

        stage('Deploy to PROD') {
            when { branch 'production' }
            steps {
                sh '''
                scp -o StrictHostKeyChecking=no index.html $USER@$PRD_SERVER:/tmp/index.html
                ssh -o StrictHostKeyChecking=no $USER@$PRD_SERVER "
                    sudo cp /tmp/index.html /var/www/html/index.html
                    sudo systemctl restart httpd
                "
                '''
            }
        }
    }
}
