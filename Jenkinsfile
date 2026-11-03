pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['test', 'dev', 'prod'], description: 'Deploy pana pora enviroment')
    }
    stages {
        stage('Build Docker image') {
            steps {
                sh 'docker build -t multi-tier-app .'
            }
        }
        stage('Deploy to TEST') {
            when {
                expression {params.ENV == 'test'}
            }
            steps {
                echo 'Deploying to TEST Environment...'
                sh '''
                    docker stop my-app-test || true
                    docker rm my-app-test || true
                    docker run -d -p 8001:8000 --name my-app-dev multi-tier-app
                '''
            }
        }
        stage('Deploy to DEV') {
            when {
                expression {params.ENV == 'dev'}
            }
            steps {
                echo 'Deploying to DEV Environment...'
                sh '''
                    docker stop my-app-dev || true
                    docker rm my-app-dev || true
                    docker run -d -p 8001:8000 --name my-app-dev multi-tier-app
                '''
            }
        }
        stage('Deploy to PROD') {
            when {
                expression {params.ENV == 'prod'}
            }
            steps {
                echo 'Deploying to PROD Environment...'
                sh '''
                    docker stop my-app-prod || true
                    docker rm my-app-prod || true
                    docker run -d -p 8001:8000 --name my-app-dev multi-tier-app
                '''
            }
        }
    }
}