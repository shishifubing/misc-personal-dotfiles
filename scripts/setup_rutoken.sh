#!/usr/bin/env bash

# some dependencies https://dev.rutoken.ru/pages/viewpage.action?pageId=76218369
sudo pacman -Syu openvpn opensc pcsc-tools ccid 

mkdir ~/Repositories/ya_vpn
cd ~/Repositories/ya_vpn || exit

# private key
wget https://download.yandex.ru/hd/vpn/tls.key

# chain of certificates
wget https://download.yandex.ru/hd/vpn/allCAs.pem

# rutoken library
wget https://download.rutoken.ru/Rutoken/PKCS11Lib/Current/Linux/x64/librtpkcs11ecp.so

# Serialized id
SERIAL="$(openvpn --show-pkcs11-ids ./librtpkcs11ecp.so | grep "Serialized id" | awk '{print $NF}')"

# configuration file for openVPN
echo "dev tun
proto udp
remote openvpn1.yandex.net 1199
remote openvpn2.yandex.net 1199
remote openvpn3.yandex.net 1199
remote openvpn4.yandex.net 1199
remote openvpn5.yandex.net 1199
remote openvpn6.yandex.net 1199
remote openvpn7.yandex.net 1199
remote openvpn8.yandex.net 1199
remote openvpn9.yandex.net 1199
remote openvpn10.yandex.net 1199
remote openvpn11.yandex.net 1199
remote openvpn12.yandex.net 1199
remote openvpn13.yandex.net 1199
remote openvpn14.yandex.net 1199
remote openvpn15.yandex.net 1199
remote openvpn16.yandex.net 1199
remote openvpn17.yandex.net 1199
remote openvpn18.yandex.net 1199
remote openvpn19.yandex.net 1199
remote openvpn20.yandex.net 1199
remote openvpn21.yandex.net 1199
remote openvpn22.yandex.net 1199
remote openvpn23.yandex.net 1199
remote openvpn24.yandex.net 1199

tls-version-max 1.1
resolv-retry infinite
remote-random
server-poll-timeout 5
client
nobind
ca allCAs.pem
cipher AES-128-CBC
verify-x509-name vpn-unix name-prefix
tls-auth tls.key
verb 4

pkcs11-providers ./librtpkcs11ecp.so

pkcs11-id '$SERIAL'" > openvpn.conf

# .bashrc alias
#echo "alias yavpn='sudo openvpn --cd ~/Repositories/ya_vpn/ --config ~/Repositories/ya_vpn/openvpn.conf'" >> ~/.bashrc

# it's needed for the usb token to be recognized
systemctl enable --now pcscd

# end

echo "END"

# bash restart
exec bash
