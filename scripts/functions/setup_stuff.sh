#!/usr/bin/env bash

# setup

# add windows 10 uefi entry to grub
setup_grub_add_windows_10_uefi() {
    local fs_uuid
    # exec tail -n +4 $0
    # this line needs to be in the file, without it
    # commands will not be recognized
    source_grub
    echo "input where the EFI partition is mounted"
    read -r partition
    fs_uuid=$(sudo grub-probe --target=fs_uuid "${partition}/EFI/Microsoft/Boot/bootmgfw.efi")
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
