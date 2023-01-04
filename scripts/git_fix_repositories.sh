#!/usr/bin/env bash
set -Eeuxo pipefail
. "${DOTFILES_SOURCE}"
source_functions

name="${1:-jingyangzhenren}"
email="${2:-97828377+jingyangzhenren@users.noreply.github.com}"
repos=(
    "plugin-firefox-new-tab-bookmarks"
    "plugin-sonatype-nexus-security-check"
    "chatbot-telegram-currency-converter"
    "plugin-firefox-new-tab-bookmarks"
    "snippets-golang-leetcode"
    "app-web-django-assignment"
    "app-cli-autoscroll"
    "app-web-tianyi"
    "app-web-crawler-book-creator"
    "snippets-javascript-assignments"
    "app-desktop-useless-cpp-gui"
)

for repo in "${repos[@]}"; do
    cd "${HOME}/Repositories/tmp"
    rm -rf "${repo}"
    url="git@github.com:jingyangzhenren/${repo}.git"
    git clone "${url}"
    cd "${repo}"
    git_filter_repo                             \
        --name-callback "return b\"${name}\""   \
        --email-callback "return b\"${email}\"" \
        --message-callback "return message.replace(b\"kongrentian\", b\"${name}\")"
    git push --force "${url}" "$(git_current_branch)"
    cd ../
    rm -rf "${repo}"
done