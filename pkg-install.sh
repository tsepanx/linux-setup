#!/bin/bash

cd $(dirname $0)
source "./base.sh"

is_noconfirm="$([[ $1 == "-y" ]] && echo 1)"

pkg_dir="./pkg-lists"
base_file="./pkg-lists/base"
extra_file="./pkg-lists/extra"

tmpfile="./pkg-lists/list-$(date +'%Y%m%d_%H%M%S')"

install_needed() {
    if [[ $(command -v yay) ]]; then
        cmd=yay
    else
        cmd=pacman
    fi

    $cmd -Sy --needed $@
}

select_base() {
    echo "Entire $base_file file is included:"
    sleep $sleep_interval
    cat $base_file
    cat $base_file >> $tmpfile
}

select_extra() {
    touch $tmpfile
    while IFS= read -r line; do
        if [[ -n $line ]]; then
            add_line() { echo "$line" >> "$tmpfile" ; }
            ask "Include pkg: [$line]?" add_line
        fi
    done < $extra_file
}

select_other() {
    for f in $pkg_dir/*; do
        if [[ -f $f && $(basename $f) != "base" && $(basename $f) != "extra" ]]; then
            # echo $f
            concat_f() { cat "$f" >> "$tmpfile" ; }
            ask "Include file: [$f]?" concat_f
        fi
    done
}

install_selected() {
    install_needed $(cat $tmpfile)
}

main() {
    if [[ -n $is_noconfirm ]]; then
        noconfirm_attempt
    fi


    if [[ ! $(command -v yay) ]]; then
        ask_section yay_setup
    fi

    rm -v ${pkg_dir}/list-20*
    touch $tmpfile

    ask_section select_base
    ask_section select_extra
    ask_section select_other

    echo "Result list:"
    sleep $sleep_interval

    cat $tmpfile
    sleep $sleep_interval

    ask_section install_selected
    rm $tmpfile
}

main
