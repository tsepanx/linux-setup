#!/bin/bash

cd $(dirname $0)
source "./base.sh"

sleep_interval=1
pacman_install="sudo pacman -S --needed"

repo_name="linux-setup"
repo_url="https://github.com/tsepanx/$repo_name"

dotfiles_url="https://github.com/tsepanx/dotfiles"
dotfiles_dir="$HOME/.dotfiles"

distro_determine() {
    s=$(cat /etc/*-release) 
    arch_s="$(echo $s | grep 'Arch Linux')"

    if [[ -n $arch_s ]]; then
        echo archlinux
    fi
}

scripts_repo_setup() {
    if [[ ! -d "scripts" ]]; then
        git clone $repo_url ./$repo_name
        echo "Entrying the same script with repo: $repo_url"
        sleep $sleep_interval

        cd $repo_name
        bash setup.sh
        exit
    fi
}

yay_setup() {
    echo 'Installing yay'
    $pacman_install base-devel
    curl -L git.io/yay.sh | sh
}

#yay_update() {
#    #TODO
#    # yay -Syu
#}

dots_setup() {
    $pacman_install git
    if [[ ! -d $dotfiles_dir ]]; then
        git clone --bare $dotfiles_url $dotfiles_dir
    fi
    dotfiles="git --git-dir=$dotfiles_dir --work-tree=$HOME"
    $dotfiles config status.showUntrackedFiles no

    git_restore() { $dotfiles restore $HOME/. ; }
    ask git_restore
}

zsh_setup() {
    bash "./scripts/zsh.sh"
}

vim_setup() {
    bash "./scripts/neovim.sh"
}

archlinux_setup() {
    ask yay_setup
    ask yay_update
}

base() {
    scripts_repo_setup

    d=$(distro_determine)

    if [[ -n $d ]]; then
        ask "$(echo $d)_setup"
    else
        echo 'Distro not allowed :('
        exit
    fi

    ask dots_setup
    ask zsh_setup
    ask vim_setup
}

ask base
