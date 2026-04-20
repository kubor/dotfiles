# Conditional aliases (command substitution - not suitable for abbreviations)
if type ccat > /dev/null 2>&1; then
    alias cat="ccat"
fi
if type htop > /dev/null 2>&1; then
    alias top="htop"
fi

# Global aliases (zsh-abbr does not support global aliases)
alias -g L="| less"
alias -g G="| grep"
alias -g W="| wc"

# Import server-specific alias settings
if [ -f ~/.zshrc.alias ]; then
    source ~/.zshrc.alias
fi
