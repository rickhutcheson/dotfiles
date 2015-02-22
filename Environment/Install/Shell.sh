#!/usr/bin/env bash

# Move dotfiles into appropriate place
for df in $USER_ENV_CONFIG/Shell/*; do
    name=$(basename $df)
    if [[ -f $df ]] && [[ $name == dot-* ]]  
    then
        ln -s $df ~/.${name:4} # remove "dot-" prefix
    fi
done

# git completion

echo "if [ -f ~/.git-completion.bash ]; then . ~/.git-completion.bash; fi" >> ~/.bash_profile
