[[ $(command -v pacman) ]] && sudo pacman -S --noconfirm neovim
[[ $(command -v apt) ]] && sudo apt install -y neovim

curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

for f in .vimrc
do
    [[ ! -f $f ]] && curl https://raw.githubusercontent.com/tsepanx/dotfiles/master/$f -o $HOME/$f
done

mkdir -p $HOME/.config/nvim
if [[ ! -e $HOME/.config/nvim/init.vim ]]; then
    ln -s $HOME/.vimrc $HOME/.config/nvim/init.vim
fi

nvim +PlugInstall +qall
