pipeline {
    agent any

    environment {
        STG_SERVER = "3.110.197.140"
        PRD_SERVER = "13.234.32.42"
        USER = "ec2-user"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Deploy to stage') {
            when { branch 'stage' }
            steps {
                sh '''
                scp -o StrictHostKeyChecking=no index.html $USER@$DEV_SERVER:/tmp/index.html
                ssh -o StrictHostKeyChecking=no $USER@$stage_SERVER "
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
