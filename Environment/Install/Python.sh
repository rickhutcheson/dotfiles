#!/usr/bin/env bash

easy_install pip
pip install virtualenv
pip3 install virtualenv

mkdir -p $USER_ENV_UTILS/Python
mkdir -p $USER_ENV_UTILS/Python/Envs

# Install a local virtualenv command for use with this system
cd $USER_ENV_UTILS/Python/Envs

virtualenv --python=`which python` py2default  # default python2 environment
virtualenv-$USER_ENV_PYTHON_PY3_VERSION py3default # default python3 environment
