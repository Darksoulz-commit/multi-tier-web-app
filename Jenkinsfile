pipeline {
    agent any

    enviroment {
        IMAGE_TAG = "v$env.BILD_NUMBER}"
    }

    parameters {
        choice(name: 'ENV', choices: ['test', 'dev', 'prod'], description: 'Deploy panna pora enviroment')
    }
    
    stages {
        stage('Build Docker image') {
            steps {
                // Image-a unga Docker Hub perula build panrom
                sh 'docker build -t navi561/multi-tier-app:latest .'
            }
        }
        
        // PUTHU STAGE: Image-a Docker Hub-kku anuppurathu
        stage('Push to Docker Hub') {
            steps {
                // Namma set panna credentials-a use panni login panrom
                withCredentials([usernamePassword(credentialsId: 'Docker_Hub', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push navi561/multi-tier-app:${IMAGE_TAG}'
                }
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
                    docker run -d -p 8002:8000 --name my-app-test navi561/multi-tier-app:latest
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
                    docker run -d -p 8001:8000 --name my-app-dev navi561/multi-tier-app:latest
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
                    docker run -d -p 8000:8000 --name my-app-prod navi561/multi-tier-app:latest
                '''
            }
        }
    }
}