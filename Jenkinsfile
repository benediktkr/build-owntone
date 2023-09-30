pipeline {
    agent any
    parameters {
        booleanParam(name: "use_github", defaultValue: false, description: "use github repos")
        booleanParam(name: "rebase_filescans", defaultValue: false, description: "rebase branch for owntone-server#1179 from github:whatdoineed2do/forked-daapd")
        booleanParam(name: "build_web", defaultValue: true, description: "build web ui from source with modified websocket url")
        booleanParam(name: "web_dark_reader", defaultValue: true, description: "add css from DarkReader (work in progress)")
        booleanParam(name: "web_ws_url", defaultValue: true, description: "change wsUrl in the frontend so it access the websocket over https on /ws (on the same port) -- requires using a reverse proxy")
    }
    options {
        timestamps()
        ansiColor("xterm-256color")
        disableConcurrentBuilds()
        buildDiscarder(logRotator(daysToKeepStr: '30', numToKeepStr: '10', artifactNumToKeepStr: '1'))
    }
    environment {
        GIT_CONFIG_PARAMETERS = "'color.ui=always' 'advice.detachedHead=false'"
        OWNTONE_USE_GITHUB = params.use_github.toString()
        OWNTONE_REBASE_FILESCANS = params.rebase_filescans.toString()
        OWNTONE_BUILD_WEB = params.build_web.toString()
        OWNTONE_WEB_DARK_READER = params.web_dark_reader.toString()
        OWNTONE_WEB_WS_URL = params.web_ws_url.toString()
        FORCE_COLOR="1"
    }
    stages {
        stage('checkout') {
            steps {
                // sh ".jenkins/init-git.sh"

                script {
                    String OWNTONE_main_branch = "master"
                    String repo_url = params.use_github ? "https://github.com/owntone" : "https://git.sudo.is/mirrors"

                    dir('owntone-server') {
                        git(url: repo_url + "/owntone-server", branch: OWNTONE_main_branch)
                        env.OWNTONE_VERSION = sh(script: "git describe --tags --abbrev=0", returnStdout: true).trim()
                        //sh "git config --worktree advice.detachedHead false"
                        sh "git checkout ${env.OWNTONE_VERSION}"

                        if (params.rebase_filescans) {
                            sh "build/git-rebase-filescans.sh"
                        }
                    }

                    currentBuild.displayName += " - ${env.OWNTONE_VERSION}"
                    currentBuild.description = "OwnTone v${env.OWNTONE_VERSION}"
                    writeFile(file: "dist/owntone_version.txt", text: env.OWNTONE_VERSION)
                    sh "ls --color=always -l"
                }
                sh "env | grep OWNTONE"
            }
        }

        stage('build owntone-web') {
            when {
                expression { params.build_web == true }
            }
            steps {
                sh "build/build-owntone-web.sh"
            }
        }
        stage('build owntone-server') {
            steps {
                sh "build/build-owntone-server.sh"
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
