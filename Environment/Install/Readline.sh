#!/usr/bin/env bash
set -e
source $USER_ENV_VARS/Python.sh

export RL_VERSION=7.0

echo "Installing readline @ $RL_VERSION..."

# Clean up any previous attempts
rm -rf $USER_ENV_LIB/Readline/readline-$RL_VERSION
mkdir -p $USER_ENV_LIB/Readline/readline-$RL_VERSION/src
cd $USER_ENV_LIB/Readline/readline-$RL_VERSION/src

echo "Downloading..."

src_url=ftp://ftp.gnu.org/gnu/readline/readline-$RL_VERSION.tar.gz
patches_url=ftp://ftp.gnu.org/gnu/readline/readline-$RL_VERSION-patches

wget -q $src_url -O readline.tar.gz
echo "Extracting..."
# If it doesn't, then it probably has GNU tar
tar xzf readline.tar.gz --strip-components 1
rm readline.tar.gz

echo "Fetching patches..."
mkdir -p patches
# Fetch patches (if any exist)
if [[ `wget -S --spider $patches_url 2>&1 | grep '150'` ]]; then
    cd patches
    wget -q $patches_url/* 2>/dev/null  # gets all files
    cd ..
fi

# Apply patches (they're the ones with no extensions)
echo -ne "Applying patches..."
NO_EXT_FILES=`ls patches | grep -v '\.'`
for f in $NO_EXT_FILES
do
    echo -ne "$f "
    patch --quiet < "patches/$f"
done

echo "Building..."
./configure --prefix=$USER_ENV_LIB/Readline/readline-$RL_VERSION
make
make install

echo "Done!"
