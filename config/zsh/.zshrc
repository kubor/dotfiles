# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Initialize modules (only once per shell session to avoid compinit warnings).
if [[ -z "$_ZIM_INITIALIZED" ]]; then
  # Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
  if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
    source ${ZIM_HOME}/zimfw.zsh init
  fi
  source ${ZIM_HOME}/init.zsh
  _ZIM_INITIALIZED=1
fi

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install

# _________________________________
#< Life is like a box of chocolate >
# ---------------------------------
#        \   ^__^
#         \  (oo)\_______
#            (__)\       )\/\
#                ||----w |
#                ||     ||

# for debug
#zmodload zsh/zprof && zprof


# LANG
export LANG=ja_JP.UTF-8
# Use neovim
export EDITOR="nvim"

# set term env
export TERM="xterm-256color"

# PATH
# Add local pip directory to PATH
export PATH=$HOME/.local/bin:$PATH

# Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# for PyCharm shell integration
export PATH="$PATH:/usr/local/bin"

export PATH=$HOME/bin:$PATH


# go
export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/opt/go/libexec/bin

# poetry
export PATH=$PATH:$HOME/.poetry/bin

## Import server-specific PATH settings
if [ -f ~/.zshrc.path ]; then
    source ~/.zshrc.path
fi

# direnv
if type direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

# Load Claude Code environment variables
if [ -f ~/.claude_env ]; then
    source ~/.claude_env
fi

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

## Import server-specific alias settings
if [ -f ~/.zshrc.alias ]; then
    source ~/.zshrc.alias
fi
## Escape sequence color settings
local DEFAULT=$'%{[m%}'
local RED=$'%{[1;31m%}'
local GREEN=$'%{[1;32m%}'
local YELLOW=$'%{[1;33m%}'
local BLUE=$'%{[1;34m%}'
local PURPLE=$'%{[1;35m%}'
local LIGHT_BLUE=$'%{[1;36m%}'
local WHITE=$'%{[1;37m%}'
# HISTORY
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000


## Remove history (fc -l) command from history list.
setopt hist_no_store
## Immediately append to history file.
setopt inc_append_history
## Don't add the same command as previous to history
setopt hist_ignore_dups
## Write zsh start and end times to history file
setopt extended_history
## Edit history before executing
setopt hist_verify
## Share history
setopt share_history
## Don't add to history if command line starts with space
setopt hist_ignore_space
# Prompt settings
# Evaluate and substitute prompt string every time prompt is displayed
setopt PROMPT_SUBST
# Completion
## Show completion candidates as list
setopt auto_list
## Switch through completion candidates with TAB
setopt auto_menu
## Complete input after '='
setopt magic_equal_subst
## Appropriately delete auto-inserted commas etc.
setopt auto_param_keys
## Pack completion candidates when displaying
setopt list_packed
# others
## Don't beep
setopt nobeep
## cd with directory name only
setopt auto_cd
## Save cd history
setopt auto_pushd
## Don't save duplicate cd history
setopt pushd_ignore_dups
## Automatically display processing time for processes over 3 seconds
REPORTTIME=3
PURE_PROMPT_SYMBOL=">"

# Search history with peco
function peco-history-selection() {
    cmd='tac'
    case "${OSTYPE}" in
        freebsd*|darwin*)
            cmd=('tail' '-r')
        ;;
    esac
    BUFFER=`history -n 1 | $cmd | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-history-selection

# Load snippets with peco
function peco-snippets-loader() {
    if ls ~/.peco.snippet* >/dev/null 2>&1; then
        snippet=`cat ~/.peco.snippet* | grep -v "^#" | peco`
        BUFFER="$(echo $snippet | sed -e 's/^\[.*\] *//') "
        CURSOR=$#BUFFER
    else
        echo "~/.peco.snippet* is not found."
    fi
    zle reset-prompt
}
zle -N peco-snippets-loader

# peco ghq search
function peco-ghq-search() {
    local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-ghq-search

# Search abbreviations with peco
function peco-abbr-search() {
    local selected
    selected=$(abbr | peco --query "$LBUFFER")
    if [ -n "$selected" ]; then
        local abbr_key="${selected%%=*}"
        # Remove surrounding quotes from key if present
        abbr_key="${abbr_key%\"}"
        abbr_key="${abbr_key#\"}"
        LBUFFER="${abbr_key} "
    fi
    zle reset-prompt
}
zle -N peco-abbr-search

# Register peco-related functions to key bindings
if type peco >/dev/null 2>&1; then
    bindkey '^r' peco-history-selection
    bindkey '^]' peco-ghq-search
    bindkey '^x' peco-snippets-loader
    bindkey '^s' peco-abbr-search
fi

function command_not_found_handler(){
  if [ -e $HOME/bin/imgcat ];then
    if [ -e ~/src/commandmiss/iori.jpg ];then
      imgcat ~/src/commandmiss/iori.jpg
    fi
  fi
  echo "Huh...? What are you talking about with '$1'?\nYou can't even remember commands properly, you're utterly hopeless."
}

# gitignore.io
function gi() {
    curl -sL https://www.gitignore.io/api/$@
}

_gitignoreio_get_command_list() {
    curl -sL https://www.gitignore.io/api/list | tr "," "\n"
}

_gitignoreio () {
    compset -P '*,'
    compadd -S '' `_gitignoreio_get_command_list`
}

compdef _gitignoreio gi

## Import function definitions
if [ -f ~/.zshrc.func ]; then
    source ~/.zshrc.func
fi

# init mise
eval "$(mise activate zsh)"

## Starship prompt
eval "$(mise x -- starship init zsh)"

# for debug
#if (which zprof > /dev/null) ;then
#    zprof | less
#fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ryuichi_kubo/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ryuichi_kubo/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ryuichi_kubo/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ryuichi_kubo/google-cloud-sdk/completion.zsh.inc'; fi
