#!/bin/bash

cd $(dirname $0)
source "./base.sh"

setup_script_location="scripts/"
base_list_path="./pkg-lists/base"
extra_list_path="./pkg-lists/extra"

tmp_extra_to_install="./pkg-lists/extra-$(date +'%Y%m%d_%H%M%S')"

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
        sleep 1
    else
        echo "--- Skipped ---"
    fi
}



install_base() {
    install_needed $(cat $base_list_path)
}

install_extra() {
    touch $tmp_extra_to_install
    while IFS= read -r line; do
        if [[ -n $line ]]; then
            echo -n "Install [$line] [y=yes]?"
            read -N 1 ask </dev/tty
            echo

            if [[ $ask == 'y' ]]; then
                echo "$line" >> "$tmp_extra_to_install"
            fi
        fi
    done < $extra_list_path

    echo Result list:
    cat $tmp_extra_to_install
    echo

    install_needed $(cat $tmp_extra_to_install)
    rm $tmp_extra_to_install
}

main() {
    d=$(distro_determine)

    if [[ -n $is_noconfirm ]]; then
        echo "You are entering NO_CONFIRM mode. Are you sure?"
        echo "It means that you won't be prompted for any interaction, and all sections will be applied"
        sleep 5
        echo -n "Write 'yes', if you know what are you doing: [yes/no] "

        read ask </dev/tty
        [[ $ask != "yes" ]] && exit;
    fi


    if [[ ! $(command -v yay) ]]; then
        ask yay_setup
    fi

    # ask install_base
    ask install_extra
}

main
