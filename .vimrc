" __________
"< my vimrc >
" ----------
"        \   ^__^
"         \  (oo)\_______
"            (__)\       )\/\
"                ||----w |
"                ||     ||
"
" cute vim
set encoding=utf-8
scriptencoding utf-8

" initialize vimrc
augroup vimrc
  autocmd!
augroup END

" indent
set smartindent
set autoindent
set smarttab
set shiftround

" TAB settings
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" set font
set guifont=Ricty\ 10

" textwrap
set wrap
set linebreak
set textwidth=0
set colorcolumn=80

" basic settings
set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
set showmatch
set matchtime=1
set matchpairs& matchpairs+=<:>
set cursorline
hi clear CursorLine
set virtualedit=all
set backspace=start,eol,indent
set hidden

" mute
set belloff=all

" search settings
set ignorecase
set smartcase
set incsearch
set hlsearch

" status line
set showcmd
set laststatus=2

" clipboard
set clipboard=unnamed

" max syntax highlight column
set synmaxcol=200

" make new split window on below(v) or right(s)
set splitbelow
set splitright

" key mapping
nmap <silent> <Esc><Esc> :nohlsearch<CR><Esc>
inoremap jj <Esc>

" zz with search result
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" quick window move
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" change window size with Shift + cursor
nnoremap <S-Left>  <C-w><
nnoremap <S-Right> <C-w>>
nnoremap <S-Up>    <C-w>-
nnoremap <S-Down>  <C-w>+

" show smile when use cursol key
noremap  <Left>  :<C-u>smile<CR>
noremap  <Right> :<C-u>smile<CR>
noremap  <Up>    :<C-u>smile<CR>
noremap  <Down>  :<C-u>smile<CR>
inoremap <Left>  <Esc>:smile<CR>
inoremap <Right> <Esc>:smile<CR>
inoremap <Up>    <Esc>:smile<CR>
inoremap <Down>  <Esc>:smile<CR>

" save as root
cmap w!! w !sudo tee > /dev/null %

" launch VimFiler
nnoremap <Space>f :VimFiler -split -simple -winwidth=30 -no-quit<Enter>

" macro

" auto mkdir with :e
function! s:mkdir(dir, force)
    if !isdirectory(a:dir) && (
        \ a:force || input(printf(
        \ '"%s" does not exist. Create? [y/N]', a:dir
        \ )) =~? '^y\%[es]$'
        \ )
        call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
autocmd vimrc BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)
endfunction

" for neovim

" enable python3
let g:python3_host_prog = 'python3'

" dein settings -----------------------------------------------------------
" plugin install directory
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" download dein.vim if it not installed
if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" load TOML file listed plugins
let g:rc_dir = expand('~/.vim/rc')
let s:toml = g:rc_dir . '/dein.toml'
let s:toml_lazy = g:rc_dir . '/dein_lazy.toml'

"" start dein settings
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    call dein#load_toml(s:toml, {'lazy': 0})
    call dein#load_toml(s:toml_lazy, {'lazy': 1})
    call dein#end()
    call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
    call dein#install()
endif

filetype plugin indent on

" incsearch settigns
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" template settigns
autocmd vimrc User plugin-template-loaded call s:template_keywords()
function! s:template_keywords()
    silent! %s/<+DATE+>/\=strftime('%Y-%m-%d')/g
    silent! %s/<+FILENAME+>/\=expand('%:r')/g
endfunction

" move cursor to '<+CURSOR+>' in template
autocmd vimrc User plugin-template-loaded
    \ if search('<+CURSOR+>')
    \ | silent! execute 'normal! "_da>'
    \ | endif

function! MyModified()
    return &ft =~ 'help\|vimfiler\|gundo' ?
        \ '' : &modified ? '+' : &modifiable ? '' : '-'
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

" syntastic highlight

" 256 color on screen
if $TERM == 'screen'
    set t_Co=256
endif

"colorscheme hybrid
syntax enable

" filetype settings
autocmd BufRead,BufNewFile {*.coffee} set filetype=coffee
autocmd filetype coffee,javascript setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd filetype yaml setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd FileType typescript :set makeprg=tsc
autocmd FileType vue :set makeprg=vue

" open with last cursor position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\""
