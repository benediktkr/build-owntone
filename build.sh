#!/bin/bash
set -e

source build/.colors.env

usage() {
    echo -e "${CYAN}usage${NC}: ${PURPLE}${0}${NC} ${BLUE}[ARGUMENTS]${NC}"
    echo
    echo -e "${YELLOW}Arguments${NC}:"
    arg "--use-github" "            " "Use the upstream https://github.com/owntone/owntone-server"
    echo -e "                          repo (default: false, use"
    echo -e "                          https://git.sudo.is/mirrors/owntone-server)"
    arg "--rebase-filescans" "      " "Build with support for partial library scans. Rebases branch"
    echo -e "                          for owntone-server#1179 from"
    echo -e "                          github:whatdoineed2do/forked-daapd (default: false)"
    arg "--no-build-web" "          " "Don't build the OwnTone Web UI, use the build in"
    echo -e "                          owntone-server/htdocs/"
    arg "--no-web-dark-reader" "    " "Don't add dark-reader.css for dark theme (work in progress)"
    arg "--no-web-ws-url" "         " "Don't change the url that the OwnTone Web"
    echo -e "                          UI uses for the websocket"
    arg "--owntone-uid" "           " "Set uid for owntone user (default: '$(id -u)')"
    arg "--owntone-gid" "           " "Set gid for owntone user (default: '$(id -g)')"
    arg "--publish" "               " "Publish new versions (default: false)"
    arg "--force-publish" "         " "Always publish builds (default: false)"
    arg "--gitea-user" "            " "Username for git.sudo.is, for uploding builds"
    echo -e
    echo -e "${YELLOW}Environment variables${NC}:"
    arg "OWNTONE_VERSION" "         " "Manually specify version (or tag/commit/branch) to"
    echo -e "                          to build (default: newest tag in owntone-server)"
    arg "GITEA_USER" "              " "Username for git.sudo.is, to publish builds (if "
    echo -e "                          specified, --gitea-user will take presedence)"
    arg "GITEA_SECRET" "            " "API token to upload bilds to git.sudo.is"
    echo -e
}

for arg in "$@"; do
    case $arg in
        -h|--help)
            usage
            exit 0
            ;;
        --use-github)
            OWNTONE_USE_GITHUB="true"
            export OWNTONE_USE_GITHUB
            shift
            ;;
        --rebase-filescans)
            OWNTONE_REBASE_FILESCANS="true"
            export OWNTONE_REBASE_FILESCANS
            shift
            ;;
        --no-build-web)
            OWNTONE_BUILD_WEB="false"
            export OWNTONE_BUILD_WEB
            shift
            ;;
        --no-web-dark-reader)
            OWNTONE_WEB_DARK_READER="false"
            export OWNTONE_WEB_DARK_READER
            shift
            ;;
        --no-web-ws-url)
            OWNTONE_WEB_WS_URL="false"
            export OWNTONE_WEB_WS_URL
            shift
            ;;
        --publish)
            OWNTONE_PUBLISH="true"
            export OWNTONE_PUBLISH
            shift
            ;;
        --force-publish)
            OWNTONE_FORCE_PUBLISH="true"
            export OWNTONE_FORCE_PUBLISH
            shift
            ;;
        -u|--owntone-uid)
            shift
            OWNTONE_UID=$1
            export OWNTONE_UID
            shift
            ;;
        -g|--owntone-gid)
            shift
            OWNTONE_GID=$1
            export OWNTONE_GID
            shift
            ;;
        --gitea-user)
            shift
            GITEA_USER=$1
            export GITEA_USER
            shift
            ;;
        *)
            usage
            echo_red "unkonwn arg: '$1'"
            exit 3

        esac
done


#
# This part is equivalent to the "checkout" stage in the Jenkinsfile
#
echo_stage "Checkout"
build/git-init.sh
source build/version.sh
echo ${OWNTONE_VERSION} > dist/owntone_version.txt
build/git-checkout-version.sh

#
# Jenkinsfile stage: 'rebase filescans'
#
if [[ "${OWNTONE_REBASE_FILESCANS}" == "true" ]]; then
    echo_stage "rebase filescans"
    build/git-rebase-filescans.sh
else
    echo_skipped "rebase filescans"
fi

#
# Jenkisfile stage: 'build owntone-web'
#
if [[ "${OWNTONE_BUILD_WEB}" != "false" ]]; then
    echo_stage "build owntone-web"
    build/build-owntone-web.sh
else
    echo_skipped "build owntone-web"
fi

#
# Jenknsfile stage: 'build owntone-server'
#
echo_stage "build owntone-server"
build/build-owntone-server.sh


#
# Jenkinsfile stage: 'publish'
#
if [[ "${OWNTONE_PUBLISH}" == "true" || "${OWNTONE_FORCE_PUBLISH}" == "true" ]]; then
    echo_stage "publish"
    build/publish.sh
else
    echo_skipped "publish"
fi






