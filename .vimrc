"基本設定
""オートインデント
set smartindent
set autoindent
set smarttab
""シンタックスハイライト
syntax enable
""行番号の表示
set number
""括弧の強調表示
set showmatch
"TAB入力時の設定
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=0
"NeoBundleの設定
filetype plugin indent off
""NeoBundleで管理するディレクトリを指定
if has('vim_starting')
	set runtimepath+=~/dotfiles/.vim/neobundle/neobundle.vim
	call neobundle#begin(expand('~/dotfiles/.vim/neobundle'))
endif
""NeoBundle自身もNeoBundleで管理する
NeoBundleFetch 'Shougo/neobundle.vim'
""プラグイン
""monokai
NeoBundle 'sickill/vim-monokai'
NeoBundle 'w0ng/vim-hybrid'
""NeoBundle設定終了
call neobundle#end()
filetype plugin indent on
""未インストールのプラグインを起動時に通知
NeoBundleCheck
"カラースキームの設定
""iTerm2用
let g:hybrid_use_iTerm_colors = 1
colorscheme hybrid
if &term =~ "xterm-256color" || "screen-256color"
	set t_Co=256
    set t_Sf=[3%dm
	set t_Sb=[4%dm
elseif &term =~ "xterm-color"
	set t_Co=8
	set t_Sf=[3%dm
	set t_Sb=[4%dm
endif
"Status Lineの設定
"自動文字数カウント
augroup WordCount
    autocmd!
    autocmd BufWinEnter,InsertLeave,CursorHold * call WordCount('char')
augroup END
let s:WordCountStr = ''
let s:WordCountDict = {'word': 2, 'char': 3, 'byte': 4}
function! WordCount(...)
    if a:0 == 0
        return s:WordCountStr
    endif
    let cidx = 3
    silent! let cidx = s:WordCountDict[a:1]
    let s:WordCountStr = ''
    let s:saved_status = v:statusmsg
    exec "silent normal! g\<c-g>"
    if v:statusmsg !~ '^--'
        let str = ''
        silent! let str = split(v:statusmsg, ';')[cidx]
        let cur = str2nr(matchstr(str, '\d\+'))
        let end = str2nr(matchstr(str, '\d\+\s*$'))
        if a:1 == 'char'
            " ここで(改行コード数*改行コードサイズ)を'g<C-g>'の文字数から引く
            let cr = &ff == 'dos' ? 2 : 1
            let cur -= cr * (line('.') - 1)
            let end -= cr * line('$')
        endif
        let s:WordCountStr = printf('%d/%d', cur, end)
    endif
    let v:statusmsg = s:saved_status
    return s:WordCountStr
endfunction

"ステータスラインにコマンドを表示
set showcmd
"ステータスラインを常に表示
set laststatus=2
"ファイルナンバー表示
set statusline=[%n]
"ホスト名表示
set statusline+=%{matchstr(hostname(),'\\w\\+')}@
"ファイル名表示
set statusline+=%<%F
"変更のチェック表示
"set statusline+=%m
"読み込み専用かどうか表示
set statusline+=%r
"ヘルプページなら[HELP]と表示
"set statusline+=%h
"プレビューウインドウなら[Prevew]と表示
"set statusline+=%w
"ファイルフォーマット表示
set statusline+=[%{&fileformat}]
"文字コード表示
set statusline+=[%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding}]
"ファイルタイプ表示
set statusline+=%y
"ここからツールバー右側
set statusline+=%=
"skk.vimの状態
"set statusline+=%{exists('*SkkGetModeStr')?SkkGetModeStr():''}
"文字バイト数/カラム番号
set statusline+=[%{col('.')-1}=ASCII=%B,HEX=%c]
"現在文字列/全体列表示
set statusline+=[C=%c/%{col('$')-1}]
"現在文字行/全体行表示
set statusline+=[L=%l/%L]
"現在のファイルの文字数をカウント
set statusline+=[WC=%{exists('*WordCount')?WordCount():[]}]
"現在行が全体行の何%目か表示
set statusline+=[%p%%]

"Backspaceを有効にする
set backspace=start,eol,indent
