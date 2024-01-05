pipeline {
    agent any

    tools {
        nodejs 'Node_16'
    }
    stages {
        stage('Install Zip') {
            steps {
                script {
                    // Install paket zip
                    sh 'sudo apt-get update && apt-get install -y zip'
                }
            }
        }
        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'

                // Eksekusi perintah zip untuk mengompres semua file dan folder di workspace
                sh "zip -r react.zip *"
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
                    script{
                        def remote = [:]
                        remote.name = 'Server'
                        remote.host = '172.16.138.59'
                        remote.user = 'root'
                        remote.password = 'L0calp@ssword'
                        remote.allowAnyHosts = true
                        

                       // Check apakah /react ada
                        def folderExists = sshCommand remote: remote, command: 'test -e /react && echo "true" || echo "false"'

                        if (folderExists.trim() == 'true') {
                            // If /react ada, Hapus file dan folder didalamnya
                            sshCommand remote: remote, command: 'find /react -mindepth 1 -delete'
                        } else {
                            // If /react tidak ada, Buatin
                            sshCommand remote: remote, command: 'mkdir -p /react'
                        }


                       

                        // Copy file 'package.json' ke '/react' di server
                        sshPut remote: remote, from: 'react.zip', into: '/react'

                       

                        // Eksekusi deliver.sh
                        sshCommand remote: remote,
                                    command: 'sh "unzip react.zip"',
                                    failonerror: true

                        // Eksekusi deliver.sh
                        sshCommand remote: remote,
                                    command: 'cd /react && chmod +x jenkins/scripts/deliver.sh && ./jenkins/scripts/deliver.sh',
                                    failonerror: true

                        // Menunggu input dari pengguna sebelum melanjutkan
                        input message: 'Finished using the website? (Click "Proceed" to continue)'

                        // Eksekusi jenkins/scripts/kill.sh setelah mendapat input dari pengguna
                        sshCommand remote: remote,
                                    command: 'cd /react && chmod +x jenkins/scripts/kill.sh && ./jenkins/scripts/kill.sh',
                                    failonerror: true
                    }

                }
            }
        }
        
    }
}
