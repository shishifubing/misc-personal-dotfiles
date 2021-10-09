#!/usr/bin/env bash

# xorg

# start xorg-server
sx() {

    startx

}

# start xorg server
start_xorg_server() {

    if [[ -z "${DISPLAY}" && "${XDG_VTNR}" -eq 1 ]]; then
        echo "start xorg?"
        read -r answer
        [[ "${answer}" != "n" && "${answer}" != "N" ]] && 
            exec startx 
    fi

}
