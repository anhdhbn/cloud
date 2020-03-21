SWAP_FOLDER="/swapfile"
if grep -Fxq $SWAP_FOLDER /etc/fstab
then
    echo "swaped"
else
    sudo fallocate -l 4G $SWAP_FOLDER
    sudo chmod 600 $SWAP_FOLDER
    sudo mkswap $SWAP_FOLDER
    sudo swapon $SWAP_FOLDER
    echo "$SWAP_FOLDER none swap sw 0 0" | sudo tee -a /etc/fstab
    sudo reboot
fi