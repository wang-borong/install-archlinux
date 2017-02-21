# the second step


# functions
other_configs()
{
    # enable dhcp and start it
    systemctl enable dhcpcd && systemctl start dhcpcd

    # install apps
    echo "y" | pacman -S zsh wget git vim gcc

    # creat group and user (wbr)
    groupadd wbr
    useradd -m -g wbr -G wheel -s /usr/bin/zsh wbr
    echo "wbr:dlp" > /home/passwd_of_wbr | chpasswd

    # change to zsh and config
    #chsh -s /usr/bin/zsh

    #tar xvpf $(echo /home/configs/backup*) -C /root
    #cd ~ && cp -r $(echo /root/backup*)/.* ~
    #mv $(echo /root/backup*)/.* /home/wbr && chown -R wbr:wbr /home/wbr/.*

    #rm -rf $(echo /root/backup*)
    rm -rf /archlinux_ins2.sh
}


# change mirror list, chroot stage
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
echo "Server = http://mirrors.zju.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo $1 >> /etc/hostname
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

sed -i "s/\#en_US\.UTF\-8/en_US\.UTF\-8/" /etc/locale.gen
sed -i "s/\#zh_CN\.UTF\-8/zh_CN\.UTF\-8/" /etc/locale.gen
locale-gen

echo "export LANG=en_US.UTF-8" >> /etc/locale.conf

sed -i "s/ block filesystems / block lvm2 filesystems /" /etc/mkinitcpio.conf


mkinitcpio -p linux

echo "y" | pacman -S grub

grub-install --target=i386-pc --recheck --debug /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg


# set passwd for root
pswd=$(date +%s | sha256sum | base64 | head -c 10 ; echo)
echo "root:$pswd" > /home/passwd_of_root | chpasswd


# do other configs
other_configs


# archlinux_ins3.sh
read -p "Do you want to install xfce4? " xfce
case $xfce in
Y|y)
    [[ -r archlinux_ins3.sh ]] &&
        bash archlinux_ins3.sh ||
        echo "No script to install xfce4!"
    ;;
*)
    ;;
esac


exit
