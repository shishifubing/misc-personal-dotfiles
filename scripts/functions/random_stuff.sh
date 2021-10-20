#!/usr/bin/env bash

#### random stuff

### openssl

## create password
openssl_password() {

    openssl rand -base64 36

}

### networking

## check open ports
check_ports() {

    sudo ss -tulpn | grep LISTEN

}

### zoom

## installs zoom from aur
zoom_install() {

    git clone https://aur.archlinux.org/zoom.git _zoom
    cd _zoom
    makepkg -si
    rm -rf _zoom

}

### clipboard
## copies to the clipboard
_clip() {

    xclip -sel clip

}

### nginx fix
## fixes 'permission denied while connecting to upstream'
fix_nginx() {

    setsebool -P httpd_can_network_connect 1

}

## certbot installation
# use certbot on rhel
create_certificate_rhel() {

    sudo yum install -y snapd
    sudo systemctl enable --now snapd
    sudo snap install core
    sudo snap refresh core
    sudo yum remove certbot
    sudo snap install --classic certbot
    sudo ln -s /snap/bin/certbot /usr/bin/certbot
    sudo ln -s /var/lib/snapd/snap /snap
    sudo /usr/bin/certbot --nginx --register-unsafely-without-email
    sudo /usr/bin/certbot renew --dry-run
    sudo /usr/bin/certbot renew

}

# create certificate
create_certificate() {

    openssl req -newkey rsa:4096 -nodes -keyout "${1}.key" \
        -x509 -days 365 -out "${1}".crt

}

# rails
rails() {

    docker exec -it gitlab gitlab-rails console

}

# repeat
repeat_string() {

    local repeat="${1:-0}"
    local less="${2:-0}"
    local separator="${3:- }"

    for ((count=0; count < repeat - less; count++)); 
        do echo -n "${separator}"; 
    done
}

# install nvchad
install_nvchad() {

    git clone git@github.com:NvChad/NvChad.git ~/.config/nvim --depth 10 && nvim +PackerSync

}

### arrays

## split a string into an array
array_string() {

    local IFS="${1}"
    read -r -a array <<< "${2}"
    echo "${array[@]}"

}

# execute a command on every array element
array_command(){

    local command="${1}"
    shift
    for array_element in "${@}"; do
        ${command} "${array_element}"
    done
}

# is the element contained in the array
array_in() {

  shopt -s extglob
  local element="${1}"
  shift
  local array=("${@}")
  [[ "$element" == @($(array_join '|' "${array[@]//|/\\|}")) ]]
}

# join array
array_join() {

    local IFS="${1}" 
    shift
    echo "${*}"

}

# cd to the scripts' directory
cd_to_script() {

    local directory=$(
    cd "$(dirname "${BASH_SOURCE[0]}"
    )" &>/dev/null && pwd -P)
    [[ "${1}" ]] && echo "${directory}"

}

# find non-empty binary files in a given folder
find_binaries() {

    find "${1}" ! -path "*/.git/*" -type f ! -size 0 -exec grep -IL .  "{}" \;

}

# send a notification
send_desktop_notification() {

    local alert_message=${1:-" "}
    local alert_icon=${2:-"error"}
    notify-send --urgency=low -i "${alert_icon}" "${alert_message}"

}


# history item
history_item() {

    # show history without numbers and reverse output
    local history_item=$(history -w /dev/stdout | tac | dmenu -l 10)
    history -s "${history_item}"
    echo "${PS1@P}${history_item}"
    ${SHELL:-"/bin/sh"} <<<"${history_item}"

}

# unzip tar.gz and tar.xz
unzip_tr() {

    case "$(get_file_type "${1}")" in
    "xz") tar -xf "${1}" ;;
    *) tar -xvzf "${1}" ;;
    esac

}

