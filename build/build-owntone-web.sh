#!/bin/bash
#
# Run npm in a docker container to build owntone-web
#
# This script only builds the webinterface, it doesnt patch or make any changes to the
# code. So that should happen before this script is called.

set -e
shopt -s expand_aliases

alias ls='ls --color=always'
alias grep='grep --color=always'

echo
if [[ "${OWNTONE_WEB_WS_URL}" != "false" ]]; then
    echo "web-change-ws-url.sh"
    build/web-change-ws-url.sh
else
    echo "skipped: web-change-ws-url.sh"
fi

if [[ "${OWNTONE_WEB_DARK_READER}" != "false" ]]; then
    echo "web-add-dark-reader.sh"
    build/web-add-dark-reader.sh
else
    echo "skipped: web-add-dark-reader.sh"
fi


# the /home/node dir is explicitly owned by uid 1000, and npm wants to write to $HOME/.npm (some logs)
# best way seems to be to bind mount /owntone-server/web-src/node_modules with -v

CACHE_DIR="$HOME/.cache/npm-docker/builds/owntone/web-src/.npm"
NODE_MODULES_DIR="$HOME/.cache/npm-docker/builds/owntone/web-src/node_modules"
OUTPUT_DIR=target/owntone-web

BUILD_UID=$(id -u)
BUILD_GID=$(id -g)

echo "Cleaning up..."
if [[ -d "./${OUTPUT_DIR}" ]]; then
    echo "removing: '${OUTPUT_DIR}'"
    rm -r ./${OUTPUT_DIR}
fi
find dist/ -name "owntone-web_${OWNTONE_VERSION}.zip" -print -delete

mkdir -pv $CACHE_DIR $NODE_MODULES_DIR $OUTPUT_DIR

echo
echo "Directories mounted to the npm container to build owntone-web (working around the container expecting to run as uid=1000"
echo "CACHE_DIR: ${CACHE_DIR}"
echo "NODE_MODULES_DIR: ${NODE_MODULES_DIR}"

echo
echo "Directory mounted to write the build output to:"
echo "OUTPUT_DIR: ${OUTPUT_DIR}"

echo
echo "Running npm container as uid=${BUILD_UID}, gid=${BUILD_GID}"
echo

if [[ -t 1 ]]; then
    # run docker container with -t if we are in a TTY
    DOCKER_OPT_TTY="-t"
fi

(
    set -ex
    ls -1 dist/
    docker pull node:latest
    docker run \
        --rm \
        $DOCKER_OPT_TTY \
        -w /owntone-server/web-src \
        -e "HOME=/home/node" \
        -v ./owntone-server/web-src:/owntone-server/web-src \
        -v ./${OUTPUT_DIR}:/${OUTPUT_DIR} \
        -v ${CACHE_DIR}:/home/node/.npm \
        -v ${NODE_MODULES_DIR}:/owntone-server/web-src/node_modules \
        -e FORCE_COLOR=1 \
        -e NPM_CONFIG_PREFIX=/home/node/.npm \
        -e NODE_PATH=/home/node/.npm/node_modules \
        -e NODE_MODULES=/home/node/.npm/node_modules \
        -e NODE_INSTALL_PATH=/home/node/.npm/node_modules \
        -e OUTPUT_DIR=${OUTPUT_DIR} \
        --user "${BUILD_UID}:${BUILD_GID}" \
        node:latest \
            bash -c "
                set -ex && \
                npm ci && \
                npm run build -- --minify=false --outDir=/${OUTPUT_DIR} --emptyOutDir
            "

    ls -1 dist/
)

echo
if [[ "${OWNTONE_WEB_WS_URL}" != "false" ]]; then
    echo "Checking out 'App.vue' to restore the file"
    git -C owntone-server/ checkout -- web-src/src/App.vue
fi
if [[ "${OWNTONE_WEB_DARK_READER}" != "false" ]]; then
    echo "Cleaning up 'dark-reader.css'"
    find owntone-server/web-src/ -name "dark-reader.css" -print -delete
fi
if [[ "${OWNTONE_WEB_WS_URL}" != "false" || "${GIT_WEB_DARK_READER}" != "false" ]]; then
    git -C owntone-server/ status
fi

(
    set -e
    pushd $OUTPUT_DIR
    echo
    echo "creating zip file from '${OUTPUT_DIR}'"
    zip -r ../../dist/owntone-web_${OWNTONE_VERSION}.zip ./
)

echo
ls -1 dist/
