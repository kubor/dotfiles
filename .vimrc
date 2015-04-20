"-----------------------------------------------------------------------------"
"                                   .vimrc 
"                               wrote by kubor
"-----------------------------------------------------------------------------"

"------------------------"
"        基本設定
"------------------------"
" encoding
set encoding=utf-8
scriptencoding utf-8
" MyAutoCmdを初期化
augroup MyAutoCmd
  autocmd!
augroup END
" インデントの設定
set smartindent
set autoindent
set smarttab
set shiftround
" set font
set guifont=Ricty\ 10
" 折り返しの設定
set wrap
set linebreak
set textwidth=0
set colorcolumn=80
" 行番号を表示
set number
" 不可視文字を表示する
"" 表示する文字を以下に変更
set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
" 括弧の強調表示
set showmatch
set matchtime=1
"" '<'と'>'も強調表示
set matchpairs& matchpairs+=<:>
" TAB入力時の設定
set noexpandtab
set tabstop=8
set shiftwidth=2
set softtabstop=2
" 検索時の設定
set ignorecase
set smartcase
set incsearch
"" 現在行番号をハイライトする
set cursorline
hi clear CursorLine
" Backspaceを有効にする
set backspace=start,eol,indent
" 前回終了した位置から編集を開始する
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\""

"------------------------"
"     キーマッピング
"------------------------"
" ESC連打で検索結果のハイライトを消す
set hlsearch
nmap <silent> <Esc><Esc> :nohlsearch<CR><Esc>
" jjをESCと同義にする
inoremap jj <Esc>
" 検索結果を画面中央に表示
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" Ctrl + hjkl でウィンドウを移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>
" w!! でroot権限で保存
cmap w!! w !sudo tee > /dev/null %

"------------------------"
"      マクロの設定
"------------------------"
" :eで開く際にフォルダが存在しない場合に自動作成する
function! s:mkdir(dir, force)
  if !isdirectory(a:dir) && (
	\ a:force || input(printf(
	\ '"%s" does not exist. Create? [y/N]', a:dir
	\ )) =~? '^y\%[es]$'
      \ )
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)

"------------------------"
"     NeoBundleの設定
"------------------------"
filetype plugin indent off
" NeoBundleで管理するディレクトリを指定
if has('vim_starting')
  set runtimepath+=~/dotfiles/.vim/neobundle/neobundle.vim
  call neobundle#begin(expand('~/dotfiles/.vim/neobundle'))
endif
" NeoBundle自身もNeoBundleで管理する
NeoBundleFetch 'Shougo/neobundle.vim'
"----- プラグイン
"" indentline
NeoBundle 'Yggdroot/indentLine'
"" monokai
NeoBundle 'sickill/vim-monokai'
"" hybrid
NeoBundle 'w0ng/vim-hybrid'
"" vim-perl
NeoBundle 'vim-perl/vim-perl'
"" lightlinet
NeoBundle 'itchyny/lightline.vim'
"" vim-tamplate
NeoBundle "thinca/vim-template"
"" vim-quickrun
NeoBundle "thinca/vim-quickrun"
"" snipets
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
"" perldoc.vim
NeoBundle 'hotchpotch/perldoc-vim'
""----- 遅延モードでロードするプラグイン
NeoBundleLazy 'Shougo/neocomplete.vim', {
    \ "autoload": {"insert": 1}}
" Djangoのサポート
NeoBundleLazy "lambdalisue/vim-django-support", {
      \ "autoload": {
      \   "filetypes": ["python", "python3", "djangohtml"]
      \ }}
" vim-virtualenv
NeoBundleLazy "jmcantrell/vim-virtualenv", {
      \ "autoload": {
      \   "filetypes": ["python", "python3", "djangohtml"]
      \ }}
" jedi-vim
NeoBundleLazy "davidhalter/jedi-vim", {
      \ "autoload": {
      \   "filetypes": ["python", "python3", "djangohtml"],
      \ }}
let s:hooks = neobundle#get_hooks("jedi-vim")
function! s:hooks.on_source(bundle)
  let g:jedi#auto_vim_configuration = 0
  let g:jedi#popup_select_first = 0
  let g:jedi#rename_command = '<Leader>R'
  let g:jedi#goto_assignments_command = '<Leader>G'
endfunction
"----- NeoBundleの設定を終了
call neobundle#end()
filetype plugin indent on
"" 未インストールのプラグインを起動時に通知
NeoBundleCheck

"------------------------"
"    neocompleteの設定
"------------------------"
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
" Close popup by <Enter>.
inoremap <expr><CR> pumvisible() ? neocomplete#close_popup() : "\<CR>"

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

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

"------------------------"
"   vim-templateの設定
"------------------------"
" テンプレート読み込み時に日付などを差し替える
autocmd MyAutoCmd User plugin-template-loaded call s:template_keywords()
function! s:template_keywords()
    silent! %s/<+DATE+>/\=strftime('%Y-%m-%d')/g
    silent! %s/<+FILENAME+>/\=expand('%:r')/g
endfunction
" テンプレート中に含まれる'<+CURSOR+>'にカーソルを移動
autocmd MyAutoCmd User plugin-template-loaded
    \   if search('<+CURSOR+>')
    \ |   silent! execute 'normal! "_da>'
    \ | endif

"------------------------"
"    スニペットの設定
"------------------------"
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: "\<TAB>"
if has('conceal')
  set conceallevel=2 concealcursor=i
  endif

"------------------------"
"  カラースキームの設定
"------------------------"
" iTerm2用
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

"------------------------"
"   Status Lineの設定
"------------------------"
" ステータスラインにコマンドを表示
set showcmd
" ステータスラインを常に表示
set laststatus=2
" lightlineプラグインの設定
let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
        \ },
        \ 'component_function': {
        \   'modified': 'MyModified',
        \   'readonly': 'MyReadonly',
        \   'fugitive': 'MyFugitive',
        \   'filename': 'MyFilename',
        \   'fileformat': 'MyFileformat',
        \   'filetype': 'MyFiletype',
        \   'fileencoding': 'MyFileencoding',
        \   'mode': 'MyMode'
				\	},
        \ 'separator': {'left':"\u2b80", 'right':"\u2b82"},
        \ 'subseparator': {'left':"\u2b81", 'right':"\u2b83"}
        \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      return fugitive#head()
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

"------------------------"
" シンタックスハイライト
"------------------------"
syntax enable
au BufRead,BufNewFile {*.md,*.txt} set filetype=markdown
