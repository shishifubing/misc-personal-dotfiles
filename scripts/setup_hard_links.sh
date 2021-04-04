#!/bin/sh

path=~/Repositories/dot-files/
cd $path

# vscode

# vscode_path=~/.config/Code/User/settings.json
vscode_path=~/.config/Code\ -\ OSS/User/settings.json

rm "$vscode_path" > /dev/null
ln configs/vscode_settings.json "$vscode_path"

# firefox

firefox_path=~/.mozilla/firefox/zq1ebncv.default-release/chrome

rm -r $firefox_path > /dev/null &&
mkdir $firefox_path 
ln firefox/chrome/userChrome.css $firefox_path
ln firefox/chrome/userContent.css $firefox_path
cp -r firefox/chrome/img $firefox_path

# .bashrc

rm ~/.bashrc > /dev/null
ln configs/bashrc ~/.bashrc

# .xinit

rm ~/.xinitrc > /dev/null
ln configs/xinitrc ~/.xinitrc
