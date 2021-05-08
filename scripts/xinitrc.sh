#!/usr/bin/env bash

source_scripts_in_directory "/etc/X11/xinit/xinitrc.d"
source_keymaps
export DESKTOP_SESSION=plasma
exec startplasma-x11
