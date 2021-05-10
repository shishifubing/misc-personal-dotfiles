#!/usr/bin/env bash

# python aliases

# python
py() {

    python "${@}"

}

# python virtual environment
pips() {

    export ENVIRONMENT="pipenv"
    pipenv shell
    unset ENVIRONMENT

}

# pip install
pipi() {

    pip install "${@}"

}
