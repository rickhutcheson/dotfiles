#!/usr/bin/env bash
set -e
source $USER_ENV_VARS/Minikube.sh

echo "Detecting version..."
MINIK_VERSION=${1:-`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`}

# Check that version string starts with "v"
if [[ $a == v* ]]; then
    echo "Could not detect version; curl downloaded: $MINIK_VERSION"
    exit 1
fi


echo "Installing Minikube $MINIK_VERSION..."

# Clean up any previous attempts
rm -rf $USER_ENV_UTILS/Minikube/minikube-$MINIK_VERSION

mkdir -p $USER_ENV_UTILS/Minikube/minikube-$MINIK_VERSION
cd  $USER_ENV_UTILS/Minikube/minikube-$MINIK_VERSION
mkdir -p bin

cd ./bin
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-$USER_ENV_OS-amd64
chmod +x minikube


echo "Setting up this version as 'latest'"
cd $USER_ENV_UTILS/Minikube
rm -f latest
ln -f -s minikube-$MINIK_VERSION latest

echo "Done!"
