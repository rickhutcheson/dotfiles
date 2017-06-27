#!/usr/bin/env bash


# History Control
# ----------------------------------------------------------------------
shopt -s histappend                      # remember history
shopt -s cmdhist 			 # attempt to remember multi-line commands correctly
export HISTCONTROL=ignoredups:erasedups	 # ignore and erase duplicate commands from history

# Global Aliases / Utilities
# ----------------------------------------------------------------------
alias nano='emacs -nw'  # emacs in terminal & no init file (fast)
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
ITALIC=$(tput sitm)


host="\[$PURPLE\]\H\[$NONE\]"
cwd="\[$CYAN\]\w\[$NONE\]"
#prompt="➥ "
prompt="↪ "
separator="\[$WHITE\] // \[$NONE\]"

hr() {
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' ─
}

show_prompt() {
    info_line=$host$separator$cwd

    branch=''
    current_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)  # get branch name (if possible)
    if [ $? -eq 0 ]
    then
        branch="\[$NONE\]\[$RED\]"$current_branch"\[$NONE\]"
        info_line=$info_line$separator$branch
    fi

    if [ "$VIRTUAL_ENV" ]
    then
        venv=$GREEN$(basename $VIRTUAL_ENV)$NONE
        info_line=$info_line$separator$venv
        pre_prompt="\[$CYAN\]\[$ITALIC\]"
        prompt="❱❱"
    else
        pre_prompt="\[$YELLOW\]"
    fi
    PS1="\$(hr)\n"$info_line"\[$NONE\]\n"$pre_prompt$prompt"\[$NONE\] "

    #
    # History Sharing - These settings share history between terminal tabs.
    #
    history -a
    history -n

    return 0
}

export PROMPT_COMMAND=show_prompt

#
# Miscellaneous
# ----------------------------------------------------------------------

make_targets() {
    make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}'
}
