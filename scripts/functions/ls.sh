#!/usr/bin/env bash

# ls aliases

# default
l() {

    ls --color --human-readable "${@}"

}

# hidden files
la() {

    l --all --size "${@}"

}

# vertical
ll() {

    l -l --no-group "${@}"

}

# cd
c() {

    cd "${1:-${HOME}}" || true
    l

}
