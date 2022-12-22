#!/bin/bash

cd $(dirname $0)
source "./base.sh"

main() {
    dir=".config/ranger"
    backup $HOME/$dir
    rm -rf $HOME/$dir

    # for i in $HOME/$dir $HOME/$dir/plugins; do
    #     if [[ ! -d $i ]]; then
    #         mkdir -p $i
    #     fi
    # done

    mkdir -p $HOME/$dir/plugins

    git clone https://github.com/alexanderjeurissen/ranger_devicons $HOME/$dir/plugins/ranger_devicons
    git clone https://github.com/jchook/ranger-zoxide $HOME/$dir/plugins/zoxide

    for f in $dir/rc.conf $dir/commands.py
    do
        curl https://raw.githubusercontent.com/tsepanx/dotfiles/master/$f -o $HOME/$f
    done
}

ask_string="This will override your current setup at: $HOME/.config{plugins/,rc.conf,commands.py}\n"
ask main "$ask_string"
