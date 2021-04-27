#!/usr/bin/env bash

xinitrc_d=/etc/X11/xinit/xinitrc.d
# shellcheck source=/dev/null
# it silences shellcheck warnings about non-constant source
if [ -d "$xinitrc_d" ]; then
    for script in "$xinitrc_d"?*.sh; do
        [ -x "$script" ] &&
            . "$script"
    done
    unset script
fi

export DESKTOP_SESSION=plasma
exec startplasma-x11
