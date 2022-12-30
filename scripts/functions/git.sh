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

# get current git branch
git_current_branch() {
    git branch --show-current 2>/dev/null
}

# get current commit hash
git_commit_hash() {
    git rev-parse --short HEAD 2>/dev/null
}

# return number of changed files
git_changed_files() {
    git status --porcelain=v1 2>/dev/null | wc -l
}

# git
git_get_diff() {
    git format-patch --stdout HEAD^
}

git_change_commit_author() {
    local name email path
    name="${1:-'jingyangzhenren'}"
    email="${2:-'97828377+jingyangzhenren@users.noreply.github.com'}"
    path="${3:-${HOME}/Repositories/Public/git-filter-repo/git-filter-repo}"
    "${path}"                                   \
        --name-callback "return b\"${name}\""   \
        --email-callback "return b\"${email}\""
}