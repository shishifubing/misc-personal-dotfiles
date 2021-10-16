#!/bin/env bash
set -e
if [[ $(id -u) -ne 0 ]]; then
    echo "Please run as root"
    exit 1
fi
echo "Setting up Noto Emoji font..."
# 1 - install  noto-fonts-emoji package
pacman -S noto-fonts-emoji --needed
# pacman -S powerline-fonts --needed
echo "Recommended system font: "
echo "inconsolata regular (ttf-inconsolata or powerline-fonts)"
# 2 - add font config to /etc/fonts/conf.d/01-notosans.conf
echo "${DOTFILES}/configs/etc_fonts_local.conf" >/etc/fonts/local.conf
# 3 - update font cache via fc-cache
fc-cache
echo "Noto Emoji Font is installed "
echo "you may need to restart applications like chrome. "
echo "If chrome displays no symbols or no letters, "
echo "your default font contains emojis."
echo "consider inconsolata regular"
