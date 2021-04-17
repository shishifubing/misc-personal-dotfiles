#!/usr/bin/env bash

cd ~/Repositories/dot-files/ || exit

#vscode_path=~/.config/Code/User/settings.json # path on windows
vscode_path=~/.config/Code\ -\ OSS/User/settings.json
firefox_path=~/.mozilla/firefox/zq1ebncv.default-release/chrome

_ln () { 

  rm "$2" 2>/dev/null || true
  ln "$1" "$2"

}
_mkdir () {
  
  rm -r "$1" 2>/dev/null || true;
  mkdir "$1"

}
_cp () {
  
  cp -r "$1" "$2" 2>/dev/null || true;

}

_ln configs/vscode_settings.json "$vscode_path"
_ln scripts/dot_bashrc.sh ~/.bashrc
_ln scripts/dot_xinitrc.sh ~/.xinitrc

_mkdir "$firefox_path"
_cp firefox/img "$firefox_path"
_ln firefox/userChrome.css "$firefox_path"
_ln firefox/userContent.css "$firefox_path"

