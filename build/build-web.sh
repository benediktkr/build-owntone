#!/bin/bash
# this file runs the docker container to build web-src

#set -x
alias ls='ls --color=always'

#CACHE_DIR="$HOME/.cache/npm-docker/builds/owntone/web-src/.npm"
#mkdir -pv $CACHE_DIR

CACHE_DIR="/tmp/owntone-npm"
echo "cache dir: ${CACHE_DIR}"

#mkdir -pv $NODE_MODULES_DIR
#NODE_MODULES_DIR="$HOME/.cache/npm-docker/builds/owntone/web-src/node_modules"
NODE_MODULES_DIR="/tmp/owntone-node_modules"
echo "node_modules: ${NODE_MODULES_DIR}"

#OUTPUT_DIR=$(pwd)/dist/htdocs
#mkdir -pv $OUTPUT_DIR
OUTPUT_DIR="/tmp/owntone-dist"
echo "output dir: ${OUTPUT_DIR}"


if [[ -d "$CACHE_DIR" ]] ; then
    echo "we have run before, the cache dir exists"
    ls -l $CACHE_DIR/bin
fi


# the /home/node dir is explicitly owned by uid 1000, and npm wants to write to $HOME/.npm (some logs)

BUILD_UID=$(id -u)
BUILD_GID=$(id -g)

echo "Running as uid=${BUILD_UID}, gid=${BUILD_GID}"


       # -v ${NODE_MODULES_DIR}:/owntone-server/web-src/node_modules \

# re-define the wsUrl variable
#


# env vars that dont work
# NODE_PATH
# NODE_MODULES
#
# best way seems to be to bind mount /owntone-server/web-src/node_modules with -v
docker run \
       --rm \
       -w /owntone-server/web-src \
       -e "HOME=/home/node" \
       -v $(pwd)/owntone-server/web-src:/owntone-server/web-src \
       -v $(pwd)/builder:/builder \
       -v ${OUTPUT_DIR}:/dist/htdocs \
       -v ${CACHE_DIR}:/home/node/.npm \
       -v ${NODE_MODULES_DIR}:/owntone-server/web-src/node_modules \
       -e NPM_CONFIG_PREFIX=/home/node/.npm \
       -e NODE_PATH=/home/node/.npm/node_modules \
       -e NODE_MODULES=/home/node/.npm/node_modules \
       -e NODE_INSTALL_PATH=/home/node/.npm/node_modules \
       --user "${BUILD_UID}:${BUILD_GID}" \
       node:latest \
       bash -c "
        /builder/build-web-src.sh \
        && hostname"

git -C $(pwd)/owntone-server checkout web-src/src/App.vue
git -C $(pwd)/owntone-server status
