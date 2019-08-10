#!/bin/bash
CWD=`dirname $0`

echo "make symbolic links to $HOME"
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.ideavimrc ~/.ideavimrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.peco.snippet.bioinfo ~/.peco.snippet.bioinfo

rc_dir="$HOME/.vim/rc"
if [ ! -e $rc_dir ]; then
    mkdir -p "${rc_dir}"
fi

ln -sf ~/dotfiles/rc/dein.toml ~/.vim/rc/dein.toml
ln -sf ~/dotfiles/rc/dein_lazy.toml ~/.vim/rc/dein_lazy.toml

config_dir="$HOME/.config"
if [ ! -e $config_dir ]; then
    mkdir -p "${config_dir}"
fi

ln -sf ~/dotfiles/.config/alacritty ${config_dir}/

# git-config
sh ${CWD}/set_git_config.sh

# ptpython config
sh ${CWD}/install_ptpython_config.sh

# install nvim python
pip3 install pynvim

# install tmux
bash ${CWD}/install_tmux.sh
