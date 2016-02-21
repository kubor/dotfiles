#!/bin/bash
echo "make symbolic links to $HOME"
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.peco.snippet.bioinfo ~/.peco.snippet.bioinfo
# for neovim config
if [ ! -e "${HOME}/.config/nvim" ]; then
    echo "mkdir -p ${HOME}/.config/nvim"
    mkdir -p "${HOME}/.config/nvim"
fi
ln -sf ~/dotfiles/.vimrc ~/.config/nvim/init.vim
ln -sf ~/dotfiles/.vim ~/.config/nvim/
# sync git submodule(for vim-neocomplete)
git submodule init
git submodule update
