#!/usr/bin/env bash

xinitrc_d=/etc/X11/xinit/xinitrc.d
[[ -d "${xinitrc_d}" ]] &&
    for script in "${xinitrc_d}"?*.sh; do
        [ -x "${script}" ] &&
            . "${script}"
    done
sudo source_keymaps

export DESKTOP_SESSION=plasma
exec startplasma-x11
