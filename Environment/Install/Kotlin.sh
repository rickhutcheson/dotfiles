#!/usr/bin/env bash
set -e
source $USER_ENV_VARS/Kotlin.sh

export KOTLIN_VERSION=1.3.50

echo "Installing $KOTLIN_VERSION"

# Remove old version-specific directory
rm -rf $USER_ENV_UTILS/Kotlin/kotlin-$KOTLIN_VERSION

# Download & install necessary components
cd  $USER_ENV_UTILS/Kotlin/
wget https://github.com/JetBrains/kotlin/releases/download/v$KOTLIN_VERSION/kotlin-compiler-$KOTLIN_VERSION.zip \
     -O kotlin.zip
unzip kotlin.zip # creates kotlinc folder
mv kotlinc $USER_ENV_UTILS/Kotlin/kotlin-$KOTLIN_VERSION
rm kotlin.zip

# Mark version as latest
rm -f latest
ln -f -s kotlin-$KOTLIN_VERSION latest
