#!/bin/bash


pacman -S xorg
pacman -S slim slim-themes archlinux-themes-slim
pacman -S xfce4 xfce4-goodies
pacman -S sudo
pacman -S virtualbox-guest-utils
pacman -S firefox
pacman -S fcitx-im fcitx-configtool fcitx-googlepinyin

echo '
[archlinuxfr]
SigLevel = Optional TrustAll
Server = http://repo.archlinux.fr/$arch
' >> /etc/pacman.conf

pacman -S yaourt


echo "exec startxfce4" > ~/.xinitrc

systemctl start slim
systemctl enable slim


read -p "what is  your compressed configuration: " pcc
mkdir tmp
[[ -n "$pcc" ]] && tar -xf $pcc -C ./tmp || echo "no configuration"
(cd tmp/$(ls) && mv .* ~)
rm -rf tmp
