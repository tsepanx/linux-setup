#! /bin/bash


install_pkg="yay -S"

distro_determine() {
    d=$(cat /etc/*-release) 
    arch_d="$(echo $d | grep 'Arch Linux')"

    if [[ -n $arch_d ]]; then
        echo archlinux
    fi
    # install_pkg="sudo pacman -
}

ask() {
    read -p "Continue? <$1> " ask

    if [[ -z $ask || $ask == 'y' ]]; then
        $1
    elif [[ $ask == 's' ]]; then
        echo 'Skipping part...'
        sleep 2
    else
        echo 'Exiting program'
        exit
    fi
}

yay_setup() {
    echo 'Installing yay'
    curl -L git.io/yay.sh | sh
}

pacman_update() { yay -Syu }

dots_setup() {
    #TODO
    echo 'Not implemented yet'
}

wm_setup() {
    #TODO
    echo 'Not implemented yet'
}

archlinux_setup() {
    ask yay_setup
    ask pacman_update
}

base() {
    echo 'Determining Distribution...'
    d=$(distro_determine)

    if [[ -n $d ]]; then
        ask "$(echo $d)_setup"
    else
        echo 'Bad distro'
        exit
    fi

    ask dots_setup
    ask wm_setup
}

ask base
