pipeline {
    agent any

    environment {
        APP_CONTAINER = "app01"
    }

    stages {
        stage('Docker Compose Up') {
            steps {
                bat 'docker-compose down || exit 0'
                bat 'docker-compose build'
                bat 'docker-compose up -d'
            }
        }

        stage('Wait for MySQL') {
            steps {
                echo 'Waiting for MySQL to be ready...'
                bat 'timeout /t 25'
            }
        }

        stage('Composer Install') {
            steps {
                bat "docker exec %APP_CONTAINER% composer install"
            }
        }

        stage('Set Permissions') {
            steps {
                bat "docker exec %APP_CONTAINER% chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache || exit 0"
            }
        }

        stage('Generate App Key') {
            steps {
                bat "docker exec %APP_CONTAINER% cp .env.example .env || exit 0"
                bat "docker exec %APP_CONTAINER% php artisan key:generate"
            }
        }

        stage('Run Migrations') {
            steps {
                bat "docker exec %APP_CONTAINER% php artisan migrate"
            }
        }
    }
}
