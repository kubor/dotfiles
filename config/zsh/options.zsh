# Zsh options and history configuration

# LANG
export LANG=ja_JP.UTF-8
export EDITOR="nvim"
export TERM="xterm-256color"

# Prevent Homebrew from installing tools managed by mise
export HOMEBREW_FORBIDDEN_FORMULAE="node bat eza peco"

# History
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt hist_no_store        # Remove history (fc -l) command from history
setopt inc_append_history   # Immediately append to history file
setopt hist_ignore_dups     # Don't add the same command as previous
setopt extended_history     # Write start and end times to history
setopt hist_verify          # Edit history before executing
setopt share_history        # Share history across sessions
setopt hist_ignore_space    # Ignore commands starting with space

# Prompt
setopt PROMPT_SUBST

# Completion
setopt auto_list            # Show completion candidates as list
setopt auto_menu            # Switch through candidates with TAB
setopt magic_equal_subst    # Complete input after '='
setopt auto_param_keys      # Delete auto-inserted commas etc.
setopt list_packed          # Pack completion candidates

# Navigation
setopt nobeep
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

# Display processing time for commands over 3 seconds
REPORTTIME=3
