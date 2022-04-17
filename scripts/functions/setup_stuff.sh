#!/usr/bin/env bash

# setup

# add windows 10 uefi entry to grub
setup_grub_add_windows_10_uefi() {

    # exec tail -n +4 $0
    # this line needs to be in the file, without it
    # commands will not be recognized
    source_grub
    echo "input where the EFI partition is mounted"
    read -r partition
    local fs_uuid=$(sudo grub-probe --target=fs_uuid "${partition}/EFI/Microsoft/Boot/bootmgfw.efi")
    entry='
    # Windows 10 EFI entry
    if [ "${grub_platform}" == "efi" ]; then'"
        menuentry \"Microsoft Windows 10 UEFI\" {
        insmod part_gpt
        insmod fat
        insmod search_fs_uuid
        insmod chain
        search --fs-uuid --set=root ${fs_uuid}
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
    }
    fi"
    echo "${entry}"
    echo
    echo "is that okay?"
    read -r answer
    if [[ "${answer}" != "n" && "${answer}" != "N" ]]; then
        echo "${entry}" | sudo tee -a "/etc/grub.d/40_custom"
        source_grub
    else
        setup_grub_add_windows_10_uefi
    fi

}

# setup hard links
setup_hard_links() {

    local scripts="${DOTFILES}/scripts"
    local configs="${DOTFILES}/configs"
    local firefox="${DOTFILES}/firefox"

    #local vscode_path="${HOME}/.config/Code - OSS/User/settings.json"
    local vscode_path="${HOME}/.config/Code/User/settings.json"
    local vscode_config="${configs}/vscode_settings.json"
    local bashrc="${scripts}/bashrc.sh"
    #local emacs="${scripts}/emacs"
    local xinitrc="${scripts}/xinitrc.sh"
    local vimrc="${DOTFILES}/vim/vimrc"

    local firefox_path="${HOME}/.mozilla/firefox"

    _prepare() {
        rm --force "${2}"
        echo -e "\"${1}\" ${GC_36}->${GC_END} \"${2}\""
    }
    _ln() {
        _prepare "${1}" "${2}"
        ln "${1}" "${2}"
    }
    _cp() {
        _prepare "${1}" "${2}"
        cp -rf "${1}" "${2}"
    }

    _ln "${vscode_config}" "${vscode_path}"
    _ln "${bashrc}" "${HOME}/.bashrc"
    _ln "${xinitrc}" "${HOME}/.xinitrc"
    #_ln "${emacs}" "${HOME}/.emacs"
    _ln "${vimrc}" "${HOME}/.vimrc"

    for directory in "${firefox_path}"/*; do
        [[ -d "${directory}" ]] || continue
        [[ "${directory}" == *"release"* ]] || continue
        echo "-----------------------------------"
        echo "setting up directory '${directory}'"
        echo "-----------------------------------"
        mkdir -p "${directory}/chrome"
        for file in "${firefox}"/*; do
            if [[ -d "${file}" ]]; then
                _cp "${file}" "${directory}/chrome/$(basename "${file}")"
                continue
            fi
            _ln "${file}" "${directory}/chrome/$(basename "${file}")"
        done
    done
}

# setup repositories
setup_repositories() {

    mkdir "${HOME}/${1:-Repositories}" 2>/dev/null
    cd "${HOME}/${1-Repositories}" || exit
    local repositories=(
        "https://git.suckless.org/dmenu"
        "https://github.com/borinskikh/dot-files"
        "https://github.com/borinskikh/book-creator"
        "https://github.com/borinskikh/notes"
    )

    for repository in "${repositories[@]}"; do
        git clone "${repository}"
    done

}

# setup binaries
setup_binaries() {

    #local github="https://github.com"
    #local
    #link="${github}/koalaman/shellcheck/releases/download"
    #wget ${link}v0.7.2/shellcheck-v0.7.2.linux.x86_64.tar.xz
    echo
}
