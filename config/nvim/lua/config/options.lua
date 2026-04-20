local opt = vim.opt

-- encoding (utf-8 is neovim default, but be explicit)
opt.fileencoding = "utf-8"

-- indent
opt.smartindent = true
opt.autoindent = true
opt.smarttab = true
opt.shiftround = true

-- TAB settings
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4

-- textwrap
opt.wrap = true
opt.linebreak = true
opt.textwidth = 0
opt.colorcolumn = "80"

-- basic settings
opt.list = true
opt.listchars = { tab = "»-", trail = "-", extends = "»", precedes = "«", nbsp = "%", eol = "↲" }
opt.showmatch = true
opt.matchtime = 1
opt.matchpairs:append("<:>")
opt.cursorline = true
opt.virtualedit = "all"
opt.backspace = { "start", "eol", "indent" }
opt.hidden = true

-- mute
opt.belloff = "all"

-- search settings
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- status line
opt.showcmd = true
opt.laststatus = 2

-- clipboard
opt.clipboard = "unnamed"

-- max syntax highlight column
opt.synmaxcol = 200

-- make new split window on below(v) or right(s)
opt.splitbelow = true
opt.splitright = true

-- neovim specific
opt.inccommand = "split"
opt.termguicolors = true
opt.signcolumn = "yes"
opt.undofile = true
