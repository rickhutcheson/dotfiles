#!/usr/bin/env bash

# Download
echo "Installing mmix..."
mkdir -p $USER_ENV_UTILS/mmix/
rm -rf $USER_ENV_UTILS/mmix/latest
cd $USER_ENV_UTILS/mmix
svn co svn://mmix.cs.hm.edu/mmixware/trunk latest
cd latest
make all
