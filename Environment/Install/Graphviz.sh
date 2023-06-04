#!/usr/bin/env bash
set -e
GRAPHVIZ_VERSION=8.0.5
VERSION_DIR=$USER_ENV_UTILS/Graphviz/Graphviz-$GRAPHVIZ_VERSION

echo "Installing Graphviz $GRAPHVIZ_VERSION..."
mkdir -p $VERSION_DIR
cd $VERSION_DIR
wget https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/${GRAPHVIZ_VERSION}/graphviz-${GRAPHVIZ_VERSION}.tar.gz -O src.tar.gz
tar xzf src.tar.gz --strip-components=1
rm src.tar.gz
./configure --prefix=$USER_ENV_UTILS/Graphviz/Graphviz-$GRAPHVIZ_VERSION
make
make install
cd $VERSION_DIR
cd ..
rm -f latest
ln -f -s Graphviz-$GRAPHVIZ_VERSION latest

echo "Done. Graphviz $GRAPHVIZ_VERSION installed."
unset VERSION_DIR
unset GRAPHVIZ_VERSION
