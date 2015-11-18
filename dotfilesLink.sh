#!/bin/bash
echo "make symbolic links to $HOME"
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.peco.snippet.bioinfo ~/.peco.snippet.bioinfo
# sync git submodule(for vim-neocomplete)
git submodule init
git submodule update
