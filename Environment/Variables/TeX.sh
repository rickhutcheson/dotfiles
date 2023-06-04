#!/usr/bin/env bash

export TEX_VERSION=2023
export TEX_DIR=~/texmf
export INFOPATH=$INFOPATH:$USER_ENV_UTILS/TeX/$TEX_VERSION/texmf-dist/doc/info
export MATHPATH=$MATHPATH:$USER_ENV_UTILS/TeX/$TEX_VERSION/texmf-dist/doc/man
export PATH=$PATH:$USER_ENV_UTILS/TeX/latest/bin/universal-darwin
export TEXINPUTS=$TEXINPUTS:$TEX_DIR
