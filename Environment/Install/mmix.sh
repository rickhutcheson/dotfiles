#!/usr/bin/env bash

# Download
echo "Installing mmix..."
mkdir -p $USER_ENV_UTILS/mmix/
rm -rf $USER_ENV_UTILS/mmix/latest
cd $USER_ENV_UTILS/mmix
git clone https://gitlab.lrz.de/mmix/mmixware.git latest
cd latest
make all
