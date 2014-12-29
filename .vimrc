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
set matchtime=1
"TAB入力時の設定
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=0
"ESC連打で検索結果のハイライトを消す
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>
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
""hybrid
NeoBundle 'w0ng/vim-hybrid'
""neocomplete
NeoBundle 'Shougo/neocomplete.vim'
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
"neocompleteの設定
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
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
