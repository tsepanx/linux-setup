#!/usr/bin/sh

export EDITOR="$(if ! command -v nvim &> /dev/null; then echo 'vim'; else echo 'nvim'; fi)"

export ZSH="$HOME/.zsh"
DISABLE_AUTO_UPDATE="true"

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
[[ ! -d $ZSH_CACHE_DIR ]] && mkdir $ZSH_CACHE_DIR

# ZSH_THEME="af-magic"
ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

source ~/.alias_bash
source ~/.alias_zsh


source ~/.vars
