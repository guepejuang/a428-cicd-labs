pipeline {
    agent {
        docker {
            image 'node:16-buster-slim'
            args '-p 3003:3003'
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') { 
            steps {
                sh './jenkins/scripts/test.sh' 
            }
        }
    }
}
