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
    echo "clone vim/vim repository"
    git clone https://github.com/vim/vim.git && cd vim
else
    echo "pull vim/vim"
    cd vim
    git pull
fi

make clean

./configure \
    --prefix=$HOME \
    --enable-multibyte \
    --with-features=huge \
    --enable-luainterp \
    --enable-perlinterp \
    --enable-pythoninterp=dynamic \
    --enable-python3interp=dynamic \
    --enable-rubyinterp \
    --disable-gui \
    --enable-fontset \
    &&

make; make install

if [ -n "$HOME/.vim/dein" ]; then
    mkdir -p ~/.vim/dein/repos/github.com/Shougo/dein.vim
fi

git clone https://github.com/Shougo/dein.vim \
    ~/.vim/dein/repos/github.com/Shougo/dein.vim

echo "done."
