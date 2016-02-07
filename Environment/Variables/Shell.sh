#!/usr/bin/env bash


# Shell Options
# ----------------------------------------------------------------------
shopt -s histappend
export PATH=$PATH:$USER_ENV_UTILS/Shell/

# Prompt Formatting
# ----------------------------------------------------------------------

NONE=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 4)
PURPLE=$(tput setaf 5)
WHITE=$(tput setaf 7)
BOLD=$(tput bold)


cwd="\[$CYAN\][\w]\[$NONE\]"
prompt="⁒ "


do_cmd() {
    branch=''
    if [ -d ".git" ]
    then
        current_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)  # get branch name (if possible)
        if [ $? -eq 0 ]
        then
            branch="\[$WHITE\] ≻ \[$RED\]"$current_branch""
        fi
    fi

    if [ "$VIRTUAL_ENV" ]
    then
        venv=$(basename $VIRTUAL_ENV)
        pre_prompt="\[$GREEN\]⁒"
    else
        pre_prompt="\[$YELLOW\]"
    fi
    PS1=$cwd"\[$RED\]"$branch"\[$NONE\]\n"$pre_prompt$prompt"\[$NONE\]"

    #
    # History Sharing - These settings share history between terminal tabs.
    #
    history -a
    history -n

    return 0
}

export PROMPT_COMMAND=do_cmd

#
# Miscellaneous
# ----------------------------------------------------------------------

make_targets() {
    make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}'
}
