### archlinux_install
These scripts are used for installing archlinux.

#### usage
1. bootup from your u-disk.

2. wget https://github.com/stuha/install-archlinux/tarball/develop -O - | tar -xz

3. make partitions and formatting, then mount them.

4. cd \*install-archlinux\* && ./install_arch.sh

5. optionally, run xstrap.sh to install X window environment(Xfce4).

#### useful tips
You can use [aui](https://github.com/helmuthdu/aui)(advanced) to install archlinux.

get the script: wget https://github.com/helmuthdu/aui/tarball/master -O - | tar xz

FIFO [system base]: `cd <dir> && ./fifo`

LILO [the rest...]: `cd <dir> && ./lilo`
