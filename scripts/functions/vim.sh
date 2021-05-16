#!/usr/bin/env bash

# plugin manager
vim_install_module() {

    for module in "${@}"; do
        local location="${HOME}/dot-files/vim/pack/modules/start/${module//*"/"/}"
        local module="https://github.com/${module}.git"

        git submodule add --force "${module}" "${location}"
    done

    # generate new help tags
    vim -u NONE -c "helptags ALL" -c q

}

vim_delete_module() {

    local module="${HOME}/dot-files/vim/pack/modules/start/${1}"

    git submodule deinit -f "${module}"
    git rm -f "${module}"

}
