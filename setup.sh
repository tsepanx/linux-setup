#!/bin/bash

cd $(dirname $0)
source "./base.sh" $@

args=$@

backup_dir="$HOME/backup"
pkg_install_file="./pkg-install.sh"

dotfiles_url="git@github.com:tsepanx/dotfiles"
dotfiles_dir="$HOME/.dotfiles"


backup() {
    install_needed rsync

    [[ ! -d $backup_dir ]] && mkdir -p $backup_dir

    res_dirname="$backup_dir$(dirname $1)"
    if [[ ! -d $res_dirname ]]; then
        mkdir -p $res_dirname
    fi

    echo "Backing up $1 to $res_dirname"
    sleep $sleep_interval

    rsync -rv --exclude=.git/ $1 $res_dirname
}

distro_determine() {
    s=$(cat /etc/*-release) 
    arch_s="$(echo $s | grep 'Arch Linux')"

    if [[ -n $arch_s ]]; then
        echo archlinux
    fi
}

packages_install () {
    bash $pkg_install_file $args
}

dotfiles_setup () {
    install_needed git

    if [[ -d $dotfiles_dir ]]; then
        backup $dotfiles_dir
        rm -rf $dotfiles_dir
    fi

    git clone --bare $dotfiles_url $dotfiles_dir

    dotfiles="git --git-dir=$dotfiles_dir --work-tree=$HOME"
    $dotfiles config status.showUntrackedFiles no
    $dotfiles restore --staged $HOME/.
}

zsh_setup () {
    install_needed zsh

    dir="$HOME/.zsh"
    backup $dir
    rm -rf $dir

    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.zsh
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.zsh/custom}/plugins/zsh-autosuggestions

    for f in .bashrc .zshrc .alias_bash .alias_zsh .vars
    do
        backup "$HOME/$f"
        curl https://raw.githubusercontent.com/tsepanx/dotfiles/master/$f -o $HOME/$f
    done

    chsh -s /usr/bin/zsh
}


neovim_setup() {
    install_needed neovim

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


ranger_setup() {
    dir=".config/ranger"

    backup $HOME/$dir
    rm -rf $HOME/$dir

    mkdir -p $HOME/$dir/plugins

    git clone https://github.com/alexanderjeurissen/ranger_devicons $HOME/$dir/plugins/ranger_devicons
    git clone https://github.com/jchook/ranger-zoxide $HOME/$dir/plugins/zoxide

    for f in $dir/rc.conf $dir/commands.py
    do
        curl https://raw.githubusercontent.com/tsepanx/dotfiles/master/$f -o $HOME/$f
    done
}


main() {
    d=$(distro_determine)

    if [[ -n $is_noconfirm ]]; then
        noconfirm_attempt
    fi


    if [[ ! $(command -v yay) ]]; then
        ask_section yay_setup
    fi

    ask_section packages_install

    prefix="\nThis will override your current setup at:"
    ask_section dotfiles_setup "$prefix $dotfiles_dir\n"
    ask_section zsh_setup      "$prefix $HOME/{.zsh/,.zshrc,.alias_bash,.alias_zsh,.vars}\n"
    ask_section neovim_setup   "$prefix $HOME/{.vimrc}\n"
    ask_section ranger_setup   "$prefix $HOME/.config{plugins/,rc.conf,commands.py}\n"
}

main
