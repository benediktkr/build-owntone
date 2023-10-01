#!/bin/bash
set -e

source build/.colors.env

usage() {

    FOO="show your tits, slut"
    echo_var FOO
    echo -e "${CYAN}usage${NC}: ${PURPLE}${0}${NC} ${BLUE}[ARGUMENTS]${NC}"
    echo
    echo -e "${YELLOW}Arguments${NC}:"
    arg "--use-github" "            " "use the upstream https://github.com/owntone/owntone-server"
    echo -e "                          repo (default: false, use"
    echo -e "                          https://git.sudo.is/mirrors/owntone-server)"
    arg "--rebase-filescans" "      "  "build with support for partial library scans. Rebases branch"
    echo -e "                          for owntone-server#1179 from"
    echo -e "                          github:whatdoineed2do/forked-daapd (default: false)"
    arg "--no-build-web" "          " "don't build the OwnTone Web UI, use the build in"
    echo -e "                          owntone-server/htdocs/"
    arg "--no-web-dark-reader" "    " "don't add dark-reader.css for dark theme (work in progress)"
    arg "--no-web-ws-url" "         " "don't change the url that the OwnTone Web"
    echo -e "                          UI uses for the websocket"
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

