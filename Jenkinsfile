pipeline {
    agent any

    environment {
        APP_CONTAINER = "app01"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', credentialsId: 'github-token', url: 'https://github.com/NiranjithaGaneshan/laravel-php-app.git'
            }
        }

        stage('Docker Compose Up') {
            steps {
                bat 'docker-compose down || exit 0'
                bat 'docker-compose build'
                bat 'docker-compose up -d'
            }
        }

        stage('Wait for MySQL to be Ready') {
            steps {
                bat '''
                    echo Waiting for MySQL to be ready...
                    docker exec app01 sh -c "until mysqladmin ping -h db01 --silent; do sleep 2; done"
                '''
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
