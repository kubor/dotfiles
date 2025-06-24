#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOTFILES_ROOT=$(dirname "$(dirname "$SCRIPT_DIR")")

function check_macos() {
    if [[ "$(uname -s)" != "Darwin" ]]; then
        echo "This script is for macOS only. Skipping Homebrew installation."
        exit 0
    fi
}

function install_homebrew() {
    echo "Checking Homebrew installation..."
    
    if command -v brew &> /dev/null; then
        echo "Homebrew is already installed"
        brew --version
        return 0
    fi
    
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for current session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    echo "Homebrew installation completed"
    brew --version
}

function setup_brewfile() {
    echo "Setting up Brewfile..."
    
    # Create symbolic link for Brewfile
    if [[ -f "${DOTFILES_ROOT}/config/homebrew/Brewfile" ]]; then
        ln -sf "${DOTFILES_ROOT}/config/homebrew/Brewfile" ~/.Brewfile
        echo "Created symbolic link for Brewfile"
    else
        echo "Error: Brewfile not found in config/homebrew/"
        return 1
    fi
}

function install_packages() {
    echo "Installing packages from Brewfile..."
    
    # Skip package installation in CI environment
    if [[ -n "${GITHUB_ACTIONS-}" ]] || [[ -n "${CI-}" ]]; then
        echo "Skipping package installation in CI environment"
        return 0
    fi
    
    # Install packages from Brewfile
    if command -v brew &> /dev/null; then
        if [[ -f ~/.Brewfile ]]; then
            brew bundle install --global
            echo "All packages installed successfully from Brewfile"
        else
            echo "Error: ~/.Brewfile not found"
            return 1
        fi
    else
        echo "Error: brew command not found"
        return 1
    fi
}

function cleanup_homebrew() {
    echo "Cleaning up Homebrew..."
    
    if command -v brew &> /dev/null; then
        brew cleanup
        brew doctor || true  # Don't fail if brew doctor finds issues
        echo "Homebrew cleanup completed"
    fi
}

function main() {
    echo "=== Setting up Homebrew (macOS only) ==="
    
    check_macos
    install_homebrew
    setup_brewfile
    install_packages
    cleanup_homebrew
    
    echo "Homebrew setup completed!"
    echo "Installed packages:"
    brew list --formula | head -10
    echo "..."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi