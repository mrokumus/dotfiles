vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Stay in indent mode when shifting
-- map("v", "<", "<gv", opts)
-- map("v", ">", ">gv", opts)

-- Move selected lines up/down
-- map("v", "J", ":m '>+1<CR>gv=gv", opts)
-- map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Clear search highlighting
map("n", "<leader>nh", ":nohlsearch<CR>", { desc = "Clear search highlight" })
