pipeline {
    agent any

    environment {
        APP_CONTAINER = "app01"
    }

    stages {
        stage('Checkout Code') {
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

        stage('Wait for MySQL') {
    steps {
        bat '''
            echo Waiting for MySQL to be ready...
            docker exec app01 sh -c "until mysqladmin ping -h db01 --silent; do sleep 5; done"
        '''
    }
}


        stage('Composer Install') {
            steps {
                bat "docker exec %APP_CONTAINER% composer install"
            }
        }

        stage('Permissions') {
            steps {
                bat "docker exec %APP_CONTAINER% chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache || exit 0"
            }
        }

        stage('App Key Generate') {
            steps {
                bat "docker exec %APP_CONTAINER% cp .env.example .env || exit 0"
                bat "docker exec %APP_CONTAINER% php artisan key:generate"
            }
        }

        stage('Migrate') {
            steps {
                bat "docker exec %APP_CONTAINER% php artisan migrate"
            }
        }
    }
}
