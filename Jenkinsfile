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
        OWNTONE_MAIN_BRANCH = "master"
        FORCE_COLOR="1"
    }
    stages {
        stage('checkout') {
            steps {
                // this stage does the same as build/init-git.sh, but in Jenkins it makes sense to let Jenkins handle git with its git-functions instead of a shell script
                script {

                    env.OWNTONE_GIT_URL = params.use_guithub ? "https://github.com/owntone" : "https://git.sudo.is/mirrors"
                    dir('owntone-server') {
                        git(url: env.OWNTONE_GIT_URL + "/owntone-server", branch: env.OWNTONE_MAIN_BRANCH)
                        env.OWNTONE_VERSION = sh(script: "../build/version.sh", returnStdout: true).trim()
                        sh "git checkout ${env.OWNTONE_VERSION}"
                    }
                    currentBuild.displayName += " - v${env.OWNTONE_VERSION}"
                    currentBuild.description = "OwnTone v${env.OWNTONE_VERSION}"
                    writeFile(file: "dist/owntone_version.txt", text: env.OWNTONE_VERSION)
                }
                sh "ls --color=always -l"
                sh "env | grep --color=always OWNTONE"
            }
        }
        stage('rebase filescans') {
            when {
                expression { params.rebase_filescans == true }
            }
            steps {
                sh "build/git-rebase-filescans.sh"
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
