# yay -S --needed --noconfirm zsh zsh-syntax-highlighting zsh-autosuggestions 

cd $(dirname $0)
source "./base.sh"


zsh_base () {
    [[ $(command -v pacman) ]] && $pacman_install zsh

    dir="$HOME/.zsh"
    backup $dir
    rm -rf $dir

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

ask zsh_base "This will override your current setup at: $HOME/{.zsh/,.zshrc,.alias_bash,.alias_zsh,.vars}\n"
