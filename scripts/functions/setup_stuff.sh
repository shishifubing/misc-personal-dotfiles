#!/usr/bin/env bash

# setup

# add windows 10 uefi entry to grub
setup_grub_add_windows_10_uefi() {

    # exec tail -n +4 $0
    # this line needs to be in the file, without it
    # commands will not be recognized
    update_grub
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
        update_grub
    else
        setup_grub_add_windows_10_uefi
    fi

}

# setup hard links
setup_hard_links() {

    local path="${1:-${HOME}}/dot-files"
    local scripts="${path}/scripts"
    local configs="${path}/configs"
    local firefox="${path}/firefox"

    local vscode_path="${HOME}/.config/Code - OSS/User/settings.json"
    local vscode_config="${configs}/vscode_settings.json"
    local bashrc="${scripts}/bashrc.sh"
    local xinitrc="${scripts}/xinitrc.sh"
    local firefox_path="${HOME}/.mozilla/firefox/${2:-zq1ebncv.default-release}/chrome"
    local firefox_userChrome="${firefox}/userChrome.css"
    local firefox_userContent="${firefox}/userContent.css"
    local firefox_img="${firefox}/img"

    _ln() {
        rm "${2}" 2>/dev/null
        ln "${1}" "${2}"
    }
    _mkdir() {
        rm -r "${1}" 2>/dev/null
        mkdir "${1}"
    }
    _cp() { cp -r "${1}" "${2}" 2>/dev/null; }

    _ln "${vscode_config}" "${vscode_path}"
    _ln "${bashrc}" "${HOME}/.bashrc"
    _ln "${xinitrc}" "${HOME}/.xinitrc"
    _mkdir "${firefox_path}"
    _cp "${firefox_img}" "${firefox_path}"
    _ln "${firefox_userChrome}" "${firefox_path}/userChrome.css"
    _ln "${firefox_userContent}" "${firefox_path}/userContent.css"

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
