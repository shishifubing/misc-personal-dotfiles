#!/usr/bin/env bash

# merge in defaults and keymaps

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

if [ -f "$sysresources" ]; then
    xrdb -merge "$sysresources"
fi

if [ -f "$sysmodmap" ]; then
    xmodmap "$sysmodmap"
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some programs

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
