#!/usr/bin/env bash
POETRY_VERSION=0.12.11
cd $USER_ENV_HOME
mkdir -p $USER_ENV_UTILS/Poetry
rm -rf
mkdir -p $USER_ENV_UTILS/Poetry/poetry-$POETRY_VERSION
cd $USER_ENV_UTILS/Poetry/poetry-$POETRY_VERSION
curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py > get-poetry.py
yes n | python3 get-poetry.py
cd $USER_ENV_UTILS/Poetry
rm -f latest
ln -s -f -i poetry-$POETRY_VERSION latest
