#!/usr/bin/env bash

set -e

KUBECTL_VERSION=1.13.7
KUBECTL_DATE=2019-06-11
VERSION_DIR=$USER_ENV_UTILS/kubectl/kubectl-$KUBECTL_VERSION

echo "Installing kubectl $KUBECTL_VERSION..."
mkdir -p $VERSION_DIR
cd $VERSION_DIR
mkdir -p bin
cd bin
curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/${KUBECTL_VERSION}/${KUBECTL_DATE}/bin/darwin/amd64/kubectl
chmod +x ./kubectl
cd $VERSION_DIR/..

rm -f latest
ln -f -s kubectl-$KUBECTL_VERSION latest
echo "Done. kubectl $KUBECTL_VERSION installed."
unset VERSION_DIR
unset KUBECTL_DATE
unset KUBECTL_VERSION
