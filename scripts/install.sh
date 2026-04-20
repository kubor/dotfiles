#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOTFILES_ROOT=$(dirname "$SCRIPT_DIR")

echo "make symbolic links to $HOME"
ln -sf "${DOTFILES_ROOT}/config/bash/.bash_profile" ~/.bash_profile
ln -sf "${DOTFILES_ROOT}/config/vim/.vimrc" ~/.vimrc
ln -sf "${DOTFILES_ROOT}/config/zsh/.zshrc" ~/.zshrc
ln -sf "${DOTFILES_ROOT}/config/zimfw/.zimrc" ~/.zimrc

config_dir="$HOME/.config"
if [ ! -e "$config_dir" ]; then
    mkdir -p "${config_dir}"
fi

# neovim config
ln -snf "${DOTFILES_ROOT}/config/nvim" "${config_dir}/nvim"

# alacritty config
alacritty_dir="${config_dir}/alacritty"
if [ ! -e "$alacritty_dir" ]; then
    mkdir -p "${alacritty_dir}"
fi
ln -sf "${DOTFILES_ROOT}/config/alacritty/alacritty.toml" "${alacritty_dir}/alacritty.toml"
ln -sf "${DOTFILES_ROOT}/config/alacritty/dracula.toml" "${alacritty_dir}/dracula.toml"

# ghostty config
ghostty_dir="${config_dir}/ghostty"
if [ ! -e "$ghostty_dir" ]; then
    mkdir -p "${ghostty_dir}"
fi
ln -sf "${DOTFILES_ROOT}/config/ghostty/config" "${ghostty_dir}/config"

# git config
ln -sf "${DOTFILES_ROOT}/config/git/.gitconfig" ~/.gitconfig
ln -sf "${DOTFILES_ROOT}/config/git/.gitignore_global" ~/.gitignore_global

# zsh modular config
zsh_dir="${config_dir}/zsh"
if [ ! -e "$zsh_dir" ]; then
    mkdir -p "${zsh_dir}"
fi
ln -sf "${DOTFILES_ROOT}/config/zsh/options.zsh" "${zsh_dir}/options.zsh"
ln -sf "${DOTFILES_ROOT}/config/zsh/path.zsh" "${zsh_dir}/path.zsh"
ln -sf "${DOTFILES_ROOT}/config/zsh/aliases.zsh" "${zsh_dir}/aliases.zsh"
ln -sf "${DOTFILES_ROOT}/config/zsh/functions.zsh" "${zsh_dir}/functions.zsh"

# claude code config
claude_dir="$HOME/.claude"
if [ ! -e "$claude_dir" ]; then
    mkdir -p "${claude_dir}"
fi
ln -sf "${DOTFILES_ROOT}/config/claude-code/settings.json" "${claude_dir}/settings.json"

# mise config
mise_dir="${config_dir}/mise"
if [ ! -e "$mise_dir" ]; then
    mkdir -p "${mise_dir}"
fi
ln -sf "${DOTFILES_ROOT}/config/mise/mise.toml" "${mise_dir}/config.toml"

# starship config
ln -sf "${DOTFILES_ROOT}/config/starship/starship.toml" ~/.config/starship.toml

# vscode config
vscode_dir="$HOME/Library/Application Support/Code/User"
if [ ! -e "$vscode_dir" ]; then
    mkdir -p "$vscode_dir"
fi
ln -sf "${DOTFILES_ROOT}/config/vscode/settings.json" "$vscode_dir/settings.json"
ln -sf "${DOTFILES_ROOT}/config/vscode/keybindings.json" "$vscode_dir/keybindings.json"
ln -sf "${DOTFILES_ROOT}/config/vscode/extensions.json" "$vscode_dir/extensions.json"

# run mise installation
if [ -f "${SCRIPT_DIR}/install_mise.sh" ]; then
    echo "Installing mise..."
    bash "${SCRIPT_DIR}/install_mise.sh"
fi

# run all common scripts
for script in "${SCRIPT_DIR}"/common/*.sh; do
    if [ -f "$script" ]; then
        echo "Running $(basename "$script")..."
        bash "$script"
    fi
done

# run all config scripts
for script in "${SCRIPT_DIR}"/config/*.sh; do
    if [ -f "$script" ]; then
        echo "Running $(basename "$script")..."
        bash "$script"
    fi
done

# run macOS specific scripts
if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "Detected macOS. Running macOS-specific setup..."
    for script in "${SCRIPT_DIR}"/macos/*.sh; do
        if [ -f "$script" ]; then
            echo "Running $(basename "$script")..."
            bash "$script"
        fi
    done
fi
