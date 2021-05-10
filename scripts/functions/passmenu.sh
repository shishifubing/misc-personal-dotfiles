#!/usr/bin/env bash

# password manager script
passmenu() {

    shopt -s nullglob globstar
    local typeit=0
    if [[ "${1}" == "--type" ]]; then
        typeit=1
        shift
    fi
    local prefix="${PASSWORD_STORE_DIR-~/.password-store}"
    local password_files=("${prefix}"/**/*.gpg)
    password_files=("${password_files[@]#"${prefix}"/}")
    password_files=("${password_files[@]%.gpg}")
    local password=$(printf '%s\n' "${password_files[@]}" | dmenu "${@}")
    [[ -n "${password}" ]] || exit
    if [[ "${typeit}" -eq 0 ]]; then
        pass show -c "${password}" 2>/dev/null
    else
        pass show "${password}" | {
            IFS= read -r pass
            printf %s "${pass}"
        } |
            xdotool type --clearmodifiers --file -
    fi

}
