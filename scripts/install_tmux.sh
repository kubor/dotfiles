#!/bin/bash

echo "Install tmux..."

ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
