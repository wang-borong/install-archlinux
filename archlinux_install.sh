#install archlinux


# dump log while installation
echo "log is dumped in /root/install_archlinux.log"
echo ""

/run/archiso/bootmnt/archlinux_ins1.sh | tee /root/install_archlinux.log
