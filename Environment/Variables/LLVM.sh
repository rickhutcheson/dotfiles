#!/usr/bin/env bash

# We put custom LLVM at the end of $PATH so that we only get the extra
# tools not included in Xcode
export PATH=$PATH:$USER_ENV_UTILS/LLVM/latest/bin
