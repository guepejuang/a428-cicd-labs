pipeline {
    agent any

    tools {
        nodejs 'Node_16'
    }
    stages {
        
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
        stage('Login to Docker') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Docker_Credential', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script{
                        // Nama registry Docker
                        def dockerRegistry = 'docker.io'
                        // Nama pengguna Docker
                        def dockerUsername = DOCKER_USERNAME
                        // Kata sandi Docker
                        def dockerPassword = DOCKER_PASSWORD

                        // Eksekusi perintah docker login
                        sh "echo ${dockerPassword} | docker login --username ${dockerUsername} --password-stdin ${dockerRegistry}"
                    }
                }
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
        stage('Deploy') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'SSH_TO_SERVER', usernameVariable: 'SSH_USERNAME', passwordVariable: 'SSH_PASSWORD')]) {
                    script{
                    // Menunggu 1 menit
                        sleep time: 1, unit: 'MINUTES'


                        def remote = [:]
                        remote.name = 'Server'
                        remote.host = '172.16.138.59'
                        remote.user = SSH_USERNAME
                        remote.password = SSH_PASSWORD
                        remote.allowAnyHosts = true

                        // Menghentikan container dengan nama react-cicd
                        sshCommand remote: remote,
                                    command: 'docker stop react-cicd || true',
                                    failonerror: false

                        // Menghapus container dengan nama react-cicd
                        sshCommand remote: remote,
                                    command: 'docker rm react-cicd || true',
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
}
