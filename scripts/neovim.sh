#!/bin/bash

cd $(dirname $0)
source "./base.sh"



neovim_base() {
    [[ $(command -v pacman) ]] && $pacman_install neovim

    curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    for f in .vimrc
    do
        backup "$HOME/$f"
        curl https://raw.githubusercontent.com/tsepanx/dotfiles/master/$f -o $HOME/$f
    done

    mkdir -p $HOME/.config/nvim

    nvimrc=$HOME/.config/nvim/init.vim
    backup $nvimrc
    rm $nvimrc

    ln -s $HOME/.vimrc $HOME/.config/nvim/init.vim

    nvim +PlugInstall +qall
}

ask neovim_base "This will override your current setup at: $HOME/{.vimrc}\n"
