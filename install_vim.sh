#!/bin/bash
#
# file: install_vim
# desc: fetch github vim repository and
#       install Vim with below configure options
#           --prefix=$HOME
#           --enable-multibyte
#           --with-features=huge
#           --enable-python-interp
#           --enable-luainterp
#           --enable-perlinterp
#           --enable-pythoninterp
#           --enable-python3interp
#           --enable-rubyinterp
#           --with-python-config-dir=/usr/lib64/python2.6/config
#           --disable-gui
#           --enable-fontset
#

echo "Install VIM from github online repository vim/vim."
if [ -d "$HOME/src" ]; then
    cd "$HOME/src"
else
    echo "Not found [ $HOME/src ]"
    exit 1
fi
pwd

if [ ! -d "${HOME}/src/vim" ]; then
    git clone https://github.com/vim/vim.git && cd vim
else
    cd vim
    git pull
fi

./configure \
    --prefix=$HOME \
    --enable-multibyte \
    --with-features=huge \
    --enable-python-interp \
    --enable-luainterp \
    --enable-perlinterp \
    --enable-pythoninterp \
    --enable-python3interp \
    --with-python-config-dir=${HOME}/.pyenv/shims \
    --enable-rubyinterp \
    --disable-gui \
    --enable-fontset \
    &&

make; make install

if [ -n "$HOME/.vim/dein" ]; then
    mkdir -p ~/.vim/dein/repos/github.com/Shougo/dein.vim
fi

git clone https://github.com/Shougo/dein.vim.git \
    ~/.vim/dein/repos/github.com/Shougo/dein.vim

echo "please check your PATH ordar."
echo "recommended settings:"
echo "   zsh; echo \"PATH=\$HOME/bin:\$PATH\" >> ~/.zshrc"
echo "  bash; echo \"PATH=\$HOME/bin:\$PATH\" >> ~/.bashrc"
echo "done."
