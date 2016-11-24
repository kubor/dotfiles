#!/bin/bash
CWD=`dirname $0`

echo "make symbolic links to $HOME"
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.peco.snippet.bioinfo ~/.peco.snippet.bioinfo

rc_dir="$HOME/.vim/rc"
if [ ! -e $rc_dir ]; then
    mkdir -p "${rc_dir}"
fi

ln -sf ~/dotfiles/rc/dein.toml ~/.vim/rc/dein.toml

# for neovim config
if [ ! -e "${HOME}/.config/nvim" ]; then
    echo "mkdir -p ${HOME}/.config/nvim"
    mkdir -p "${HOME}/.config/nvim"
fi

ln -sf ~/dotfiles/.vimrc ~/.config/nvim/init.vim
ln -sf ~/dotfiles/.vim ~/.config/nvim/

# git-config
sh ${CWD}/set_git_config.sh

# ptpython config
sh ${CWD}/install_ptpython_config.sh

# install zplug
curl -sL get.zplug.sh | zsh
