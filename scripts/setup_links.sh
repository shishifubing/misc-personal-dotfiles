#!/usr/bin/env bash
set -Eeuxo pipefail

dir_scripts="${DOTFILES}/scripts"
dir_configs="${DOTFILES}/configs"
dir_firefox="${DOTFILES}/firefox"
dir_firefox_target="${HOME}/.mozilla/firefox"
dir_vim="${DOTFILES}/vim"
dir_vscode_oss="${HOME}/.config/Code - OSS"
dir_vscode="${HOME}/.config/Code"

source_vscode_settings="${dir_configs}/vscode_settings.json"
source_vscode_keybindings="${dir_configs}/vscode_shortcuts.json"
source_bashrc="${dir_scripts}/bashrc.sh"
source_xinitrc="${dir_scripts}/xinitrc.sh"
source_emacs="${dir_scripts}/emacs"
source_vimrc="${dir_vim}/vimrc"


function link_file() {
    local files
    # replace ';' with ' ' to make an array
    read -ra files <<<"${1//;/ }"
    mkdir -p "$(dirname "${files[1]}")"
    ln -fs "${files[0]}" "${files[1]}"
}

links=(
    "${source_vscode_settings};${dir_vscode}/User/settings.json"
    "${source_vscode_settings};${dir_vscode_oss}/User/settings.json"
    "${source_vscode_keybindings};${dir_vscode}/User/keybindings.json"
    "${source_vscode_keybindings};${dir_vscode_oss}/User/keybindings.json"
    "${source_bashrc};${HOME}/.bashrc"
    "${source_xinitrc};${HOME}/.xinitrc"
    "${source_emacs};${HOME}/.emacs"
    "${source_vimrc};${HOME}/.vimrc"
)

for link in "${links[@]}"; do
    link_file "${link}"
done

for directory in "${dir_firefox_target}"/*; do
    [[ -d "${directory}" ]] || continue
    [[ "${directory}" == *"release"* ]] || continue
    mkdir -p "${directory}/chrome"
    for file in "${dir_firefox}"/*; do
        [[ -d "${file}" ]] && continue
        ln -fs "${file}" "${directory}/chrome/$(basename "${file}")"
    done
done