pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/NiranjithaGaneshan/laravel-php-app.git'
            }
        }

        stage('Build and Start Containers') {
            steps {
                bat 'docker-compose up -d --build'
            }
        }

        stage('Composer Install') {
            steps {
                bat 'docker exec app01 composer install'
            }
        }

        stage('Permissions Fix') {
            steps {
              bat 'docker exec --user root app01 chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache || exit 0'

            }
        }

        stage('Environment Setup') {
            steps {
                bat '''
                    docker exec app01 cp .env.example .env
                    docker exec app01 php artisan key:generate
                '''
            }
        }

        stage('Database Migration') {
            steps {
                bat 'docker exec app01 php artisan migrate'
            }
        }

        stage('Permissions Fix (optional)') {
            steps {
                bat 'docker exec app01 chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache'
            }
        }
    }
}
