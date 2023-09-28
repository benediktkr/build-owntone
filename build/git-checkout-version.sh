#!/bin/bash

# disable the warning about what wre about to do
git -C owntone-server/ config --worktree advice.detachedHead false

# check out the tag for the version we building (probably the latest version)
git -C owntone-server/ checkout $OWNTONE_VERSION

