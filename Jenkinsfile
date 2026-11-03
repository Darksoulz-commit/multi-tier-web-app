pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t multi-tier-app .'
            }
        }
        stage('Deploy to EC2') {
            steps {
                sh '''
                    docker stop my-app || true
                    docker rm my-app || true
                    docker run -d -p 8000:8000 --name my-app multi-tier-app
                '''
            }
        }
    }
}