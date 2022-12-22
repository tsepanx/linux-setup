#!/bin/bash

cd $(dirname $0)

sleep_interval=1

fname1="./list-dotfiles"
git_dir1="$HOME/.dotfiles/"
git_url1='https://github.com/tsepanx/dotfiles'

fname2="./list-dotfiles-private"
git_dir2="$HOME/.dotfiles-private/"
git_url2='https://github.com/tsepanx/dotfiles-private'

git_add_from_list() {
    filename=$1
    git_dir=$2
    git_url=$3
    if [[ ! -d $git_dir ]]; then
        echo "Dotfiles dir ($git_dir) doesnt't exist, cloning..."
        git clone --bare $git_url $git_dir
    else
        echo "Dotfiles dir ($git_dir) exists, skipping git clone"
        sleep $sleep_interval
    fi


    while IFS= read -r line; do
        echo "$filename: git add $line"
        git --git-dir=$git_dir --work-tree=$HOME add "$HOME/$line"
    done < "$filename"
}

git_add_from_list $fname1 $git_dir1 $git_url1
# git_add_from_list $fname2 $git_dir2 $git_url2

