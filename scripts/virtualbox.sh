sudo pacman -S --needed virtualbox virtualbox-host-modules-arch linux-headers linux-lts-headers

sudo gpasswd -a $USER vboxusers

sudo modprobe vboxnetflt
sudo modprobe vboxnetadp
