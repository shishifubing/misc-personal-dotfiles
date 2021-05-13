#!/usr/bin/env bash

# plugin manager
vim_install_module() {

    for module in "${@}"; do
        local location="${HOME}/dot-files/vim/pack/modules/start/${module//*"/"/}"
        local module="https://github.com/${module}.git"

        git submodule add --force "${module}" "${location}"
    done

}

vim_delete_module() {

    git submodule deinit "${1}"
    git rm "${1}"

}
