local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local vimrc = augroup("vimrc", { clear = true })

-- filetype-specific indentation
autocmd("FileType", {
  group = vimrc,
  pattern = { "coffee", "javascript", "yaml" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- TypeScript makeprg
autocmd("FileType", {
  group = vimrc,
  pattern = "typescript",
  callback = function()
    vim.opt_local.makeprg = "tsc"
  end,
})

-- CoffeeScript filetype detection
autocmd({ "BufRead", "BufNewFile" }, {
  group = vimrc,
  pattern = "*.coffee",
  callback = function()
    vim.bo.filetype = "coffee"
  end,
})

-- restore cursor position
autocmd("BufReadPost", {
  group = vimrc,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- auto mkdir on save
autocmd("BufWritePre", {
  group = vimrc,
  callback = function(args)
    local dir = vim.fn.fnamemodify(args.file, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- clear CursorLine highlight (underline only)
autocmd("ColorScheme", {
  group = vimrc,
  callback = function()
    vim.api.nvim_set_hl(0, "CursorLine", { underline = true })
  end,
})
