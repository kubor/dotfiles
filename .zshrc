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

# zplug init
if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update --self
fi
source ~/.zplug/init.zsh

# PATH
PATH=/home/$USER/bin:$PATH
# localのpipディレクトリにPATHを通す
PATH=$HOME/.local/bin:$PATH

# Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# anyenv path
export PATH="$HOME/.anyenv/bin:$PATH"

# set paths for terminal multiprexa(tmux)
# cf. http://monmon.hateblo.jp/entry/2013/12/13/233242
for dir in `ls $HOME/.anyenv/envs`
do
    export PATH="$HOME/.anyenv/envs/$dir/shims:$PATH"
done

## サーバ個別のPATH設定をインポート
if [ -f ~/.zshrc.path ]; then
    source ~/.zshrc.path
fi
# LANG
export LANG=ja_JP.UTF-8

## anyenv の初期化
if type anyenv >/dev/null 2>&1; then
    eval "$(anyenv init -)"
fi

# direnv
if type direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
    export EDITOR="vim"
fi

# エイリアス設定
alias vi="vim -u NONE --noplugin"
alias awk="gawk"
alias ll="ls -l"
alias la="ls -a"
alias mv="mv -i"
alias rm="rm -i"
alias grep="grep --color=auto -i"
alias grep="zgrep --color=auto -i"
alias egrep="egrep --color=auto -i"
alias src="source ~/.zshrc"
if type ccat > /dev/null 2>&1; then
    alias cat="ccat"
fi
if type htop > /dev/null 2>&1; then
    alias top="htop"
fi

## git 関係
alias gst="git status -sb"
alias gg="git status -sb"
alias gm="git commit -m"
alias gb="git branch -a"
alias co="git checkout"

## make
alias j4="echo-sd \"デマアアアァアァァシアアアアァァァアアア\!\!\!\!\"; make -j 4"

## グローバルエイリアス
alias -g L="| less"
alias -g G="| grep"
alias -g W="| wc"

## サーバ個別のalias設定をインポート
if [ -f ~/.zshrc.alias ]; then
    source ~/.zshrc.alias
fi
## エスケープシーケンスカラーの設定
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
## history (fc -l) コマンドをヒストリリストから取り除く。
setopt hist_no_store
## すぐにヒストリファイルに追記する。
setopt inc_append_history
## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
## zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt extended_history
## ヒストリを呼び出してから実行する間に一旦編集
setopt hist_verify
## ヒストリを共有
setopt share_history
## コマンドラインの先頭がスペースで始まる場合ヒストリに追加しない
setopt hist_ignore_space
# プロンプトの設定
# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt PROMPT_SUBST
# gitのステータスをプロンプトに表示する
## imported from http://int128.hatenablog.com/entry/2015/07/15/003851
#autoload -Uz add-zsh-hook
#
#function _vcs_git_indicator() {
#  typeset -A git_info
#  local git_indicator git_status
#  git_status=("${(f)$(git status --porcelain --branch 2> /dev/null)}")
#  (( $? == 0 )) && {
#    git_info[branch]="${${git_status[1]}#\#\# }"
#    shift git_status
#    git_info[changed]=${#git_status:#\?\?*}
#    git_info[untracked]=$(($#git_status - ${git_info[changed]}))
#    git_info[clean]=$(($#git_status == 0))
#
#    git_indicator=("%{%F{blue}%}${git_info[branch]}%{%f%}")
#    ((${git_info[clean]})) && git_indicator+=("%{%F{}%}clean%{%f%}")
#    ((${git_info[changed]})) && git_indicator+=("%{%F{yellow}%}${git_info[changed]} changed%{%f%}")
#    ((${git_info[untracked]})) && git_indicator+=("%{%F{red}%}${git_info[untracked]} untracked%{%f%}")
#  }
#  _vcs_git_indicator="${git_indicator}"
#}
#
#add-zsh-hook precmd _vcs_git_indicator
#
#function {
#  local dir='%{%F{blue}%B%}%~%{%b%f%}'
#  local rc="%(?, , %{%F{red}%}%?%{%f%})"
#  local user='%{%F{green}%}[%n@%{%f%}'
#  local host='%{%F{green}%}%m]%{%f%}'
#  [ "$SSH_CLIENT" ] && local via="${${=SSH_CLIENT}[1]} %{%B%}>>>%{%b%} "
#  local git='$_vcs_git_indicator'
#  local mark=$'%{%F{blue}%B%}$ %{%f%}'
#  local linebreak=$'\n'
#  PROMPT="$user$via$host $mark"
#  RPROMPT="$dir $rc $git"
#}
## cdした後に自動的にlsする # import yonchu / chpwd_for_zsh.sh
function chpwd() {
    ls_abbrev
}
ls_abbrev() {
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-aCF' '--color=always')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-aCFG')
            fi
            ;;
    esac

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 10 ]; then
        echo "$ls_result" | head -n 5
        echo '...'
        echo "$ls_result" | tail -n 5
        echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
    else
        echo "$ls_result"
    fi
}
# 補完
## 補完候補を一覧表示
setopt auto_list
## TAB で順に補完候補を切り替える
setopt auto_menu
## '='以降の入力も補完する
setopt magic_equal_subst
## 補完関数の設定
## 補完候補をカーソルで選択可能にする
zstyle ':completion:*:default' menu select=1
## 補完候補をグルーピングして表示する
zstyle ':completion:*' completer _expand _complete _match _approximate _history
    # _expand: グロブや変数を展開する
    # _complete: 通常の補完
    # _match: グロブでコマンドを補完する
    # _approximate: ミススペルを訂正して補完する
    # _history: 履歴から補完する
zstyle ':completion:*:descriptions' format $YELLOW'completing %B%d%b'$DEFAULT
## 自動入力されるカンマなどを適宜削除する
setopt auto_param_keys
## 補完候補を詰めて表示
setopt list_packed
# others
## ビープを鳴らさない
setopt nobeep
## ディレクトリ名だけで cd
setopt auto_cd
## cdの履歴を保存
setopt auto_pushd
## 重複したcdの履歴は保存しない
setopt pushd_ignore_dups
## 3秒以上の処理は自動的に処理時間を表示
REPORTTIME=3
# pecoで履歴を検索する
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
# pecoでスニペットを読み込む
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

# peco関係の関数をキーバインドに登録
if type peco >/dev/null 2>&1; then
    bindkey '^r' peco-history-selection
    bindkey '^x' peco-snippets-loader
fi

# zplug plugins

zplug "mafredri/zsh-async", on:sindresorhus/pure
zplug "sindresorhus/pure", use:pure.zsh
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "supercrabtree/k"
zplug "mollifier/cd-gitroot"
zplug "zplug/zplug"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

# for debug
#if (which zprof > /dev/null) ;then
#      zprof | less
#fi
