pipeline {
    agent any

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/NiranjithaGaneshan/laravel-php-app.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'composer install'
            }
        }

        stage('Set Permissions') {
            steps {
                sh 'chmod -R 777 storage bootstrap/cache'
            }
        }

        stage('Generate App Key') {
            steps {
                sh 'cp .env.example .env || true'
                sh 'php artisan key:generate'
            }
        }

        stage('Run Tests') {
            steps {
                sh './vendor/bin/phpunit || true'
            }
        }

        stage('Build Docker') {
            steps {
                sh 'docker-compose down || true'
                sh 'docker-compose build'
                sh 'docker-compose up -d'
            }
        }
    }
}

