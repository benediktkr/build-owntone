#!/bin/bash
#
# This script adds the Dark Reader CSS file (exported from the firefox addon) to the web-src directory
# as well as a modified index.html file.
#
# This script is intended to run before build-web.sh.
#
# NOTE: original css is compiled (templated?) from owntone-server/web-src/src/mystyles.scss

set -e

mkdir -pv owntone-server/web-src/public/assets
cp -v dark-reader/dark-reader.css  owntone-server/web-src/public/assets


