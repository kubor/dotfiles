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
set tabstop=8
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
set number
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

set clipboard=unnamed

set synmaxcol=120

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

" save as root
cmap w!! w !sudo tee > /dev/null %

" move to pair tag
nnoremap <Tab> %
vnoremap <Tab> %

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


" neobundle settigns ----------------------------------------------------------
filetype plugin indent off

" specify the NeoBundle dir
if has('vim_starting')
    set runtimepath+=~/dotfiles/.vim/neobundle/neobundle.vim
    call neobundle#begin(expand('~/dotfiles/.vim/neobundle'))
endif

NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'tpope/vim-surround'
NeoBundle 'Yggdroot/indentLine'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'vim-perl/vim-perl'
NeoBundle 'itchyny/lightline.vim'
NeoBundle "thinca/vim-template"
NeoBundle "thinca/vim-quickrun"
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'hotchpotch/perldoc-vim'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'haya14busa/incsearch.vim'

" lazy loading plugins
if has('nvim')
    NeoBundleLazy 'Shougo/deoplete.nvim', {
        \ "autoload": {"insert":1}}
    let s:hooks = neobundle#get_hooks("deoplete.nvim")
    function! s:hooks.on_source(bundle)
        let g:deoplete#enable_at_startup = 1
    endfunction
else
    NeoBundleLazy 'Shougo/neocomplete.vim', {
        \ "autoload": {"insert": 1}}
    let s:hooks = neobundle#get_hooks("neocomplete.vim")
    function! s:hooks.on_source(bundle)
        let g:neocomplete#enable_smart_case = 1
        let g:neocomplete#enable_at_startup = 1
    endfunction
endif

NeoBundleLazy "lambdalisue/vim-django-support", {
    \ "autoload": {
    \ "filetypes": ["python", "python3", "djangohtml"]}}
NeoBundleLazy 'hynek/vim-python-pep8-indent', {
    \ "autoload": {
    \ "insert": 1, "filetypes": ["python", "python3", "djangohtml"]}}
NeoBundleLazy "jmcantrell/vim-virtualenv", {
    \ "autoload": {
    \ "filetypes": ["python", "python3", "djangohtml"]}}
NeoBundleLazy "davidhalter/jedi-vim", {
    \ "autoload": {
    \ "filetypes": ["python", "python3", "djangohtml"]}}
NeoBundleLazy "lambdalisue/vim-pyenv", {
    \ "depends": ['davidhalter/jedi-vim'],
    \ "autoload": {
    \   "filetypes": ["python", "python3", "djangohtml"]}}
NeoBundleLazy 'kchmck/vim-coffee-script', {
    \ "autoload": {
    \ "insert": 1, "filetypes": ["coffee"]}}

let s:hooks = neobundle#get_hooks("jedi-vim")
function! s:hooks.on_source(bundle)
    autocmd vimrc FileType python setlocal omnifunc=jedi#completions
    let g:jedi#completions_enabled = 0
    let g:jedi#auto_vim_configuration = 0
    let g:jedi#popup_select_first = 0
    " resolve keymap duplicate with vim-quickrun
    let g:jedi#rename_command = '<Leader>R'
    if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
    endif
    let g:neocomplete#force_omni_input_patterns.python =
        \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
endfunction

call neobundle#end()
filetype plugin indent on

NeoBundleCheck

" neobundle settings ----------------------------------------------------------


" neocomplete settigns --------------------------------------------------------

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
    \ 'default': '',
    \ 'vimshell': $HOME.'/.vimshell_hist',
    \ 'scheme': $HOME.'/.gosh_completions'}
" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'
" Plugin key-mappings.
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()
" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return neocomplete#close_popup() . "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Enter>.
inoremap <expr><CR> pumvisible() ? neocomplete#close_popup() : "\<CR>"

" Enable omni completion.
autocmd vimrc FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd vimrc FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd vimrc FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd vimrc FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" end of neocomplete settings -------------------------------------------------


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

" snipets settings
imap <C-k>      <Plug>(neosnippet_expand_or_jump)
smap <C-k>      <Plug>(neosnippet_expand_or_jump)
xmap <C-k>      <Plug>(neosnippet_expand_target)
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)": pumvisible() ?
    \ "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)": "\<TAB>"
if has('conceal')
  set conceallevel=2 concealcursor=i
  endif


" status line settigns
let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'mode_map': {'c': 'NORMAL'},
    \ 'active': {
    \     'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
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
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '|', 'right': '|' }
    \ }

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


" use flake8 for python lint checker
let g:syntastic_python_checkers = ['flake8']


" syntastic highlight

" 256 color on screen
if $TERM == 'screen'
    set t_Co=256
endif

" set colorscheme
set background=dark
colorscheme hybrid
syntax enable

" filetype settings
au BufRead,BufNewFile {*.md,*.txt} set filetype=markdown
au BufRead,BufNewFile {*.coffee} set filetype=coffee
autocmd filetype coffee,javascript setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab


" open with last cursor position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\""
