#!/bin/bash


cd $(dirname $0)

sleep_interval=1

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

    $cmd -Sy --needed $@
}

ask() {
    echo $1 | ./pretty-title.py

    ask_string="${2}<$1> Continue? [y/<blank>=cont] "

    if [[ -n $is_noconfirm ]]; then
        $1
        sleep 1
        return
    fi

    echo -en "$ask_string"
    read ask </dev/tty

    if [[ -z $ask || $ask == 'y' ]]; then
    # if [[ $ask == 'yes' ]]; then
        $1
        sleep $sleep_interval
    else
        echo "--- Skipped ---"
    fi
}
