#!/bin/bash

set -e

if [[ "${USE_GITHUB}" != "true" ]]; then
    OWNTONE_GIT_URL="https://git.sudo.is/mirrors"
else
    OWNTONE_GIT_URL="https://github.com/owntone"
fi

OWNTONE_MAIN_BRANCH="master"
LOCAL_PATH=$(git rev-parse --show-toplevel)


if [[ ! -d "owntone-server/.git" ]]; then
    echo "cloning '$OWNTONE_GIT_URL/owntone-server'... "
    git clone -q $OWNTONE_GIT_URL/owntone-server
    echo "done"
else
    git -C owntone-server/ checkout .
    git -C owntone-server/ clean -fd

    CURRENT_BRANCH=$(git -C owntone-server/ rev-parse --abbrev-ref HEAD)
    if [[ "$CURRENT_BRANCH" != "${OWNTONE_MAIN_BRANCH}" ]]; then
       git -C owntone-server/ checkout $OWNTONE_MAIN_BRANCH
    fi

    git -C owntone-server/ remote rm origin || true
    git -C owntone-server/ remote add origin $OWNTONE_GIT_URL/owntone-server
    git -C owntone-server/ pull origin $OWNTONE_MAIN_BRANCH
fi

echo
echo "owntone remote: '$OWNTONE_GIT_URL/owntone-server'"
echo "owntone local: '$LOCAL_PATH/owntone-server'"
echo "owntone branch: '$(git -C owntone-server/ rev-parse --abbrev-ref HEAD)'"
echo

