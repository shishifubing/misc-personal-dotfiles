#!/usr/bin/env bash

# source file
source_scripts() {

    for file in "${@}"; do
        [[ -f "${file}" ]] && . "${file}"
    done

}
# sourcescripts in a directory
source_scripts_in_directory() {

    [[ -d "${1}" ]] && source_scripts "${1}"/?*.sh

}

# source bashrc
source_bashrc() {

    source_scripts "${HOME}/.bashrc"

}

sb() {

    source_bashrc

}

# enable programmable completion features
# you don't need to enable this if it's
# already enabled in /etc/bash.bashrc and/or /etc/profile
source_programmable_completion_features() {

    local scripts=(
        "/usr/share/bash-completion/bash_completion"
        "/etc/bash_completion"
    )

    source_scripts "${scripts[@]}"
}

# source functions
source_functions() {

    source_scripts_in_directory "${HOME}/dotfiles/scripts/functions"

}

# update grub
source_grub() {

    sudo grub-mkconfig -o /boot/grub/grub.cfg

}

# fzf
source_fzf_scripts() {

    local scripts=(
        "/usr/share/fzf/key-bindings.bash"
        "/usr/share/fzf/completion.bash"
    )

    source_scripts "${scripts[@]}"

}

# source keymaps
source_keymaps() {

    local userresources="${HOME}/.Xresources"
    local usermodmap="${HOME}/dot-files/configs/Xmodmap"
    local sysresources="/etc/X11/xinit/.Xresources"
    local sysmodmap="/etc/X11/xinit/.Xmodmap"

    [[ -f "${sysresources}" ]] && xrdb -merge "${sysresources}"
    [[ -f "${sysmodmap}" ]] && xmodmap "${sysmodmap}"
    [[ -f "${userresources}" ]] && xrdb -merge "${userresources}"
    [[ -f "${usermodmap}" ]] && xmodmap "${usermodmap}"

    # capslock-escape swap
    # https://wiki.archlinux.org/index.php/xmodmap
    xmodmap -e "clear lock"
    xmodmap -e "keycode 66 = Escape Escape Escape"
    xmodmap -e "keycode 9 = Caps_Lock Caps_Lock Caps_Lock"
    xmodmap -e "add lock = Caps_Lock Caps_Lock Caps_Lock"

}

# source keymaps on startup
source_keymaps_on_start() {

    local filename="/tmp/__keymaps__are__sourced__"

    [[ -f "${filename}" ]] || source_keymaps 2>/dev/null && touch "${filename}"

}
