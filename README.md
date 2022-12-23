# linux-setup

Collection of scripts to automatically install and configure my favourite software.

### Quick start
Just directly pipe the main `setup.sh` script, and follow all steps.
```bash
curl https://raw.githubusercontent.com/tsepanx/linux-setup/master/scripts/curl.sh | bash
```

### Script interaction
A script will ask to continue on each `<section>`, responsible for a single util setup.
On waiting an answer from user, any other from `y` or empty input %%any other than `yes`, %%will be considered as section skip.

![[Pasted image 20221223025838.png|700]]

### Sections

#### Yay
Installs `yay`, using `git.io/yay.sh` script

#### My Dotfiles
git clones [my dotfiles repo](https://github.com/tsepanx/dotfiles) to `.dotfiles` as bare repository.

#### Zsh
- my shell-related config files.
    - `.bashrc`
    - `.zshrc`
    - `.alias_zsh`
    - `.alias_bash`
    - `.vars`
- `oh-my-zsh`, with plugins
    - `zsh-autosuggestions`
    - `zsh-syntax-highlighting`

#### Neovim
- my `.vimrc` config linked by `init.vim`
- Installs plugins

#### Ranger
- my config files
- plugins
    - `fzf_select`
    - `ranger_devicons`
    - `ranger-zoxide`


