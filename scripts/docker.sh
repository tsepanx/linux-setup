yay -S --needed --noconfirm docker

sudo groupadd docker
sudo gpasswd -a $(whoami) docker

sudo systemctl enable --now docker.service
