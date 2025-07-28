pipeline {
    agent any

    environment {
        APP_CONTAINER = "app01"
    }

    stages {
        stage('Pull Code') {
            steps {
                git credentialsId: 'github-token', url: 'https://github.com/NiranjithaGaneshan/laravel-php-app.git'
            }
        }

        stage('Docker Compose Up') {
            steps {
                bat 'docker-compose down -v || exit 0'
                bat 'docker-compose up -d --build'
            }
        }

        stage('Wait for MySQL') {
            steps {
                echo 'Waiting for MySQL to start...'
                bat 'timeout /t 30 /nobreak >nul'
            }
        }

        stage('Composer Install') {
            steps {
                bat 'docker exec app01 composer install'
            }
        }

        stage('Permissions') {
            steps {
                bat 'docker exec app01 chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache || exit 0'
            }
        }

        stage('App Key Generate') {
            steps {
                bat 'docker exec app01 cp .env.example .env || exit 0'
                bat 'docker exec app01 php artisan key:generate'
            }
        }

        stage('Migrate') {
            steps {
                bat 'docker exec app01 php artisan migrate'
            }
        }
    }
}
