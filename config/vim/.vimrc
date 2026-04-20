" __________
"< my vimrc >
" ----------
"        \   ^__^
"         \  (oo)\_______
"            (__)\       )\/\
"                ||----w |
"                ||     ||
"
" Minimal vimrc (no plugins) for environments without neovim

set encoding=utf-8
scriptencoding utf-8

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

filetype plugin indent on

" 256 color on screen
if $TERM == 'screen'
    set t_Co=256
endif

syntax enable
colorscheme desert

" filetype settings
autocmd BufRead,BufNewFile {*.coffee} set filetype=coffee
autocmd filetype coffee,javascript setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd filetype yaml setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd FileType typescript :set makeprg=tsc

" open with last cursor position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\""
