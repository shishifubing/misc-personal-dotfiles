#!/usr/bin/env bash
set -Eeuxo pipefail

export DOTFILES="${DOTFILES:-${HOME}/Dotfiles}"
dir_scripts="${DOTFILES}/scripts"
dir_configs="${DOTFILES}/configs"
dir_firefox="${DOTFILES}/firefox"
dir_firefox_target="${HOME}/.mozilla/firefox"
dir_vim="${DOTFILES}/vim"
dir_vscode_oss="${HOME}/.config/Code - OSS"
dir_vscode="${HOME}/.config/Code"
dir_vscodium="${HOME}/.config/VSCodium"

source_vscode_settings="${dir_configs}/vscode_settings.json"
source_vscode_keybindings="${dir_configs}/vscode_shortcuts.json"
source_bashrc="${dir_scripts}/bashrc.sh"
source_xinitrc="${dir_scripts}/xinitrc.sh"
source_emacs="${dir_scripts}/emacs"
source_vimrc="${dir_vim}/vimrc"
source_terraformrc="${dir_configs}/.terraformrc.hcl"


function link_file() {
    local files
    IFS=";"
    read -ra files <<<"${1}"
    [[ "${#files[@]}" != 2 ]] && {
        echo "invalid array: ${files[*]}"
        exit 1
    }
    [[ -d "${files[0]}" ]] && {
        echo "cannot link directory"
        exit 1
    }
    mkdir -p "$(dirname "${files[1]}")"
    ln -fs "${files[0]}" "${files[1]}"
}

# array of files to link
links=(
    "${source_vscode_settings};${dir_vscode}/User/settings.json"
    "${source_vscode_settings};${dir_vscode_oss}/User/settings.json"
    "${source_vscode_settings};${dir_vscodium}/User/settings.json"

    "${source_vscode_keybindings};${dir_vscode}/User/keybindings.json"
    "${source_vscode_keybindings};${dir_vscode_oss}/User/keybindings.json"
    "${source_vscode_keybindings};${dir_vscodium}/User/keybindings.json"

    "${source_bashrc};${HOME}/.bashrc"
    "${source_xinitrc};${HOME}/.xinitrc"
    "${source_emacs};${HOME}/.emacs"
    "${source_vimrc};${HOME}/.vimrc"
    "${source_terraformrc};${HOME}/.terraformrc"
)

# link all files from the firefox directory to all firefox profiles
for directory in "${dir_firefox_target}"/*; do
    [[ -d "${directory}" ]] || continue
    [[ "${directory}" == *"release"* ]] || continue
    for file in "${dir_firefox}"/*; do
        [[ -d "${file}" ]] && continue
        links+=("${file};${directory}/chrome/$(basename "${file}")")
    done
done

# create actual links
for link in "${links[@]}"; do
    link_file "${link}"
done