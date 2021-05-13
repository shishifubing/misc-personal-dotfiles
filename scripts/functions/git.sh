#!/usr/bin/env bash

# git

# clone a repository
gc() {

    git clone "${@}"

}

# default git push
gd() {

    local message=${1:-"update"}
    local day=${2:-"$(date +"%d")"}
    local month=${3:-"$(date +"%m")"}
    local year=${4:-"$(date +"%Y")"}
    local date="${year}-${month}-${day} 00:00:00"

    export GIT_AUTHOR_DATE=${date}
    export GIT_COMMITTER_DATE=${date}
    git add .
    git commit -m "${message}"
    git push origin

}
