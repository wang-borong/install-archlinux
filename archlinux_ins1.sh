##install archlinux with lvm


# functions
mkpartitions_mbr()
{
    # $1 is boot part, $2 is swap part and the rest is lvm. all
    # partions are primary.
    # $1 and $2 are 512M when install archlinux by default.
    if [[ $1 == "" ]]; then
        pa="512M"
    else
        pa=$1
    fi
    if [[ $2 == "" ]]; then
        pb="1G"
    else
        pb=$2
    fi

    fdisk /dev/sda << EOF
n
p


+$pa
n
p


+$pb
n
p



t

8e
w
EOF
}

mkpartitions_efi()
{
    if [[ $1 == "" ]]; then
        pa="512M"
    else
        pa=$1
    fi
    if [[ $2 == "" ]]; then
        pb="1G"
    else
        pb=$2
    fi
    gdisk /dev/sda << EOF
o
y
n


+$pa
ef00
n


+$pb
8200
n



8e00
p
w
y
EOF
}

mkfilesys()
{
    echo "when finished, input q or Q to exit."
    echo ""
    while read -p "which file system(common home, usr, var, opt): " fls;
    do
        case $fls in
        q|Q)
            break
            ;;
        *)
            read -p "size of it, size{M,G}: " sz
            lvcreate -L $sz -n lv_$fls arch_vg00
            mkfs.ext4 /dev/arch_vg00/lv_$fls
            ;;
        esac
    done
}


# change mirror list, installation stage
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
echo "Server = http://mirrors.zju.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist


# Start to install!
echo "start to install archlinux"
# wait 1 seconds
sleep 1
read -p "which type you need to install? mbr or efi? " chty
read -p "input hostname: " hnm

read -p "input size of boot, size{M,G}：" sz_boot
read -p "input size of swap, size{M,G}：" sz_swap
if [[ "$chty" == "efi" ]]; then
    mkpartitions_efi $sz_boot $sz_swapi
    partprobe

    mkfs.fat -F32 /dev/sda1
    mkswap /dev/sda2
    swapon /dev/sda2
else
    mkpartitions_mbr $sz_boot $sz_swap
    partprobe

    mkfs.ext4 /dev/sda1
    mkswap /dev/sda2
    swapon /dev/sda2
fi


# for lvm
pvcreate /dev/sda3
vgcreate arch_vg00 /dev/sda3

read -p "how many you separate for root? size{M,G}: " root
lvcreate -L $root -n lv_root arch_vg00
mkfs.ext4 /dev/arch_vg00/lv_root

read -p "do you create other file systems except home? [Yy|Nn]: " yesno
case $yesno in
Y|y)
    mkfilesys
    ;;
*)
    ;;
esac

read -p "The rest of arch_vg00 are created for lv_home? [Yy|Nn]: " ans
case $ans in
Y|y)
    lvcreate -l 100%FREE -n lv_home arch_vg00
    mkfs.ext4 /dev/arch_vg00/lv_home
    ;;
n|N)
    read -p "how many you separate for home? size{M,G}: " home
    lvcreate -L $home -n lv_home arch_vg00
    mkfs.ext4 /dev/arch_vg00/lv_home
    ;;
*)
    echo ""
    read -p "No separated space for home! really? " recr
        case "$recr" in
        Y|y)
            echo ""
            ;;
        *)
            mkfilesys
            ;;
        esac
    ;;
esac

modprobe dm-mod
vgscan
vgchange -ay

mount /dev/arch_vg00/lv_root /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

SMTFS=$(ls /dev/arch_vg00/lv_* | sed "s/\/dev\/arch_vg00\///")
for mfs in $SMTFS
do
    if [[ $mfs != "lv_root" ]]; then
        fs=$(echo $mfs | sed "s/lv_//")
        mkdir /mnt/$fs
        mount /dev/arch_vg00/$mfs /mnt/$fs
    fi
done

pacstrap /mnt base base-devel

genfstab -U /mnt >> /mnt/etc/fstab


[[ -e /run/archiso/bootmnt/archlinux_ins2.sh ]] &&
    cp /run/archiso/bootmnt/archlinux_ins2.sh /mnt
[[ -d /run/archiso/bootmnt/configs ]] &&
    cp -r /run/archiso/bootmnt/configs /mnt/home

# Run the second step
arch-chroot /mnt /bin/bash archlinux_ins2.sh $hnm $chty


# get log
mv /root/install_archlinux.log /mnt/root


# exit from archlinux_ins2.sh, reboot to new system
umount -R /mnt
reboot
