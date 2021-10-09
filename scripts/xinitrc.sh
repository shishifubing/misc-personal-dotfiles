#!/usr/bin/env bash


. "${HOME}/dot-files/scripts/functions/source_stuff.sh" || return

source_functions
source_scripts_in_directory "/etc/X11/xinit/xinitrc.d"
source_keymaps
start_kde
