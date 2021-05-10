#!/usr/bin/env bash

# random stuff

# st in tabbed
stt() {

    #[[ -z $TABBED_XID ]] || export TABBED_XID=$(tabbed -d)
    #st -w "$TABBED_XID"
    tabbed -r 2 st -w ''

}

# send a notification
send_desktop_notification() {

    local alert_message=${1:-" "}
    local alert_icon=${2:-"error"}
    notify-send --urgency=low -i "${alert_icon}" "${alert_message}"

}

# default compile command
mi() {

    make && sudo make install

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

    local workspace="${HOME}/dot-files/configs/vscode_workspace.code-workspace"
    local temp="/tmp/vscode_temp_file"
    local input=("${workspace}" "${@}" "${temp}")

    source_keymaps
    code-oss --reuse-window "${input[@]}"

}

# history item
history_item() {

    # show history without numbers and reverse output
    local history_item=$(history -w /dev/stdout | tac | dmenu -l 10)
    history -s "${history_item}"
    echo "${PS1@P}${history_item}"
    echo "${history_item}" | ${SHELL:-"/bin/sh"}

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

# vim
v() {

    vim "${@}"

}

# unzip tar.gz and tar.xz
unzip_tr() {

    case "$(get_file_type "${1}")" in
    "xz") tar -xf "${1}" ;;
    *) tar -xvzf "${1}" ;;
    esac

}
