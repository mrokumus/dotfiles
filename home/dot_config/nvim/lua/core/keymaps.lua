vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Diagnostics on demand
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

---------------------------
-- Basic file operations
---------------------------
map("n", "<leader>w", ":w<CR>", { desc = "Save the file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit the file" })
map("n", "<leader>Q", ":qa<CR>", { desc = "Quit all files" })

---------------------------
-- Splits & window navigation
---------------------------
map("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", ":split<CR>", { desc = "Horizontal split" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })

---------------------------
-- Buffers
---------------------------
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

---------------------------
-- Visual Mode Enhancements
---------------------------
-- Stay in indent mode when shifting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

---------------------------
-- Clipboard / System clipboard
---------------------------
-- Yank to system clipboard
map("v", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+yy', { desc = "Yank line to system clipboard" })
-- Paste from system clipboard
map("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map("v", "<leader>p", '"+p', { desc = "Paste from system clipboard" })

---------------------------
-- Search & replace
---------------------------
-- Clear search highlighting
map("n", "<leader>nh", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Quick find and replace word under cursor
map("n", "<leader>rw", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Replace word under cursor" })

-- Reload config without restarting
map("n", "<leader>r", ":source $MYVIMRC<CR>", { desc = "Reload nvim config" })

-- Open netrw
map("n", "<leader>e", ":Explore<CR>", { desc = "File tree (netrw)" })
