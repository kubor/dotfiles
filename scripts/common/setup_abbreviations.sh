#!/bin/bash
set -Eeuo pipefail

# Setup zsh-abbr user abbreviations
# This script generates the abbreviation definitions file used by zsh-abbr.
# If the file already exists, it will not be overwritten to preserve user customizations.

ABBR_DIR="${HOME}/.config/zsh-abbr"
ABBR_FILE="${ABBR_DIR}/user-abbreviations"

if [ -f "${ABBR_FILE}" ]; then
    echo "zsh-abbr user-abbreviations already exists. Skipping setup."
    exit 0
fi

echo "Setting up zsh-abbr abbreviations..."
mkdir -p "${ABBR_DIR}"

cat > "${ABBR_FILE}" << 'EOF'
abbr vi="vim -u NONE --noplugin"
abbr awk="gawk"
abbr mv="mv -i"
abbr rm="rm -i"
abbr grep="grep --color=auto -i"
abbr zgrep="zgrep --color=auto -i"
abbr egrep="egrep --color=auto -i"
abbr src="source ~/.zshrc"
abbr ei="eza --icons --git"
abbr ea="eza -a --icons --git"
abbr ee="eza -aahl --icons --git"
abbr et="eza -T -L 3 -a -I 'node_modules|.git|.cache' --icons"
abbr eta="eza -T -a -I 'node_modules|.git|.cache' --color=always --icons | less -r"
abbr ls="eza --icons --git"
abbr la="eza -a --icons --git"
abbr ll="eza -aahl --icons --git"
abbr lt="eza -T -L 3 -a -I 'node_modules|.git|.cache' --icons"
abbr lta="eza -T -a -I 'node_modules|.git|.cache' --color=always --icons | less -r"
abbr l="clear && eza --icons --git"
abbr gst="git status -sb"
abbr gg="git status -sb"
abbr gm="git commit -m"
abbr gb="git branch -a"
abbr co="git checkout"
abbr j4="echo-sd 'DEMOCRACYYYYYYY!!!!!'; make -j 4"
abbr dr="docker run --rm -it"
abbr db="docker build"
EOF

echo "zsh-abbr abbreviations have been set up."
