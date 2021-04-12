#!/bin/bash

cd ~/Repositories/dot-files/ || exit

# vscode_path=~/.config/Code/User/settings.json
vscode_path=~/.config/Code\ -\ OSS/User/settings.json

firefox_path=~/.mozilla/firefox/zq1ebncv.default-release/chrome

make_hard_link() {
    if [ $# == 1 ]; then
      rm -r "$1" 2>/dev/null &&
      mkdir "$1"
    elif [ $# == 2 ]; then
      rm "$1" 2>/dev/null
      ln "$1" "$2"
    else exit
    fi
}

make_hard_link configs/vscode_settings.json "$vscode_path"
make_hard_link configs/bashrc ~/.bashrc
make_hard_link configs/xinitrc ~/.xinitrc
make_hard_link "$firefox_path"
make_hard_link firefox/userChrome.css "$firefox_path"
make_hard_link firefox/userContent.css "$firefox_path"
cp -r firefox/img "$firefox_path"
