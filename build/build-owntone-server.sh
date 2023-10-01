#!/bin/bash
#
# Build OwnTone.
#
# Builds in a docker container, and during the 'docker build' stage, to
# use the built-in caching (and not repeatedly build the same source if neither
# the source nor build scripts have changed).
#
# Produces the .deb file, and a docker container to run the build

set -e
shopt -s expand_aliases

alias ls='ls --color=always'
alias grep='grep --color=always'

if [[ -z "${OWNTONE_VERSION}" ]]; then
    echo "OWNTONE_VERSION need to be set!"
    exit 1
fi


echo "Cleaning up..."
find dist/ -name "owntone-server_${OWNTONE_VERSION}_*.tar.gz" -print -delete
find dist/ -name "owntone-server_${OWNTONE_VERSION}_*.deb" -print -delete
find dist/ -name "owntone-server_${OWNTONE_VERSION}_*.txt" -print -delete
find dist/ -name ".arch.txt" -print -delete
if [[ -d "target/owntone-server" ]]; then
    echo "removing: target/owntone-server"
    rm -r target/owntone-server
fi

mkdir -pv ./dist/

if [[ -z "${OWNTONE_UID}" ]]; then
    OWNTONE_UID=$(id -u)
fi
if [[ -z "${OWNTONE_GID}" ]]; then
    OWNTONE_GID="$(id -g)"
fi

if [[ -t 1 ]]; then
    # run docker container with -t if we are in a TTY
    DOCKER_OPT_TTY="-t"
fi


echo
echo "Building container with uid=${OWNTONE_UID}, gid=${OWNTONE_GID}"

(
    set -x
    set -e

    ls -1 dist/

    docker build \
        --pull \
        --target builder \
        --build-arg "OWNTONE_UID=$OWNTONE_UID" \
        --build-arg "OWNTONE_GID=$OWNTONE_GID" \
        --build-arg "OWNTONE_VERSION=$OWNTONE_VERSION" \
        -t owntone-server-builder:${OWNTONE_VERSION} .

    docker run \
        --rm \
        $DOCKER_OPT_TTY \
        --name owntone-build \
        -u $(id -u) \
        -v ./dist/:/mnt/dist/ \
        -v ./target/:/mnt/target/ \
        owntone-server-builder:${OWNTONE_VERSION} \
            bash -c "
                cp -v /usr/local/src/owntone-build.env /mnt/target && \
                cp -rv /usr/local/src/dist/. /mnt/dist/ && \
                cp -r /usr/local/src/target/ /mnt/target/owntone-server/
            "
)

source target/owntone-build.env
ls -lah dist/$OWNTONE_SERVER_DEB

(
    set -x
    set -e

    docker build \
        --pull \
        --target final \
        --build-arg "OWNTONE_UID=$OWNTONE_UID" \
        --build-arg "OWNTONE_GID=$OWNTONE_GID" \
        --build-arg "OWNTONE_VERSION=$OWNTONE_VERSION" \
        -t owntone-server:${OWNTONE_VERSION} .


)


