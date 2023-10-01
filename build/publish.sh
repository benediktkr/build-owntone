#!/bin/bash
#
# Publishes docker containers and .deb packages to gitea
#

set -e

error() {
    echo
    echo_red "ERROR: $1"
    exit 1
}

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
# fail if auth is unsuccessful2
curl -fsX GET https://${GITEA_SECRET}@${GITEA_URL}/api/v1/nodeinfo || error "curl to gitea failed!"

echo_light_green "      [?] checking if there are published Debian builds for owntone-server $OWNTONE_VERSION"

# ARCH doesnt factor in for checking
CURL_OUT_OPT="-o /dev/null"

set +e
curl -fsiX GET $CURL_OUT_OPT https://${GITEA_SECRET}@${GITEA_URL}/api/v1/packages/${GITEA_USER}/debian/owntone-server/${OWNTONE_VERSION}
retval=$?
set -e
if [[ "${retval}" != "0" ]]; then
    echo_light_green "      [O] owntone-server ${OWNTONE_VERSION}: new version, no published .deb packages"
    GITEA_PUBLISH="true"

else
    echo_orange "      [o] owntone-server ${OWNTONE_VERSION}: published .deb packages found"
    GITEA_PUBLISH="false"
fi

if [[ "${GITEA_PUBLISH}" == "true" || "${OWNTONE_FORCE_PUBLISH}" == "true" ]]; then

    # ARCH factors in here
    GITEA_UPLOAD_URL="https://${GITEA_SECRET}@${GITEA_URL}/api/packages/${GITEA_USER}"

    if [[ "${OWNTONE_FORCE_PUBLISH}" == "true" ]]; then
        echo_orange "      [!] OWNTONE_FORCE_PUBLISH is set"
        set +e
    fi

    if [[ "${OWNTONE_BUILD_WEB}" != "false" ]]; then
        WEB_ZIP_FILE="owntone-web_${OWNTONE_VERSION}.zip"
        echo_green "      [^] Uploading: $WEB_ZIP_FILE"
        upload_web_zip=$(curl -s "${GITEA_UPLOAD_URL}/generic/owntone-web/${OWNTONE_VERSION}/owntone-web_${OWNTONE_VERSION}.zip" --upload-file dist/$WEB_ZIP_FILE)
        echo_n_green "      [ ] done. "
        echo $upload_web_zip
    fi
    DEB_FILE="owntone-server_${OWNTONE_VERSION}_${ARCH}.deb"
    echo_green "      [^] Uploding: $DEB_FILE..."
    upload_deb=$(curl -s "${GITEA_UPLOAD_URL}/debian/pool/${ARCH}/main/upload" --upload-file dist/$DEB_FILE)
    echo_n_green "      [ ] done. "
    echo $upload_deb


    set -e
    echo_green "      [^] Pushing docker container"
    echo -n "          "
    docker tag owntone-server:${OWNTONE_VERSION} ${GITEA_URL}/${GITEA_USER}/owntone-server:latest
    docker push -q ${GITEA_URL}/${GITEA_USER}/owntone-server:latest

    echo_green "      [^] Pushing docker container"
    echo -n "          "
    docker tag owntone-server:${OWNTONE_VERSION} ${GITEA_URL}/${GITEA_USER}/owntone-server:${OWNTONE_VERSION}
    docker push -q ${GITEA_URL}/${GITEA_USER}/owntone-server:${OWNTONE_VERSION}




fi
