#!/bin/bash
set -e

usage() {
    echo "usage: $0 [ARGUMENTS]"
    echo
    echo "Arguments:"
    echo "  --use-github            use the upstream https://github.com/owntone/owntone-server"
    echo "                          repo (default: false, use"
    echo "                          https://git.sudo.is/mirrors/owntone-server)"
    echo "  --rebase-filescans      build with support for partial library scans. Rebases branch" 
    echo "                          for owntone-server#1179 from" 
    echo "                          github:whatdoineed2do/forked-daapd (default: false)"
    echo "  --no-build-web          don't build the OwnTone Web UI, use the build in" 
    echo "                          owntone-server/htdocs/"
    echo "  --no-web-dark-reader    don't add dark-reader.css for dark theme (work in progress)"
    echo "  --no-web-ws-url         don't change the url that the OwnTone Web" 
    echo "                          UI uses for the websocket"
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
        esac
done

echo "git-init.sh"
build/git-init.sh
echo

echo "version.sh"
source build/version.sh
echo

echo "git-checkout-version.sh"
build/git-checkout-version.sh
echo

if [[ "${OWNTONE_REBASE_FILESCANS}" == "true" ]]; then
    echo "git-rebase-filescans.sh"
    build/git-rebase-filesans.sh
    echo 
else
    echo "skipped: git-rebase-filescans.sh"
fi  

if [[ "${OWNTONE_BUILD_WEB}" != "false" ]]; then
    echo "build-web.sh"
    build/build-web.sh
    echo
else
    echo "skipped: build-web.sh"
fi  
