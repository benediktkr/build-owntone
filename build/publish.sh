#!/bin/bash
#
# Publishes docker containers and .deb packages to gitea
#

set -e

source build/.colors.env

if [[ -z "GITEA_SECRET" || -z "$GITEA_USER" ]]; then
    echo "need both 'GITEA_USER' and 'GITEA_SECRET' to publish packages to gitea!"
    exit 2
fi
if [[ -f "dist/.arch.txt" ]]; then
    ARCH=$(cat dist/.arch.txt | tr -d '[[:space:]]')
else
    ARCH=$(dpkg --print-architecture)
fi

GITEA_URL=git.sudo.is

gitea_check() {
    # arch doesnt factor in
    #CURL_OUT_OPT="-o /dev/null"
    NAME=$1
    PKG_REGISRY=$2

    echo_light_green "checking if there are published $PKG_REGISTRY builds for $NAME $OWNTONE_VERSION"

    GITEA_API_URL_PKG="https://${GITEA_SECRET}@${GITEA_URL}/api/v1/packages/${GITEA_USERNAME}/${PKG_REGISTRY}/${NAME}/${VERSION}"
    curl -fsiX GET $CURL_OUT_OPT $GITEA_API_URL_PKG
}

if ! gitea_check "owntone-server" "debian"; then
    echo_green "owntone-server ${OWNTONE_VERSION}: new version, no published .deb packages"
    OWNTONE_PUBLISH_NEW="true"
else
    echo_yellow "owntone-server ${OWNTONE_VERSION}: publshed .deb packages found"
    OWNTONE_PUBLISH_NEW="false"
fi

if [[ "${OWNTONE_PUBLISH_NEW}" == "true" ]]; then
    # ARCH factors in here
    GITEA_UPLOAD_URL="https://${GITEA_SECRET}@${GITEA_URL}/api/packages/${GITEA_USER}"
    DEB_FILE="owntone-server_${OWNTONE_VERSION}_${ARCH}.deb"
    echo_green "  [^] Uploding: $DEB_FILE"
    curl "${GITEA_UPLOAD_URL}/debian/pool/${ARCH}/main/upload" --upload-file dist/$DEB_FILE
    echo

    if [[ "${OWNTONE_PUBLISH}" != "false" ]]; then
        WEB_ZIP_FILE="owntone-web_${OWNTONE_VERSION}.zip"
        echo_green "  [^] Uploading: $WEB_ZIP_FILE"
        curl "${GITEA_UPLOAD_URL}/generic/owntone-server/${OWNTONE_VERSION}/owntone-web_${OWNTONE_VERSION}.zip" --upload-file dist/$WEB_ZIP_FILE
        echo
    fi

    echo_green "Publishing docker container with tags 'latest', '${OWNTONE_VERSION}'"
    docker tag owntone-server:${OWNTONE_VERSION} ${GITEA_URL}/${GITEA_USER}/owntone-server:${OWNTONE_VERSION}
    docker tag owntone-server:${OWNTONE_VERSION} ${GITEA_URL}/${GITEA_USER}/owntone-server:latest
    docker push ${GITEA_URL}/${GITEA_USER}/owntone-server:${OWNTONE_VERSION}
    docker push ${GITEA_URL}/${GITEA_USER}/owntone-server:latest

fi








