# the next step


# Change mirror list (chroot stage). We always want to download package as far as possible.
# For safeness, back it up.
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
echo 'Server = http://mirrors.zju.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

# Sorry, for chinese only now.
echo $1 > /etc/hostname
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

sed -i "s/\#en_US\.UTF\-8/en_US\.UTF\-8/" /etc/locale.gen
sed -i "s/\#zh_CN\.UTF\-8/zh_CN\.UTF\-8/" /etc/locale.gen
locale-gen

echo "export LANG=en_US.UTF-8" >> /etc/locale.conf

# The HOOK is important. Use systemd and sd-lvm2 to setup lvm.
sed -i "s/base udev autodetect modconf block filesystems keyboard fsck/base systemd autodetect modconf block sd-lvm2 filesystems keyboard fsck/" /etc/mkinitcpio.conf
# and put in linux
mkinitcpio -p linux
# if you have a custom version
# mkinitcpio -p linux-custom

# perhaps... The efi mode is the mainstream of the future.
pacman -S --noconfirm grub-efi-x86_64 efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg


# Maybe someone use virtualbox with efi to intall Arch, but something should be modified.
#read -p "If you use virtualbox, please input y: " vbefi
#case $vbefi in
#    Y|y)
#        if [[ "$2" == "efi" ]]; then
#            cd /boot/EFI && cp -r grub BOOT
#            cd BOOT && mv grubx64.efi BOOTX64.EFI
#        fi
#        ;;
#    *)
#        ;;
#esac

# Set passwd for root. Now it is yours.
passwd


# Do other configs
# enable dhcp and start it
systemctl enable dhcpcd && systemctl start dhcpcd

# My favorite
pacman -S --noconfirm zsh wget git gvim

# Everyone should not use root, so create a user soon.
# Creat group and user ($2)
# group name = user name = $2
groupadd $2
useradd -m -g $2 -G wheel -s /usr/bin/zsh $2
passwd $2

# It's time to exit
exit
