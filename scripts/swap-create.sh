sudo fallocate -l $1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo '/swapfile swap swap defaults 0 0' | sudo tee -a /etc/fstab

# write uuid & resume offset to grub
# write "resume" to mkinitcpio file

# echo -n 'UUID: '
# sudo findmnt -no SOURCE,UUID -T /swapfile | awk '{ print $2} '

# echo -n 'Offset: '
# sudo filefrag -v /swapfile | awk '{ if($1=="0:"){print $4} }' | awk -F. '{ print $1} '
