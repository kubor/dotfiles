#!/bin/bash

echo "set Vim as Git editor"
git config --global core.editor 'vim -c "set fenc=utf-8"'

cat ${HOME}/.gitconfig
