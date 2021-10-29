yay -S --needed qemu virt-manager libvirt dnsmasq ebtables bridge-utils

enable="sudo systemctl enable --now"

eval $enable "dnsmasq.service"
eval $enable "libvirtd.service"
eval $enable "ebtables.service"
