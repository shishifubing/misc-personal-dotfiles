#!/usr/bin/env bash

# systemctl

s() {
    sudo systemctl "${@}"
}

# st in tabbed
stt() {

    #[[ -z $TABBED_XID ]] || export TABBED_XID=$(tabbed -d)
    #st -w "$TABBED_XID"
    tabbed -r 2 st -w ""

}

# default compile command
mi() {

    make && sudo make install

}

# vim
v() {

    if [[ "$(which nvim)" ]]; then
        nvim "${@}"
    else
        vim "${@}"
    fi
}

s() {

    sudo --set-home --preserve-env -u "${USER}" bash -c "${@}"

}

g() {

    grep --color=always "${@}"

}
# start vpn
yv() {

    echo '-hfo3-!W' | xclip -sel clip
    echo "token is in your clipboard"
    local directory="${HOME}/Repositories/ya_vpn/"
    local config_file="${HOME}/Repositories/ya_vpn/openvpn.conf"
    sudo openvpn --cd "${directory}" --config "${config_file}"

}

# code-oss
co() {

    local workspace="${HOME}/dotfiles/configs/vscode_workspace.code-workspace"
    local temporary_file="/tmp/vscode_temporary_file"
    [[ -f "${temporary_file}" ]] || touch "${temporary_file}"
    local files=("${workspace}" "${temporary_file}" "${@}")

    source_keymaps
    for file in "${files[@]}"; do
        code-oss --reuse-window "${file}" &
    done

}

db() {

    if [[ -n "${DATABASE_KEY}" ]]; then
        local choice=$(
            echo "
                PRAGMA key = '${DATABASE_KEY}';
                SELECT location, login FROM passwords;
            " |
                sqlcipher ~/Repositories/dot-files/db.db |
                awk 'NR > 3' | dmenu -l 5
        )
        echo "
            PRAGMA key = '${DATABASE_KEY}';
            SELECT password FROM passwords WHERE login==\"${choice}\"
        " |
            sqlcipher "${HOME}/Repositories/dot-files/db.db" |
            xclip -sel clip
    fi

}
