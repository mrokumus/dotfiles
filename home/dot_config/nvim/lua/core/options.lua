local opt = vim.opt

opt.timeout = true
opt.timeoutlen = 300

-- Line numbers
opt.number = true         -- Show absolute line numbers
opt.relativenumber = true -- Relative numbers (useful for motions)

-- Tabs / indentation
opt.tabstop = 4        -- Number of spaces a <Tab> counts for
opt.shiftwidth = 4     -- Indent size
opt.expandtab = true   -- Convert tabs to spaces
opt.smartindent = true -- Smart auto-indentation

-- Search
opt.ignorecase = true -- Ignore case in search patterns
opt.smartcase = true  -- Override ignorecase if search has uppercase

-- Clipboard
opt.clipboard = "unnamedplus" -- Sync with system clipboard

-- Visuals
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.cursorline = true    -- Highlight the current line
opt.signcolumn = "yes"   -- Always show the sign column
opt.scrolloff = 8        -- Keep at least 8 lines visible above/below cursor
vim.cmd("syntax enable")

-- Split behavior
opt.splitright = true -- Vertical splits open on the right
opt.splitbelow = true -- Horizontal splits open below

-- Performance
opt.updatetime = 300 -- Faster completion/diagnostics
opt.timeoutlen = 500 -- Mapped sequence timeout

-- Files
opt.swapfile = false -- Disable swapfile
opt.backup = false   -- Disable backup files
opt.undofile = true  -- Persistent undo

-- Mouse
opt.mouse = "" -- Disable mouse

-- Disable arrow keys in normal/insert/visual modes
local keys = { "<Up>", "<Down>", "<Left>", "<Right>" }
for _, key in ipairs(keys) do
    vim.api.nvim_set_keymap("n", key, "<Nop>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("i", key, "<Nop>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("v", key, "<Nop>", { noremap = true, silent = true })
end
