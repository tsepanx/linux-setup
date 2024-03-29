#!/bin/bash

cd "$(dirname "$0")" || exit

sleep_interval=0.5

# Go through every sectoin without interaction
is_noconfirm="$([[ $1 == "-y" ]] && echo 1)"

yay_setup() {
    echo 'Installing yay'
    # install_needed base-devel
    curl -L git.io/yay.sh | sh
}

install_needed() {
    if [[ $(command -v yay) ]]; then
        cmd=yay
    else
        cmd=pacman
    fi

    $cmd -Sy --needed "$@"
}

rstr="[y/<blank> = yes] "

ask() {
    echo -en "$2 $rstr"
    read -n 1 ask </dev/tty
    echo

    if [[ -z $ask || $ask == 'y' ]]; then
        $1
    fi
}

ask_section() {
    echo $1 | ./pretty-title.py

    ask_string="${2}\nSecion <$1> Continue? $rstr"

    if [[ -n $is_noconfirm ]]; then
        $1
        sleep $sleep_interval
        return
    fi

    echo -en "$ask_string"
    read -n 1 ask </dev/tty
    echo

    if [[ -z $ask || $ask == 'y' ]]; then
        $1
    else
        echo -e "\n--- Skipped ---\n"
    fi
    sleep $sleep_interval
}

noconfirm_attempt() {
    echo "You are entering NO_CONFIRM mode. Are you sure?"
    echo "It means that you won't be prompted for any interaction, and all sections will be applied"
    sleep 5
    echo -n "Write 'yes', if you know what are you doing: [yes/no] "

    read ask </dev/tty
    [[ $ask != "yes" ]] && exit;
}
