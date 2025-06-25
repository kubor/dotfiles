#!/usr/bin/env bash

set -Eeuo pipefail

function install_mise() {
    echo "Installing mise..."
    
    # Check if mise is already installed
    if command -v mise &> /dev/null; then
        echo "mise is already installed"
        mise --version
        return 0
    fi
    
    # Install mise
    curl https://mise.run | sh
    
    # Add mise to PATH for current session
    export PATH="$HOME/.local/bin:$PATH"
    
    echo "mise installation completed"
    mise --version
}

function setup_mise_config() {
    echo "Setting up mise configuration..."
    
    # Create mise config directory
    mkdir -p ~/.config/mise
    
    # Create symbolic link for mise config
    if [ -f "config/mise/mise.toml" ]; then
        ln -sf "$(pwd)/config/mise/mise.toml" ~/.config/mise/config.toml
        echo "Created symbolic link for mise config"
    else
        echo "Error: mise.toml not found in config/mise/"
        return 1
    fi
}

function install_mise_tools() {
    echo "Installing mise tools..."
    
    # Skip tool installation in CI environment
    if [ -n "${GITHUB_ACTIONS-}" ] || [ -n "${CI-}" ]; then
        echo "Skipping mise tool installation in CI environment"
        return 0
    fi
    
    # Install tools defined in mise.toml
    if command -v mise &> /dev/null; then
        mise install -y
        echo "All mise tools installed successfully"
    else
        echo "Error: mise not found in PATH"
        return 1
    fi
}

function main() {
    echo "=== Setting up mise ==="
    
    # Check if mise is already installed and configured
    if command -v mise &> /dev/null && [ -f ~/.config/mise/config.toml ]; then
        echo "mise is already installed and configured"
        mise --version
        echo "Skipping mise installation and configuration"
        echo "To reinstall, remove ~/.config/mise/config.toml or uninstall mise"
        return 0
    fi
    
    install_mise
    setup_mise_config
    install_mise_tools
    
    echo "mise setup completed!"
    echo "Please restart your shell or run: source ~/.zshrc"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi