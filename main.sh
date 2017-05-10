## Install archlinux with lvm

read -p "have you made partitions and mount them? " yn
if [[ $yn == "n" ]]; then
    echo "
You should make partitions and formatting them before using this script.
The method:
  make partitions:
    gdisk /dev/sdx  (lvm - 8e00, ufi - ef00, swap - 8200, etc.)
    !!make a gpt first by option o
  formatting them:
    mkfs.ext4 /dev/sdxn
  make lvm:
    pvcreate /dev/sdxn
    vgcreate vg00 /dev/sdxn
    lvcreate -L size(G,M) -n name vg00
  lvm expansion:
    lvextend -L +size vg00/home /dev/sdxn  -  Extend the size of an LV by size, using a specific PV.
  man lvextend, vgextend to read the details

Then, you should mount them, e.p.:
  mount /dev/sda2 /mnt
  mkdir -p /mnt/boot
  mount /dev/sda1 /mnt/boot
  ...
    "
    exit 1
else
    echo "Okay, let's go."
fi

# change mirror list, installation stage
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
echo 'Server = http://mirrors.zju.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

# set wifi, i always use wifi
wifi-menu

# Start to install!
echo "start to install archlinux"
# get them at the begining and you will never handle them.
read -p "input hostname: " host_name
read -p "input a user name: " user_name

# optional choice if all steps are correct
partprobe
vgchange -ay

# main...
pacstrap /mnt base base-devel

# mount what you always use and genfstab will detected them and wirten to fstab.
genfstab -U /mnt >> /mnt/etc/fstab

# Run the second step. We can not do next step in this script. The environment will change(chroot). But we can use another script to do the next.
cp aide.sh /mnt  # copy it to new environment
arch-chroot /mnt /bin/bash aide.sh $host_name $user_name  # and execute
rm -f /mnt/aide.sh

# exit from next step, reboot to new system
umount -R /mnt

# reboot or do something else, the decision is yours
exit
