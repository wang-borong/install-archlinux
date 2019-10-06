#!/bin/bash


if [[ $UID == 0 ]]
then
    read "input your user name: " user_name
    # yaourt is nice
    echo '
[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
' >> /etc/pacman.conf

    # Xface environment and ...
    pacman -Sy --confirm xorg xfce4 xfce4-goodies slim archlinux-themes-slim \
        slim-themes
    # lxqt...

    # programs
    pacman -S --confirm sudo fcitx-im fcitx-configtool fcitx-googlepinyin \
        ttf-dejavu wqy-zenhei wqy-microhei yay firefox

    read -p "If use virtualbox, please input y! " vbox
    [[ "$vbox" == "y" ]] && yes " " | pacman -S virtualbox-guest-utils

    echo "exec startxfce4" > /home/$user_name/.xinitrc
    chown $user_name:$user_name /home/$user_name/.xinitrc

    systemctl enable slim && systemctl start slim
else
    echo "do it as root"
    exit 1
fi
