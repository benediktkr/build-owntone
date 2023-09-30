#!/bin/bash

# Disable the warning about what wre about to do

# The GIT_CONFIG_PARAMETERS env var can't _start_ with a space, then  
# git will exit with "bogus format in GIT_CONFIG_PARAMETERS" error, so we 
# append any exsiting $GIT_CONFIG_PARAMETERS to the _end_ instead. 
#
# So GIT_CONFIG_PARAMETERS was empty, it will just _end_ with a space -- which
# git is fine with -- it just can't _start_ with a space. 
#
# Using an environment variable means that we dont change the repos .git/config
# file.
GIT_CONFIG_PARAMETERS="'advice.detachedHead=false' $GIT_CONFIG_PARAMETERS"
export GIT_CONFIG_PARAMETERS

# Another way to do this is with 'git config', which does edit the .git/config
# file of the repo.
#git -C owntone-server/ config --worktree advice.detachedHead false

# check out the tag for the version we building (probably the latest version)
git -C owntone-server/ checkout $OWNTONE_VERSION

