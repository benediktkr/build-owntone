#!/bin/bash
set -e

source build/.colors.env

usage() {
    echo_var FOO
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
    echo -e
    echo -e "${YELLOW}Environment variables${NC}:"
    arg "OWNTONE_VERSION" "         " "Manually specify version (or tag/commit/branch) to"
    echo -e "                          to build (default: newest tag in owntone-server)"
    arg "GITEA_USERNAME" "          " "Username for git.sudo.is, to publish builds (takes"
    echo -e "                          precedence over --gitea-user"
    arg "GITEA_SECRET" "            " "API token to upload bilds to git.sudo.is"
    echo -e
    exit 2
}

for arg in "$@"; do
    case $arg in
        -h|--help)
            usage
            ;;
        --use-github)
            OWNTONE_USE_GITHUB="true"
            shift
            ;;
        --rebase-filescans)
            OWNTONE_REBASE_FILESCANS="true"
            shift
            ;;
        --no-build-web)
            OWNTONE_BUILD_WEB="false"
            shift
            ;;
        --no-web-dark-reader)
            OWNTONE_WEB_DARK_READER="false"
            shift
            ;;
        --no-web-ws-url)
            OWNTONE_WEB_WS_URL="false"
            shift
            ;;
        --publish)
            OWNTONE_PUBLISH="true"
            shift
            ;;
        -u|--owntone-uid)
            shift
            OWNTONE_UID=$1
            shift
            ;;
        -g|--owntone-gid)
            shift
            OWNTONE_GID=$1
            shift
            ;;
        *)
            echo "unkonwn arg: '$1'"
            exit 1
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
if [[ "${OWNTONE_PUBLISH}" != "false" ]]; then
    echo_stage "publish"
    build/publish.sh
else
    echo_skipped "publish"
fi






