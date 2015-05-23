#!/usr/bin/env bash
export USER_ENV_PYTHON_PY3_VERSION=3.4
export PATH=$USER_ENV_UTILS/Python/latest/bin:$PATH
alias 2env-default='source $USER_ENV_UTILS/Python/Envs/py2default/bin/activate'
alias 3env-default='source $USER_ENV_UTILS/Python/Envs/py3default/bin/activate'

# for non-default cases
pyactivate() {
    if [ $# -eq 0 ]; then
        echo "ERROR: Specify virtualenv name."
    else
        . $USER_ENV_UTILS/Python/Envs/"$@"/bin/activate
    fi
}
