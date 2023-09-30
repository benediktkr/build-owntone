#!/bin/bash

set -e

if [[ "${USE_GITHUB}" == "true" ]]; then
    GIT_URL="https://github.com/owntone"
else 
    GIT_URL="https://git.sudo.is/mirrors"
fi  

OWNTONE_MAIN_BRANCH="master"
LOCAL_PATH=$(git rev-parse --show-toplevel)


if [[ ! -d "owntone-server/.git" ]]; then
    echo "cloning '$GIT_URL/owntone-server'... "
    git clone -q $GIT_URL/owntone-server
    echo "done"
else
    git -C owntone-server/ checkout .
    git -C owntone-server/ clean -fd
    
    CURRENT_BRANCH=$(git -C owntone-server/ rev-parse --abbrev-ref HEAD)
    if [[ "$CURRENT_BRANCH" != "${OWNTONE_MAIN_BRANCH}" ]]; then
       git -C owntone-server/ checkout $OWNTONE_MAIN_BRANCH
    fi

    git -C owntone-server/ remote rm origin || true
    git -C owntone-server/ remote add origin $GIT_URL/owntone-server
    git -C owntone-server/ pull origin $OWNTONE_MAIN_BRANCH
fi

echo
echo "owntone remote: '$GIT_URL/owntone-server'"
echo "owntone local: '$LOCAL_PATH/owntone-server'"
echo "owntone branch: '$(git -C owntone-server/ rev-parse --abbrev-ref HEAD)'"
echo

