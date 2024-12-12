#!/usr/bin/env bash

app_version=$(date +"%Y-%m-%d")
url='https://discord.com/api/download?platform=linux&format=tar.gz'
rm -rf $USER_ENV_UTILS/Discord/discord-$app_version
mkdir -p $USER_ENV_UTILS/Discord
cd $USER_ENV_UTILS/Discord
rm -rf discord-$app_version
mkdir -p discord-$app_version
wget $url -O app.tar.gz
tar -xzf app.tar.gz -C discord-$app_version --strip-components 1
ln -f -s discord-$app_version latest
