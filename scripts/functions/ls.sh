#!/usr/bin/env bash

# ls aliases

# default
l() {

    ls --color=always --human-readable "${@}"

}

# hidden files
la() {

    l --all --size "${@}"

}

# vertical
l_l() {

    l -l --no-group "${@}"

}

# cd
c() {

    cd "${1:-${HOME}}" || true
    l

}
