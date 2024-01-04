pipeline {
    agent {
        docker {
            image 'node:16-buster'
            args '-p 3004:3004'
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
        stage('Deploy') { 
            steps {
                retry(3){
                    def remote = [:]
                    remote.name = 'Server'
                    remote.host = '172.16.138.59'
                    remote.user = 'root'
                    remote.password = 'L0calp@ssword'
                    remote.allowAnyHosts = true

                    // Copy semua file dari folder 'build' ke '/react' di server
                    sshPut remote: remote, from: 'build/**', into: '/react/'

                    // Copy file 'jenkins/scripts/deliver.sh' ke '/react' di server
                    sshPut remote: remote, from: 'jenkins/scripts/deliver.sh', into: '/react/'

                    // Copy file 'jenkins/scripts/deliver.sh' ke '/react' di server
                    sshPut remote: remote, from: 'jenkins/scripts/kill.sh', into: '/react/'

                    // Eksekusi deliver.sh
                    sshCommand remote: remote,
                                command: 'cd /react && chmod +x deliver.sh && ./deliver.sh',
                                failonerror: true

                    // Menunggu input dari pengguna sebelum melanjutkan
                    input message: 'Finished using the website? (Click "Proceed" to continue)'

                    // Eksekusi kill.sh setelah mendapat input dari pengguna
                    sshCommand remote: remote,
                                command: 'cd /react && chmod +x kill.sh && ./kill.sh',
                                failonerror: true

                }
            }
        }
        
    }
}
