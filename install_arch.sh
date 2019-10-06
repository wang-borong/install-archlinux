#install archlinux


# dump log while installing
# all the scripts should be put in a same directory
bash ./basestrap.sh | tee /root/install_archlinux.log

if [[ $? > 0 ]]; then
    exit 1
else
    echo ""
    echo "Congratulations!"
    echo "archiso : log is dumped in /root/install.log"
    echo ""
fi
