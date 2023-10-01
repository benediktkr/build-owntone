#!/bin/bash

set -e

if [[ -n "${OWNTONE_VERSION}" ]]; then
    echo "environment var 'OWNTONE_VERSION' is alrady set, this probably means that a specific/version tag is being built manually" >&2
    echo "OWNTONE_VERSION: ${OWNTONE_VERSION}'" >&2
    echo >&2
    echo "will use this value and not look for tha latest git tag" >&2
    sleep 5
else
    PWD_REPO_NAME=$(basename $(git rev-parse --show-toplevel))
    if [[ "$PWD_REPO_NAME" != "owntone-server" ]]; then
        GIT_CHDIR_OPT="-C owntone-server/"
    fi
    LATEST_TAG=$(git $GIT_CHDIR_OPT describe --tags --abbrev=0)
    OWNTONE_VERSION=$LATEST_TAG
    export OWNTONE_VERSION
fi

if [[ -t 1 ]]; then
    echo "version: '${OWNTONE_VERSION}'"
else
    echo $OWNTONE_VERSION
fi


