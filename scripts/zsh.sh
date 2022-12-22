# yay -S --needed --noconfirm zsh zsh-syntax-highlighting zsh-autosuggestions 
[[ $(command -v pacman) ]] && sudo pacman -S --needed --noconfirm zsh
[[ $(command -v apt) ]] && sudo apt install -y zsh

cd $HOME

mv -i .zshrc .zshrc-backup
mv -i .zsh .zsh-backup

if [[ ! -d "$HOME/.zsh" ]]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.zsh
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.zsh/custom}/plugins/zsh-autosuggestions
fi

for f in .zshrc .alias_bash .alias_zsh .vars
do
    if [[ ! -f $f ]]
        curl https://raw.githubusercontent.com/tsepanx/dotfiles/master/$f -o $HOME/$f
    fi
done

chsh -s /usr/bin/zsh
