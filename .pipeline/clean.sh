#!/bin/bash

set -e


for f in target/*/ target/*.env dist/*.{tar.gz,deb,zip} dist/*.txt; do
    if [[ -d "$f" ]]; then
        rm -r $f
    else
        rm $f
    fi
    echo "removed: '${f}'"
done
