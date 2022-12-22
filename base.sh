#!/bin/bash

ask() {
    ask_string="$2Continue? <$1> [s=skip]"
    read -p $ask_string ask

    if [[ -z $ask || $ask == 'y' ]]; then
        $1
        # out="$($1)"
        # echo $out
    elif [[ $ask == 's' ]]; then
        echo "Skipping <$1>"
        # sleep $sleep_interval
    else
        echo 'Exiting program'
        exit
    fi
}

backup_dir="$HOME/backup"

backup() {
    [[ ! -d $backup_dir ]] && mkdir -p $backup_dir
    if [[ -d "$1" ]]; then
        res_dirname="$backup_dir/$(dirname $1)"
        mkdir -p $res_dirname
        echo "Backing up $1 to $res_dirname"
        cp -r $1 $res_dirname
    fi
}
