#!/usr/bin/env bash

# plugin manager
vim_install_module() {

    local type="start"
    [[ "${1}" == "opt" ]] && type=${1} && shift
    for module in "${@}"; do
        local location="${HOME}/dot-files/vim/pack/modules/${type}/${module//*"/"/}"
        local module="https://github.com/${module}.git"

        git submodule add --force "${module}" "${location}"
    done

    # generate new help tags
    vim -u NONE -c "helptags ALL" -c q

}

vim_delete_module() {

    local type="start"
    [[ "${1}" == "opt" ]] && type=${1} && shift
    local module="${HOME}/dot-files/vim/pack/modules/${type}/${1}"

    git submodule deinit -f "${module}"
    git rm -f "${module}"

}
