#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOTFILES_ROOT=$(dirname "$SCRIPT_DIR")

echo "make symbolic links to $HOME"
ln -sf ${DOTFILES_ROOT}/config/vim/.vimrc ~/.vimrc
ln -sf ${DOTFILES_ROOT}/config/zsh/.zshrc ~/.zshrc

rc_dir="$HOME/.vim/rc"
if [ ! -e $rc_dir ]; then
    mkdir -p "${rc_dir}"
fi

ln -sf ${DOTFILES_ROOT}/config/vim/rc/dein.toml ${rc_dir}/dein.toml
ln -sf ${DOTFILES_ROOT}/config/vim/rc/dein_lazy.toml ${rc_dir}/dein_lazy.toml

config_dir="$HOME/.config"
if [ ! -e $config_dir ]; then
    mkdir -p "${config_dir}"
fi

# alacritty config
alacritty_dir="${config_dir}/alacritty"
if [ ! -e $alacritty_dir ]; then
    mkdir -p "${alacritty_dir}"
fi
ln -sf ${DOTFILES_ROOT}/config/alacritty/alacritty.toml ${alacritty_dir}/alacritty.toml
ln -sf ${DOTFILES_ROOT}/config/alacritty/dracula.toml ${alacritty_dir}/dracula.toml

# ptpython config
ptpython_dir="${config_dir}/ptpython"
if [ ! -e $ptpython_dir ]; then
    mkdir -p "${ptpython_dir}"
fi
ln -sf ${DOTFILES_ROOT}/config/ptpython/config.py ${ptpython_dir}/config.py

# claude code config
claude_dir="$HOME/.claude"
if [ ! -e $claude_dir ]; then
    mkdir -p "${claude_dir}"
fi
ln -sf ${DOTFILES_ROOT}/config/claude-code/settings.json ${claude_dir}/settings.json

# mise config
mise_dir="${config_dir}/mise"
if [ ! -e $mise_dir ]; then
    mkdir -p "${mise_dir}"
fi
ln -sf ${DOTFILES_ROOT}/config/mise/mise.toml ${mise_dir}/config.toml

# starship config
ln -sf ${DOTFILES_ROOT}/config/starship/starship.toml ~/.config/starship.toml

# tmux config
echo "Install tmux..."
ln -sf ${DOTFILES_ROOT}/config/tmux/.tmux.conf ~/.tmux.conf
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# run mise installation
if [ -f "${SCRIPT_DIR}/install_mise.sh" ]; then
    echo "Installing mise..."
    bash "${SCRIPT_DIR}/install_mise.sh"
fi

# run all common scripts
for script in ${SCRIPT_DIR}/common/*.sh; do
    if [ -f "$script" ]; then
        echo "Running $(basename "$script")..."
        bash "$script"
    fi
done

# run all config scripts
for script in ${SCRIPT_DIR}/config/*.sh; do
    if [ -f "$script" ]; then
        echo "Running $(basename "$script")..."
        bash "$script"
    fi
done

# run macOS specific scripts
if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "Detected macOS. Running macOS-specific setup..."
    for script in ${SCRIPT_DIR}/macos/*.sh; do
        if [ -f "$script" ]; then
            echo "Running $(basename "$script")..."
            bash "$script"
        fi
    done
fi
