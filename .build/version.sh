#!/bin/bash

LATEST_TAG=$(git -C owntone-server/ describe --tags --abbrev=0)

OWNTONE_VERSION=$LATEST_TAG 
export OWNTONE_VERSION

echo "version: '${OWNTONE_VERSION}'"

