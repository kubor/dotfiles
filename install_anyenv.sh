#!/bin/bash

git clone https://github.com/riywo/anyenv ~/.anyenv

if [ -n ~/.anyenv/plugins ]; then
    mkdir -p ~/.anyenv/plugins
fi

git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update

anyenv install -f rbenv
anyenv install -f plenv
anyenv install -f pyenv
anyenv install -f goenv

installed="installed anyenv"

if type cowsay >/dev/null 2>&1; then
    cowsay $installed
else
    cat $installed
fi

exec $SHELL -l
