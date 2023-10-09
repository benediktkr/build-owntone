#!/bin/bash
#
#

set -e

git remote rm whatdoineed2do || true

git remote add whatdoineed2do https://github.com/whatdoineed2do/forked-daapd
git fetch whatdoineed2do file-scan-dir-path
git rebase file-scan-dir-path

