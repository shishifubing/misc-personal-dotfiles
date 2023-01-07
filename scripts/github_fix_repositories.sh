#!/usr/bin/env bash
set -Eeuxo pipefail
. "${DOTFILES_SOURCE}"
source_functions

name="${1:-$(git config --global --get user.name)}"
email="${2:-$(git config --global --get user.email)}"
[[ -z "${name}" || -z ${email} ]] && {
    echo "invalid values: ${name}, ${email}"
    exit 1
}
template="
{{- range . -}}
{{ .name }}
{{ end -}}
"
mapfile -t repos < <(
    gh repo list                 \
        --source                 \
        --visibility public      \
        --json name              \
        --template "${template}"
)

temp=$(mktemp --directory)
for repo in "${repos[@]}"; do
    cd "${temp}"
    url="git@github.com:jingyangzhenren/${repo}.git"
    git clone "${url}"
    cd "${repo}"
    git_filter_repo                             \
        --name-callback "return b\"${name}\""   \
        --email-callback "return b\"${email}\"" \
        --message-callback "return message.replace(b\"borinskikh\", b\"${name}\").replace(b\"kongrentian\", b\"${name}\")"
    git push --force "${url}" "$(git_current_branch)"
    rm -rf "${repo}"
done