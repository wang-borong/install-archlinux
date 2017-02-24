#!/bin/bash

if [[ $UID == 0 ]]
then
    chown -R wbr:wbr /home/configs

    pacman -S xorg
    pacman -S slim slim-themes archlinux-themes-slim
    pacman -S xfce4 xfce4-goodies
    pacman -S sudo
    pacman -S firefox
    pacman -S fcitx-im fcitx-configtool fcitx-googlepinyin

    echo '
[archlinuxfr]
SigLevel = Optional TrustAll
Server = http://repo.archlinux.fr/$arch
' >> /etc/pacman.conf

    pacman -S yaourt


    systemctl start slim
    systemctl enable slim

    echo "exec startxfce4" > /home/wbr/.xinitrc
    chown wbr:wbr /home/wbr/.xinitrc

else

    read -p "what is  your compressed configuration: " pcc
    mkdir -p ~/tmp
    [[ -n "$pcc" ]] && tar -xf $pcc -C ~/tmp || echo "no configuration"
    (cd ~/tmp/$(ls) && mv .* ~ && mv * ~)
    rm -rf ~/tmp
fi
