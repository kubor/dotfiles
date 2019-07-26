#!/bin/bash

if [ ! -e ~/.ptpython ]; then
    mkdir -p ~/.ptpython
fi

cp -f ~/dotfiles/.ptpython/config.py ~/.ptpython/
