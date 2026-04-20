local map = vim.keymap.set

-- clear search highlight
map("n", "<Esc><Esc>", "<cmd>nohlsearch<CR>", { silent = true })

-- escape with jj
map("i", "jj", "<Esc>")

-- zz with search result
map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "*", "*zz")
map("n", "#", "#zz")
map("n", "g*", "g*zz")
map("n", "g#", "g#zz")

-- quick window move
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- change window size with Shift + cursor
map("n", "<S-Left>", "<C-w><")
map("n", "<S-Right>", "<C-w>>")
map("n", "<S-Up>", "<C-w>-")
map("n", "<S-Down>", "<C-w>+")

-- show smile when use cursor key
map({ "n", "v" }, "<Left>", "<cmd>smile<CR>")
map({ "n", "v" }, "<Right>", "<cmd>smile<CR>")
map({ "n", "v" }, "<Up>", "<cmd>smile<CR>")
map({ "n", "v" }, "<Down>", "<cmd>smile<CR>")
map("i", "<Left>", "<Esc><cmd>smile<CR>")
map("i", "<Right>", "<Esc><cmd>smile<CR>")
map("i", "<Up>", "<Esc><cmd>smile<CR>")
map("i", "<Down>", "<Esc><cmd>smile<CR>")

-- save as root
map("c", "w!!", "w !sudo tee > /dev/null %")
