#!/bin/sh

cd ~/Repositories/dot-files/

# vscode_path=~/.config/Code/User/settings.json
vscode_path=~/.config/Code\ -\ OSS/User/settings.json
vscode_config=configs/vscode_settings.json

bashrc_path=~/.bashrc
bashrc_config=configs/bashrc

xinitrc_path=~/.xinitrc
xinitrc_config=configs/xinitrc

locale_path=/etc/locale.conf
locale_config=configs/locale.conf

firefox_path=~/.mozilla/firefox/zq1ebncv.default-release/chrome
firefox_config_chrome=firefox/userChrome.css
firefox_config_content=firefox/userContent.css
firefox_config_img=firefox/img

make_hard_link() {
    rm "$2" 2>&1>/dev/null
    ln "$1" "$2"
}

rm -r $firefox_path && mkdir $firefox_path 
cp -r $firefox_config_img $firefox_path
make_hard_link $firefox_config_chrome $firefox_path
make_hard_link $firefox_config_content $firefox_path
make_hard_link $vscode_config $vscode_path
make_hard_link $bashrc_config $bashrc_path
make_hard_link $xinitrc_config $xinitrc_path
sudo make_hard_link $locale_config $locale_path
