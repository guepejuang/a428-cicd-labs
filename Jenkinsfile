pipeline {
    agent any

    tools {
        nodejs 'Node_16'
    }
    stages {
        stage('Login to Docker') {
            steps {
                script {
                    // Nama registry Docker
                    def dockerRegistry = 'docker.io'
                    // Nama pengguna Docker
                    def dockerUsername = 'kosih'
                    // Kata sandi Docker
                    def dockerPassword = 'dckr_pat_9pw4LY1LZYDpmBF-aofoblU8QCQ'

                    // Eksekusi perintah docker login
                    sh "echo ${dockerPassword} | docker login --username ${dockerUsername} --password-stdin ${dockerRegistry}"
                }
            }
        }
        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }
        stage('Test') { 
            steps {
                sh './jenkins/scripts/test.sh' 

            }
        }
        stage('Build Docker') {
            steps {
                script {
                    // Build Docker image 
                    sh 'docker build -t a428-cicd-labs .'
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    // Push Docker image to Docker Hub
                    sh 'docker push a428-cicd-labs'
                }
            }
        }
        stage('Manual Approval') {
            steps {
                script {
                    // Menunggu persetujuan manual
                    input message: 'Yakin akan melanjutkan proses deployment?'
                }
            }
        }
        stage('Sleep') {
            steps {
                // Menunggu 1 menit
                sleep time: 1, unit: 'MINUTES'
            }
        }
        stage('Deploy') {
            steps {
                script {
                    def remote = [:]
                    remote.name = 'Server'
                    remote.host = '172.16.138.59'
                    remote.user = 'root'
                    remote.password = 'L0calp@ssword'
                    remote.allowAnyHosts = true

                    // ... (sama seperti sebelumnya)

                    // Pull Docker image and run on SSH server (replace 'a428-cicd-labs' with your actual image name)
                    sshCommand remote: remote,
                                command: 'docker pull a428-cicd-labs && docker run -d -p 3400:3400 a428-cicd-labs',
                                failonerror: true
                }
            }
        }
        
    }
}
