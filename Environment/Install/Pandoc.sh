#!/usr/bin/env bash

set -e

export PANDOC_VERSION=2.7.3
echo "Installing Pandoc v. $PANDOC_VERSION"
rm -rf $USER_ENV_UTILS/Pandoc/pandoc-$PANDOC_VERSION
rm -rf $USER_ENV_UTILS/Pandoc/pandoc-$PANDOC_VERSION
mkdir -p $USER_ENV_UTILS/Pandoc/pandoc-$PANDOC_VERSION
cd $USER_ENV_UTILS/Pandoc/
wget https://hackage.haskell.org/package/pandoc-${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}.tar.gz -O pandoc.tar.gz
tar -xzf pandoc.tar.gz -C pandoc-$PANDOC_VERSION --strip-components 1
rm pandoc.tar.gz

if [[ -f ~/.ghcup/env ]]; then
    source ~/.ghcup/env
else
    echo "Installing Haskell Platform first..."
    curl https://get-ghcup.haskell.org -sSf | sh
    source ~/.ghcup/envp
fi

cd ~/Environment/Utilities/Pandoc/pandoc-$PANDOC_VERSION
cabal install --prefix=$USER_ENV_DIR/Pandoc
cd ~/Environment/Utilities/Pandoc
ln -f -s pandoc-$PANDOC_VERSION latest
echo "Done."
