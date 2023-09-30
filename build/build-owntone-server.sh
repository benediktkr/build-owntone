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

if [[ -z "${OWNTONE_VERSION}" ]]; then
    echo "OWNTONE_VERSION is not set."
    exit 1
fi

echo "Cleaning up..."
find dist/ -name "owntone-server_${OWNTONE_VERSION}_*.tar.gz" -print -delete
find dist/ -name "owntone-server_${OWNTONE_VERSION}_*.deb" -print -delete
if [[ -d "dist/target" ]]; then
    echo "removing: dist/target/"
    rm -r dist/target
fi
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


# --target builder \


set -x
docker build \
    --pull \
    --target builder \
    --build-arg "OWNTONE_UID=$OWNTONE_UID" \
    --build-arg "OWNTONE_GID=$OWNTONE_GID" \
    --build-arg "OWNTONE_VERSION=$OWNTONE_VERSION" \
    -t owntone:${OWNTONE_VERSION}-builder .

docker run \
    --rm \
    $DOCKER_OPT_TTY \
    --name owntone-build \
    -u $(id -u) \
    -v $(pwd)/dist/:/mnt/dist/ \
    owntone:${OWNTONE_VERSION}-builder \
        cp -r /usr/local/src/dist/. /mnt/dist/

docker build \
    --pull \
    --build-arg "OWNTONE_UID=$OWNTONE_UID" \
    --build-arg "OWNTONE_GID=$OWNTONE_GID" \
    --build-arg "OWNTONE_VERSION=$OWNTONE_VERSION" \
    -t owntone:${OWNTONE_VERSION} .

