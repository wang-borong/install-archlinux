#!/bin/bash

if [[ $UID == 0 ]]
then
    chown -R wbr:wbr /home/configs

    pacman -S xorg << EOF


EOF
    pacman -S xfce4 xfce4-goodies << EOF



EOF
    pacman -S slim slim-themes archlinux-themes-slim << EOF


EOF
    echo "y" | pacman -S sudo
    pacman -S firefox << EOF


EOF
    pacman -S fcitx-im fcitx-configtool fcitx-googlepinyin << EOF


EOF
    echo "y" | pacman -S ttf-dejavu wqy-zenhei wqy-microhei

    read -p "If use virtualbox, please input y! " vbox
    [[ "$vbox" == "y" ]] && pacman -S virtualbox-guest-utils << EOF


EOF

    echo '
[archlinuxfr]
SigLevel = Optional TrustAll
Server = http://repo.archlinux.fr/$arch
' >> /etc/pacman.conf

    echo "y" | pacman -Sy yaourt

    echo "exec startxfce4" > /home/wbr/.xinitrc
    chown wbr:wbr /home/wbr/.xinitrc

    systemctl start slim
    systemctl enable slim

else

    read -p "what is  your compressed configuration: " pcc
    mkdir -p ~/tmp
    [[ -n "$pcc" ]] && tar -xpf $pcc -C ~/tmp || echo "no configuration"
    (cd ~/tmp/$(ls) && mv .* ~ && mv * ~)
    rm -rf ~/tmp
fi
