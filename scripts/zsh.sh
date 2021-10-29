# yay -S --needed --noconfirm zsh zsh-syntax-highlighting zsh-autosuggestions 
yay -S --needed --noconfirm zsh

mv .zshrc .zshrc-backup
mv .zsh .zsh-backup

git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.zsh/custom}/plugins/zsh-autosuggestions

# TODO zshrc

chsh -s /usr/bin/zsh
