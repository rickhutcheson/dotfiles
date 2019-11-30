#!/usr/bin/env bash

set -e

AWS_IAM_AUTHENTICATOR_VERSION=1.14.6
AWS_IAM_AUTHENTICATOR_DATE=2019-08-22
VERSION_DIR=$USER_ENV_UTILS/aws-iam-authenticator/aws-iam-authenticator-$AWS_IAM_AUTHENTICATOR_VERSION




echo "Installing aws-iam-authenticator $AWS_IAM_AUTHENTICATOR_VERSION..."
mkdir -p $VERSION_DIR
cd $VERSION_DIR
mkdir -p bin
cd bin
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/${AWS_IAM_AUTHENTICATOR_VERSION}/${AWS_IAM_AUTHENTICATOR_DATE}/bin/darwin/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
cd $VERSION_DIR/..

rm -f latest
ln -f -s aws-iam-authenticator-$AWS_IAM_AUTHENTICATOR_VERSION latest
echo "Done. aws-iam-authenticator $AWS_IAM_AUTHENTICATOR_VERSION installed."
unset VERSION_DIR
unset AWS_IAM_AUTHENTICATOR_VERSION
unset AWS_IAM_AUTHENTICATOR_DATE
