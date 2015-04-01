#!/usr/bin/env bash

export PS1="\[\033[32m\][\w]\[\033[0m\]\n\[\033[1;36m\]\u\[\033[1;33m\] ➤ \[\033[0m\]"

make-targets() {
    make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}'
}
