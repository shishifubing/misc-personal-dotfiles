#!/usr/bin/env bash

# xorg

# start xorg-server
sx() {

    startx

}

# start xorg server
start_xorg_server() {

    if [[ -z "${DISPLAY}" && "${XDG_VTNR}" -eq 1 ]]; then
        echo -e "$(get_shell_separator_line)"
        echo "Start xorg-server?"
        echo -e "$(get_shell_separator_line)"
        read -r answer
        [[ "${answer}" != "n" && "${answer}" != "N" ]] && exec startx
    fi

}
