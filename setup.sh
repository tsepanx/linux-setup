#!/bin/bash

cd $(dirname $0)
# source "./base.sh"

sleep_interval=1

# no_backups="$([[ $1 == "-nb" ]] && echo 1)"
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
    ask_string="${2}Continue? <$1> [s=skip]"
    echo -en "$ask_string"
    read ask </dev/tty

    if [[ -z $ask || $ask == 'y' ]]; then
        $1
    elif [[ $ask == 's' ]]; then
        echo Skipped
        # sleep $sleep_interval
    else
        echo 'Exiting program'
        exit
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

scripts_repo_resetup() {
    if [[ ! -f "./base.sh" ]]; then
        new_dir="$HOME/${repo_name}_$(date +'%Y%m%d_%H%M%S')"
        git clone $repo_url $new_dir
        echo "Entrying the same script with repo: $new_dir"
        sleep $sleep_interval

        cd $new_dir/$setup_script_location
        bash setup.sh
        exit
    fi
}

yay_setup() {
    echo 'Installing yay'
    install_needed base-devel
    curl -L git.io/yay.sh | sh
}

dotfiles_base () {
    install_needed git
    if [[ ! -d $dotfiles_dir ]]; then
        git clone --bare $dotfiles_url $dotfiles_dir
    fi
    dotfiles="git --git-dir=$dotfiles_dir --work-tree=$HOME"
    $dotfiles config status.showUntrackedFiles no

    git_restore() { $dotfiles restore --staged $HOME/. ; }
    ask git_restore
}

zsh_base () {
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


neovim_base() {
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


ranger_base() {
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


archlinux_setup() {
    if [[ ! $(command -v pacman) ]]; then
        ask yay_setup
    fi
}

base() {
    # scripts_repo_resetup

    d=$(distro_determine)

    if [[ -n $d ]]; then
        ask "$(echo $d)_setup"
    else
        echo 'Distro not allowed :('
        exit
    fi

    prefix="\nThis will override your current setup at:"
    ask dotfiles_base "$prefix $dotfiles_dir\n"
    ask zsh_base      "$prefix $HOME/{.zsh/,.zshrc,.alias_bash,.alias_zsh,.vars}\n"
    ask neovim_base   "$prefix $HOME/{.vimrc}\n"
    ask ranger_base   "$prefix $HOME/.config{plugins/,rc.conf,commands.py}\n"
}

base
