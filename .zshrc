# PATH
PATH=/home/$USER/bin/:$PATH
# LANG
export LANG=ja_JP.UTF-8
# rbenv | pyenv の初期化
eval "$(rbenv init - --no-rehash)"
eval "$(pyenv init - --no-rehash)"
eval "$(pyenv virtualenv-init - --no-rehash)"
# エイリアス設定
alias vi="vim -u NONE --noplugin"
alias awk="gawk"
alias lls=ls_abbrev
alias ll="ls -l"
alias la="ls -a"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
## グローバルエイリアス
alias -g L="| less"
alias -g G="| grep"
alias -g W="| wc"
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
# imported from http://int128.hatenablog.com/entry/2015/07/15/003851
autoload -Uz add-zsh-hook

typeset -A emoji
emoji[ok]=$'\U2705'
emoji[error]=$'\U274C'
emoji[git]=$'\U1F500'
emoji[git_changed]=$'\U1F37A'
emoji[git_untracked]=$'\U1F363'
emoji[git_clean]=$'\U2728'
emoji[right_arrow]=$'\U2794'

function _vcs_git_indicator () {
  typeset -A git_info
  local git_indicator git_status
  git_status=("${(f)$(git status --porcelain --branch 2> /dev/null)}")
  (( $? == 0 )) && {
    git_info[branch]="${${git_status[1]}#\#\# }"
    shift git_status
    git_info[changed]=${#git_status:#\?\?*}
    git_info[untracked]=$(( $#git_status - ${git_info[changed]} ))
    git_info[clean]=$(( $#git_status == 0 ))

    git_indicator=("${emoji[git]}  %{%F{blue}%}${git_info[branch]}%{%f%}")
    (( ${git_info[clean]}     )) && git_indicator+=("${emoji[git_clean]}")
    (( ${git_info[changed]}   )) && git_indicator+=("${emoji[git_changed]}  %{%F{yellow}%}${git_info[changed]} changed%{%f%}")
    (( ${git_info[untracked]} )) && git_indicator+=("${emoji[git_untracked]}  %{%F{red}%}${git_info[untracked]} untracked%{%f%}")
  }
  _vcs_git_indicator="${git_indicator}"
}

add-zsh-hook precmd _vcs_git_indicator

function {
  local dir='%{%F{blue}%B%}%~%{%b%f%}'
  local now='%{%F{yellow}%}%D{%b/%e(%a)%R}%{%f%}'
  local rc="%(?,${emoji[ok]} ,${emoji[error]}  %{%F{red}%}%?%{%f%})"
  local user='%{%F{green}%}%n%{%f%}@'
  local host='%{%F{green}%}%m%{%f%}'
  [ "$SSH_CLIENT" ] && local via="${${=SSH_CLIENT}[1]} %{%B%}${emoji[right_arrow]}%{%b%} "
  local git='$_vcs_git_indicator'
  local mark=$'%# '
  local linebreak=$'\n'
  PROMPT="$user$via$host $mark"
  RPROMPT="$dir $rc $git $now"
}
# cdなしでディレクトリを移動する
setopt auto_cd
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
## zsh-competionsの読み込み
fpath=(/usr/local/share/zsh-completions $fpath)
## 補完機能を有効にする
autoload -Uz compinit
compinit -C
## 補完候補を一覧表示
setopt auto_list
## TAB で順に補完候補を切り替える
setopt auto_menu
# others
## ビープを鳴らさない
setopt nobeep
## ディレクトリ名だけで cd
setopt auto_cd
## cdの履歴を保存
setopt auto_pushd

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"


# for debug
#if (which zprof > /dev/null) ;then
#      zprof | less
#fi
