#!/bin/bash
set -e

build/init-git.sh
source build/version.sh

git -C owntone-server/ config --worktree advice.detachedHead false 
git -C owntone-server/ checkout $OWNTONE_VERSION

build/change-ws-url.sh
build/build-web.sh
