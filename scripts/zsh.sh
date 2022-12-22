# yay -S --needed --noconfirm zsh zsh-syntax-highlighting zsh-autosuggestions 
[[ $(command -v pacman) ]] && sudo pacman -S --needed --noconfirm zsh
[[ $(command -v apt) ]] && sudo apt install -y zsh

source "../base.sh"
ask base "This will override your current setup at: $HOME/{.zsh/,.zshrc,.alias_bash,.alias_zsh,.vars}\n"

base () {
    backup "$HOME/.zsh"

    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.zsh
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.zsh/custom}/plugins/zsh-autosuggestions

    for f in .zshrc .alias_bash .alias_zsh .vars
    do
        backup "$HOME/$f"
        curl https://raw.githubusercontent.com/tsepanx/dotfiles/master/$f -o $HOME/$f
    done

    chsh -s /usr/bin/zsh
}

base
