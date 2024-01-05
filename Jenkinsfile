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
                    sh 'docker build -t kosih/a428-cicd-labs .'
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    // Push Docker image to Docker Hub
                    sh 'docker push kosih/a428-cicd-labs'
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

                    // Menghentikan container dengan nama react-cicd
                    sshCommand remote: remote,
                                command: 'docker stop react-cicd || true',
                                failonerror: false

                    // Menghapus image kosih/a428-cicd-labs
                    sshCommand remote: remote,
                                command: 'docker rmi kosih/a428-cicd-labs || true',
                                failonerror: false

                    // Pull Docker image dan jalankan docker
                    sshCommand remote: remote,
                                command: 'docker pull kosih/a428-cicd-labs && docker run -d -p 3400:3000 --name react-cicd kosih/a428-cicd-labs',
                                failonerror: true
                }
            }
        }
        
    }
}
