#!/bin/bash

cd $(dirname $0)
# source "./base.sh"

sleep_interval=1

is_noconfirm="$([[ $1 == "-y" ]] && echo 1)"
backup_dir="$HOME/backup"

repo_name="linux-setup"
repo_url="https://github.com/tsepanx/$repo_name"
setup_script_location="scripts/"

# dotfiles_url="https://github.com/tsepanx/dotfiles"
dotfiles_url="git@github.com:tsepanx/dotfiles"
dotfiles_dir="$HOME/.dotfiles"

install_needed() {
    if [[ $(command -v pacman) ]]; then
        if [[ ! $(pacman -Q $1 2>/dev/null) ]]; then
            sudo pacman -S --needed --noconfirm $1
        fi
    fi
}

ask() {
    echo $1 | ./pretty-title.py

    ask_string="${2}<$1> Continue? [y/<blank>=cont] "

    [[ -n $is_noconfirm ]] && $1; return

    echo -en "$ask_string"
    read ask </dev/tty

    if [[ -z $ask || $ask == 'y' ]]; then
    # if [[ $ask == 'yes' ]]; then
        $1
        sleep 1
    else
        echo "--- Skipped ---"
    fi
}


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

yay_setup() {
    if [[ ! $(command -v yay) ]]; then
        echo 'Installing yay'
        install_needed setup-devel
        curl -L git.io/yay.sh | sh
    else
        echo 'Yay already installed'
        sleep 2
    fi
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

    for f in .zshrc .alias_bash .alias_zsh .vars
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


base() {
    d=$(distro_determine)

    if [[ -n $is_noconfirm ]]; then
        echo "You are entering NO_CONFIRM mode. Are you sure?"
        echo "It means that you won't be prompted for any interaction, and all sections will be applied"
        sleep 5
        echo -n "Write 'yes', if you know what are you doing: [yes/no] "

        read ask </dev/tty
        [[ $ask != "yes" ]] && exit;
    fi


    ask yay_setup

    prefix="\nThis will override your current setup at:"
    ask dotfiles_setup "$prefix $dotfiles_dir\n"
    ask zsh_setup      "$prefix $HOME/{.zsh/,.zshrc,.alias_bash,.alias_zsh,.vars}\n"
    ask neovim_setup   "$prefix $HOME/{.vimrc}\n"
    ask ranger_setup   "$prefix $HOME/.config{plugins/,rc.conf,commands.py}\n"
}

base
