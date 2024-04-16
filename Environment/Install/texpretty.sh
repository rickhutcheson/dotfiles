#!/usr/bin/env bash

set -e

app_name=texpretty
app_version="0.03"
src_url=http://ftp.math.utah.edu/pub/texpretty/texpretty-${app_version}.tar.gz
version_dir="${app_name}-$app_version"
echo $version_dir
abs_version_dir=$USER_ENV_UTILS/${app_name}/${version_dir}
src_zip=${app_version}.tar.gz

echo "Setting up app location..."
mkdir -p $USER_ENV_UTILS/${app_name}
cd $USER_ENV_UTILS/${app_name}
chmod -R u+w $abs_version_dir
rm -r ${version_dir} || echo "nothing to cleanup"
mkdir -p $version_dir
mkdir -p cache/$version_dir

echo "Downloading installation files..."
if test -f "cache/${src_zip}"; then
    cp cache/$src_zip $src_zip
else
    wget $src_url -O ${src_zip}
    cp $src_zip cache/$src_zip
fi

tar xzf ${src_zip} --cd $version_dir --strip-components 1
rm ${src_zip}

echo "Compiling and Installing..."
cd $version_dir
./configure --prefix=$abs_version_dir
make
make install

echo Setting version $app_version as latest...
cd $abs_version_dir
cd ..
ln -sf $version_dir latest

echo "Done!"
