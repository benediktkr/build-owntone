#!/bin/bash
set -e

echo "git-init.sh"
build/git-init.sh
echo

echo "version.sh"
source build/version.sh
echo

echo "git-checkout-version.sh"
build/git-checkout-version.sh
echo


if [[ "${OWNTONE_BUILD_WEB}" != "false" ]]; then
    echo "build-web.sh"
    build/build-web.sh
    echo
fi  
