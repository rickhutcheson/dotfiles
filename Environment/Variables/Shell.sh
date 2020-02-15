#!/usr/bin/env bash

#
# Bash Customization
#
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

#
# Customize a bit of autocomplete behavior
#
export INPUTRC=~/.inputrc

# History Control
# ----------------------------------------------------------------------
shopt -s histappend                      # remember history
shopt -s cmdhist 			 # attempt to remember multi-line commands correctly
export HISTCONTROL=erasedups     	 # erase duplicate commands from history
export HISTSIZE=100000
export DAILY_TRANSFER_LIMIT=50           # the number of lines to transfer from yesterday

#
# Keep backup history files for each day so we can get back to old commands
#
export HISTFILE=~/.history/`date +%Y-%m-%d`.hist

# The first time a history file is generated for today, let's copy 50
# commands from last session into today's =]
# (From http://bradchoate.com/weblog/2006/05/19/daily-history-files-for-bash)
if [[ ! -e $HISTFILE ]]; then
    LASTHIST=~/.history/`ls -tr ~/.history/ | tail -1`
    if [[ -e $LASTHIST ]]; then
        # this awk line keeps unique lines found in the `tail -r` output
        # so that we transfer the last N *unique* lines from yesterday's history
        #
        # source: StackExchange (originally #bash on Freenode)
        #
        tail -r $LASTHIST | awk '!seen[$0]++'  | grep . -m $DAILY_TRANSFER_LIMIT >> $HISTFILE
        # Write a divider to identify where the prior day's session history ends
        echo "##########################################################" >> $HISTFILE
    fi
fi

hh()
{
    grep -r "$@" ~/.history
}
# Global Aliases / Utilities
# ----------------------------------------------------------------------
alias nano='emacs -nw'  # emacs in terminal & no init file (fast)
export PATH=$PATH:$USER_ENV_UTILS/Shell/

# General Appearance
# ----------------------------------------------------------------------

export CLICOLOR=1  # Enable colors for BSD variants (including macOS)

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


cwd="\[$CYAN\]\w\[$NONE\]"
separator="\[$WHITE\] // \[$NONE\]"

hr() {
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' ─
}

show_prompt() {
    prompt=">"
    info_line=$cwd
    branch=''
    current_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)  # get branch name (if possible)
    if [ $? -eq 0 ]
    then
        branch="\[$NONE\]\[$RED\]"$current_branch"\[$NONE\]"
        info_line=$info_line$separator$branch
    fi

    if [ "$VIRTUAL_ENV" ]
    then
        if [ "$VIRTUAL_ENV_COLOR" ]
        then
            vcolor=$(tput setaf $VIRTUAL_ENV_COLOR)
        else
            vcolor=$GREEN
        fi
        venv=$vcolor$(basename $VIRTUAL_ENV)$NONE
        info_line=$info_line$separator$venv
        pre_prompt="\[$vcolor\]\[$ITALIC\]"
        prompt=">>"
        # try to set the iterm variable
        iterm2_set_user_var venv `[[ -n $VIRTUAL_ENV ]] && basename $VIRTUAL_ENV || ""`  2>/dev/null || echo

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

#######################################
# Displays a boxed string:
#  ╔═════════╗
#╠═╣ Hello!  ║
#  ╚═════════╝
#
#######################################
proclaim() {
    local line="$1"
    local line_length=${#line}

    # top line
    printf "\n${CYAN}╗ ╔"
    # line_length + 5 is for the 3 extra spaces around $line and 2 for the sign
    for (( i = 0; i < line_length+5; i++ )); do
        printf '═'
    done
    printf "╗\n"

    # text
    printf "╠═╣ $line    ║\n"

    # bottom line
    printf '╝ ╚'  # 5 characters for prefix of sign
    for (( i = 0; i < line_length+5; i++ )); do
        printf '═'
    done
    printf "╝\n"

    # finish sign
    printf "\n${NONE}"
}

#
# Miscellaneous
# ----------------------------------------------------------------------

make_targets() {
    make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}'
}
