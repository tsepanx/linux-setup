#!/bin/bash

dir=.config/ranger

for i in $HOME/$dir $HOM$/$dir/plugins; do
    if [[ ! -d $i ]]; then
        mkdir -p $i
    fi
done

git clone https://github.com/alexanderjeurissen/ranger_devicons $HOME/$dir/plugins/ranger_devicons
git clone https://github.com/jchook/ranger-zoxide $HOME/$dir/plugins/zoxide

for f in $dir/rc.conf $dir/commands.py
do
    [[ ! -f $f ]] && curl https://raw.githubusercontent.com/tsepanx/dotfiles/master/$f -o $HOME/$f
done
