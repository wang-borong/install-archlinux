#!/bin/bash

if [[ $(ping archlinux.org) != 0 ]]; then
    echo "Set up network e.g. ip link set eth0 up."
    echo "Create dhcpd service e.g. systemctl enable dhcpd && systemctl start dhcpd"
fi

if [[ $UID == 0 ]]
then
    chown -R wbr:wbr /home/configs

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


    systemctl start slim
    systemctl enable slim
else
    echo "exec startxfce4" > ~/.xinitrc

    read -p "what is  your compressed configuration: " pcc
    mkdir -p ~/tmp
    [[ -n "$pcc" ]] && tar -xf $pcc -C ~/tmp || echo "no configuration"
    (cd ~/tmp/$(ls) && mv .* ~)
    rm -rf ~/tmp
fi
