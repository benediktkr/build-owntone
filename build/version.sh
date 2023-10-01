#!/bin/bash

if [[ -n "${OWNTONE_VERSION}" ]]; then
    echo "environment var 'OWNTONE_VERSION' is alrady set" >2
    echo "OWNTONE_VERSION: ${OWNTONE_VERSION}'" >2
    echo >2
    echo "will use this value and not look for tha latest git tag" >2
    sleep 5
else
    LATEST_TAG=$(git -C owntone-server/ describe --tags --abbrev=0)
    OWNTONE_VERSION=$LATEST_TAG
    export OWNTONE_VERSION
fi

echo "version: '${OWNTONE_VERSION}'"

