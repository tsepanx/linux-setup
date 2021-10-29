# yay -S --needed --noconfirm zsh zsh-syntax-highlighting zsh-autosuggestions 
yay -S --needed --noconfirm zsh

mv -i .zshrc .zshrc-backup
mv -i .zsh .zsh-backup

git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.zsh/custom}/plugins/zsh-autosuggestions

curl https://raw.githubusercontent.com/tsepanx/linux-setup/master/zshrc -o $HOME/.zshrc

chsh -s /usr/bin/zsh
