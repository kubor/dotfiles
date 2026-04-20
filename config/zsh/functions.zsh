# fzf: Search history
function fzf-history-selection() {
    cmd='tac'
    case "${OSTYPE}" in
        freebsd*|darwin*)
            cmd=('tail' '-r')
        ;;
    esac
    BUFFER=$(history -n 1 | $cmd | awk '!a[$0]++' | fzf --no-sort --reverse)
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf-history-selection

# fzf: Jump to ghq-managed repository
function fzf-ghq-search() {
    local selected_dir
    selected_dir=$(ghq list -p | fzf --query "$LBUFFER" --preview 'eza --icons --git -1 {}')
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N fzf-ghq-search

# fzf: Load snippets
function fzf-snippets-loader() {
    if ls ~/.peco.snippet* >/dev/null 2>&1; then
        local snippet
        snippet=$(cat ~/.peco.snippet* | grep -v "^#" | fzf)
        BUFFER="$(echo "$snippet" | sed -e 's/^\[.*\] *//') "
        CURSOR=$#BUFFER
    else
        echo "~/.peco.snippet* is not found."
    fi
    zle reset-prompt
}
zle -N fzf-snippets-loader

# fzf: Search abbreviations
function fzf-abbr-search() {
    local selected
    selected=$(abbr | fzf --query "$LBUFFER")
    if [ -n "$selected" ]; then
        local abbr_key="${selected%%=*}"
        # Remove surrounding quotes from key if present
        abbr_key="${abbr_key%\"}"
        abbr_key="${abbr_key#\"}"
        LBUFFER="${abbr_key} "
    fi
    zle reset-prompt
}
zle -N fzf-abbr-search

# Register fzf keybindings
if type fzf >/dev/null 2>&1; then
    bindkey '^r' fzf-history-selection
    bindkey '^]' fzf-ghq-search
    bindkey '^x' fzf-snippets-loader
    bindkey '^s' fzf-abbr-search
fi

# gitignore.io
function gi() {
    curl -sL "https://www.gitignore.io/api/$*"
}

_gitignoreio_get_command_list() {
    curl -sL https://www.gitignore.io/api/list | tr "," "\n"
}

_gitignoreio () {
    compset -P '*,'
    compadd -S '' "$(_gitignoreio_get_command_list)"
}

compdef _gitignoreio gi

# command_not_found_handler
function command_not_found_handler(){
    if [ -e "$HOME/bin/imgcat" ]; then
        if [ -e ~/src/commandmiss/iori.jpg ]; then
            imgcat ~/src/commandmiss/iori.jpg
        fi
    fi
    echo "Huh...? What are you talking about with '$1'?\nYou can't even remember commands properly, you're utterly hopeless."
}

# Rich git status function
gg() {
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        print -P "%F{red}Not a git repository%f"
        return 1
    fi

    local section_color="%F{cyan}"
    local reset="%f"

    # 1. Branch + upstream tracking
    print -P "${section_color}── Branch ──${reset}"
    git status -sb | head -1
    echo

    # 2. Staged files
    local staged
    staged=$(git diff --cached --name-status)
    if [[ -n "$staged" ]]; then
        print -P "${section_color}── Staged ──${reset}"
        echo "$staged" | while IFS=$'\t' read -r status file rest; do
            case "$status" in
                A*)  print -P "  %F{green}+%f $file" ;;
                D*)  print -P "  %F{red}-%f $file" ;;
                M*)  print -P "  %F{yellow}~%f $file" ;;
                R*)  print -P "  %F{blue}>%f $rest ← $file" ;;
                *)   print -P "  $status $file" ;;
            esac
        done
        echo
    fi

    # 3. Unstaged files
    local unstaged
    unstaged=$(git diff --name-status)
    if [[ -n "$unstaged" ]]; then
        print -P "${section_color}── Unstaged ──${reset}"
        echo "$unstaged" | while IFS=$'\t' read -r status file rest; do
            case "$status" in
                A*)  print -P "  %F{green}+%f $file" ;;
                D*)  print -P "  %F{red}-%f $file" ;;
                M*)  print -P "  %F{yellow}~%f $file" ;;
                R*)  print -P "  %F{blue}>%f $rest ← $file" ;;
                *)   print -P "  $status $file" ;;
            esac
        done
        echo
    fi

    # 4. Untracked files
    local untracked
    untracked=$(git ls-files --others --exclude-standard)
    if [[ -n "$untracked" ]]; then
        print -P "${section_color}── Untracked ──${reset}"
        echo "$untracked" | while read -r file; do
            print -P "  %F{magenta}?%f $file"
        done
        echo
    fi

    # 5. Stash count
    local stash_count
    stash_count=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$stash_count" -gt 0 ]]; then
        print -P "${section_color}── Stash ──${reset}"
        print -P "  %F{yellow}${stash_count}%f stash(es)"
        echo
    fi

    # 6. Recent commits
    local log_output
    log_output=$(git log --oneline --graph --decorate --color=always -5 2>/dev/null)
    if [[ -n "$log_output" ]]; then
        print -P "${section_color}── Recent Commits ──${reset}"
        echo "$log_output"
        echo
    fi

    # 7. Diff stat
    local diff_stat
    diff_stat=$(git diff --stat --color=always HEAD 2>/dev/null)
    if [[ -n "$diff_stat" ]]; then
        print -P "${section_color}── Diff Stat ──${reset}"
        echo "$diff_stat"
    fi
}
