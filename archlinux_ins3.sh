# the third step


ins()
{
    while [[ -n "$1" ]]
    do
        echo "Y" | pacman -S $1
        shift
    done
}


ins xorg
ins slim slim-themes archlinux-themes-slim
ins xfce4 xfce4-goodies
ins sudo
ins virtualbox-guest-utils
ins firefox
ins fcitx-im fcitx-configtool fcitx-googlepinyin

echo '
[archlinuxfr]
SigLevel = Optional TrustAll
Server = http://repo.archlinux.fr/$arch
' >> /etc/pacman.conf

ins yaourt


echo "exec startxfce4" > ~/.xinitrc

(su wbr && echo "exec startxfce4" > /home/wbr/.xinitrc)


exit
