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
                sh 'npm run build'
                
            }
        }
        stage('Test') { 
            steps {
                sh './jenkins/scripts/test.sh' 
                echo "Workspace Contents:"
                sh 'ls -R'

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




                        // Copy semua file dari folder 'build' ke '/react' di server
                        sshPut remote: remote, from: 'build/', into: '/react'

                        // Copy file 'package.json' ke '/react' di server
                        sshPut remote: remote, from: 'package.json', into: '/react'

                        // Copy file 'jenkins/scripts/deliver.sh' ke '/react' di server
                        sshPut remote: remote, from: 'jenkins/scripts/deliver.sh', into: '/react'

                        // Copy file 'jenkins/scripts/deliver.sh' ke '/react' di server
                        sshPut remote: remote, from: 'jenkins/scripts/kill.sh', into: '/react'

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
}
