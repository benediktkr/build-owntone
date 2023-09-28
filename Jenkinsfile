pipeline {
    agent any
    parameters {
        booleanParam(name: "rebase_filescans", defaultValue: false, description: "rebase branch for owntone-server#1179 from github:whatdoineed2do/forked-daapd")
        booleanParam(name: "dark_reader", defaultValue: false, description: "add css from DarkReader (work in progress)")
        booleanParam(name: "build_web", defaultValue: true, description: "build web ui from source with modified websocket url")
        booleanParam(name: "use_github", defaultValue: false, description: "use github repos")
    }  
    options {
        timestamps()
        ansiColor("xterm")
        disableConcurrentBuilds()
        buildDiscarder(logRotator(daysToKeepStr: '30', numToKeepStr: '10', artifactNumToKeepStr: '1'))
    }
    stages {
        stage('checkout') {
            steps { 
                // sh ".jenkins/init-git.sh"

                script {
                    String ot_main_branch = "master"
                    String repo_url = params.use_github ? "https://github.com/owntone" : "https://git.sudo.is/mirrors"
                
                    dir('owntone-server') {
                        git(url: repo_url + "/owntone-server", branch: ot_main_branch)
                        env.OWNTONE_VERSION = sh(script: "git describe --tags --abbrev=0", returnStdout: true)
                        sh "git config --worktree advice.detachedHead false"
                        sh "git checkout ${env.OWNTONE_VERSION}"
                    }
                    
                    
                    if (params.rebase_filescans) { 
                        dir("owntone-server") {
                            sh "git remote add whatdoineed2d https://github.com/whatdoineed2do/forked-daapd"
                            sh "git fetch whatdoineed2do file-scan-dir-path"
                            sh "git rebase file-scan-dir-path"
                        }
                    }
                    
                    currentBuild.displayName += " - ${env.OWNTONE_VERSION}"
                    currentBuild.description = "OwnTone v${env.OWNTONE_VERSION}"
                    writeFile(file: "dist/owntone_version.txt", text: env.OWNTONE_VERSION)
                    sh "ls --color=always -l" 
                }
            }
        }   
    }
    post {
        success {
            archiveArtifacts(artifacts: "dist/*.tar.gz,dist/*.deb,dist/*.zip,dist/owntone_version.txt", fingerprint: true)
        }
        cleanup {
            cleanWs(deleteDirs: true, disableDeferredWipeout: true, notFailBuild: true)
        }
   } 
}
