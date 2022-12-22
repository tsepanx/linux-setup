#!/bin/bash

sleep_interval=1
pacman_install="sudo pacman -S --needed --noconfirm"
no_backups="$([[ $1 == "-nb" ]] && echo 1)"

ask() {
    ask_string="${2}Continue? <$1> [s=skip]"
    echo -en "$ask_string"
    read ask
    # read -p "$ask_string" ask

    if [[ -z $ask || $ask == 'y' ]]; then
        $1
        # out="$($1)"
        # echo $out
    elif [[ $ask == 's' ]]; then
        echo -n "S"
        # sleep $sleep_interval
    else
        echo 'Exiting program'
        exit
    fi
}

backup_dir="$HOME/backup"

backup() {
    [[ ! -d $backup_dir ]] && mkdir -p $backup_dir

    res_dirname="$backup_dir$(dirname $1)"
    if [[ ! -d $res_dirname ]]; then
        mkdir -p $res_dirname
    fi

    echo "Backing up $1 to $res_dirname"
    sleep $sleep_interval
    cp -r $1 $res_dirname
}
