pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/your-username/your-forked-repo.git'
            }
        }

        stage('Build and Start Containers') {
            steps {
                sh 'docker-compose up -d --build'
            }
        }

        stage('Composer Install') {
            steps {
                sh 'docker exec app01 composer install'
            }
        }

        stage('Environment Setup') {
            steps {
                sh '''
                    docker exec app01 cp .env.example .env || true
                    docker exec app01 php artisan key:generate
                '''
            }
        }

        stage('Database Migration') {
            steps {
                sh 'docker exec app01 php artisan migrate'
            }
        }

        stage('Permissions Fix (optional)') {
            steps {
                sh 'docker exec app01 chmod -R 775 storage bootstrap/cache'
            }
        }
    }
}
