#!/usr/bin/env bash

set -e

mkdir -p $USER_ENV_UTILS/Calibre
rm -r $USER_ENV_UTILS/Calibre/next || echo "No existing version"
mkdir -p $USER_ENV_UTILS/Calibre/next
cd  $USER_ENV_UTILS/Calibre/next
# Why content-disposition? Because we want to name the file according
# to the actual final name, rather than saving it according to the
# "osx" name.
wget --content-disposition https://Calibre-ebook.com/dist/osx
dmg_filename=$(ls -1 *.dmg | tail -n 1)

# This will download a versioned filename for Calibre. We need to
# parse out the version.
APP_VERSION=$(ls -1 *.dmg | tail -n 1 | cut -d '-' -s -f 2 | cut -d '.' -f 1-3 | sort | tail -n 1)
echo "Using version $APP_VERSION..."
# Now that we have our version, let's clean out that directory & try
# to install it.
rm -r $USER_ENV_UTILS/Calibre/$APP_VERSION || echo "No existing directory"
mkdir $USER_ENV_UTILS/Calibre/$APP_VERSION
mv $dmg_filename $USER_ENV_UTILS/Calibre/$APP_VERSION/Calibre.dmg
cd $USER_ENV_UTILS/Calibre/$APP_VERSION/

echo "Mounting..."
hdiutil attach -mountpoint $USER_ENV_UTILS/Calibre/$APP_VERSION/installer Calibre.dmg

echo "Copying Calibre.app..."
rm -r ~/Applications/Calibre.app | echo "No Calibre.app exists. Skipping.."
cp -Rfv $USER_ENV_UTILS/Calibre/$APP_VERSION/installer/Calibre.app ~/Applications/Calibre.app
echo "Done."
hdiutil detach $USER_ENV_UTILS/Calibre/$APP_VERSION/installer
rm -r  $USER_ENV_UTILS/Calibre/next
exit 0
