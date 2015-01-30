# PATH
PATH=/home/$USER/bin/:$PATH
# LANG
export LANG=ja_JP.UTF-8
# エイリアス設定
alias vi="vim -u NONE --noplugin"
alias awk="gawk"
alias ll="ls -l"
alias la="ls -a"
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
## プロンプトの設定（左）
PROMPT="%{[34m%}[%n@${HOST}]% $ %{[m%}"
## プロンプトの設定（右）
## カレントディレクトリのフルパスを表示する
RPROMPT="%{[34m%}[%d]%{[m%}"
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
compinit -u
## 補完候補を一覧表示
setopt auto_list
## TAB で順に補完候補を切り替える
setopt auto_menu
# others
## ビープを鳴らさない
setopt nobeep
## ディレクトリ名だけで cd
setopt auto_cd
