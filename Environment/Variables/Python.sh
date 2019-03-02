#!/usr/bin/env bash
export USER_ENV_PYTHON_PY3_VERSION=3.5
export PATH=$USER_ENV_UTILS/Python/latest/bin:$PATH

# py2default
export PY2_DEFAULT_VENV=$USER_ENV_UTILS/Python/Envs/py2default
alias 2env-default='source $USER_ENV_UTILS/Python/Envs/py2default/bin/activate'

# py3default
# Python 3.7 testing
export PY3_DEFAULT_VENV=$USER_ENV_UTILS/Python/Envs/py3default
#export PY3_DEFAULT_VENV=$USER_ENV_UTILS/Python/Envs/py3default
export PY3_DEFAULT_VENV_ACTIVATE=$PY3_DEFAULT_VENV/bin/activate
alias 3env-default='source $PY3_DEFAULT_VENV_ACTIVATE'

# for non-default cases
pyactivate() {
    if [ $# -eq 0 ]; then
        echo "ERROR: Specify virtualenv name."
    else
        . $USER_ENV_UTILS/Python/Envs/"$@"/bin/activate
    fi
}

pyls() {
    cd $USER_ENV_UTILS/Python/Envs
    ls -l
}
