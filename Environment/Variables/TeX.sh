#!/usr/bin/env bash

export TEX_VERSION=2018
export INFOPATH=$INFOPATH:$USER_ENV_UTILS/TeX/$TEX_VERSION/texmf-dist/doc/info
export MATHPATH=$MATHPATH:$USER_ENV_UTILS/TeX/$TEX_VERSION/texmf-dist/doc/man
export PATH=$PATH:$USER_ENV_UTILS/TeX/latest/bin/x86_64-darwin
export TEXINPUTS=$TEXINPUTS:~/texmf
