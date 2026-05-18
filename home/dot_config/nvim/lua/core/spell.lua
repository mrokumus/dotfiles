-- Spell-checking for English + Turkish with a VS Code-like UX:
--   - Undercurl highlight that survives colorscheme changes
--   - Auto-enable on prose filetypes only (markdown, gitcommit, text, tex, norg)
--   - On-hover popup with top suggestions
--   - <leader>z picker, <C-l> quick-fix in insert mode
--
-- Usage: add `require("spell")` to your init.lua (no setup() call needed).
--
-- Daily commands:
--   ]s / [s        jump to next / previous misspelling
--   z= / 1z=       suggestion menu / replace with top suggestion
--   <C-x>s         insert-mode completion of spell suggestions
--   <leader>z      picker for word under cursor
--   <leader>zg     add word to personal dictionary
--   <leader>zw     mark word as wrong
--   <leader>zt     toggle spell on current buffer
--   <C-l>          (insert mode) fix the previous misspelling

-----------------------------------------------------------------------------
-- 1. Options
-----------------------------------------------------------------------------

vim.opt.spelllang = { "en", "tr" }
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/custom.utf-8.add"

-- Make sure the spellfile directory exists so `zg` doesn't error out
local spell_dir = vim.fn.stdpath("config") .. "/spell"
if vim.fn.isdirectory(spell_dir) == 0 then
	vim.fn.mkdir(spell_dir, "p")
end

-- Drives the CursorHold popup below. If you already set updatetime elsewhere,
-- delete this line or lower the number further.
vim.opt.updatetime = 500

-----------------------------------------------------------------------------
-- 2. Highlights — clean undercurl, no background overrides
-----------------------------------------------------------------------------

local function apply_spell_highlights()
	vim.cmd([[
    hi clear SpellBad
    hi clear SpellCap
    hi clear SpellRare
    hi clear SpellLocal
    hi SpellBad   cterm=undercurl gui=undercurl guisp=#ff5370
    hi SpellCap   cterm=undercurl gui=undercurl guisp=#ffcb6b
    hi SpellRare  cterm=undercurl gui=undercurl guisp=#c792ea
    hi SpellLocal cterm=undercurl gui=undercurl guisp=#82aaff
  ]])
end

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("SpellHighlights", { clear = true }),
	callback = apply_spell_highlights,
})

-- Apply now in case the colorscheme was loaded before this file ran
apply_spell_highlights()

-----------------------------------------------------------------------------
-- 3. Enable spell only for prose filetypes
-----------------------------------------------------------------------------

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("SpellFiletypes", { clear = true }),
	pattern = { "markdown", "gitcommit", "text", "tex", "norg" },
	callback = function()
		vim.opt_local.spell = true
	end,
})

-----------------------------------------------------------------------------
-- 4. Keymaps
-----------------------------------------------------------------------------

-- <leader>z : picker of suggestions for word under cursor
vim.keymap.set("n", "<leader>z", function()
	local word = vim.fn.expand("<cword>")
	if word == "" then
		return
	end
	local suggestions = vim.fn.spellsuggest(word, 10)
	if #suggestions == 0 then
		vim.notify("No suggestions for: " .. word, vim.log.levels.INFO)
		return
	end
	vim.ui.select(suggestions, { prompt = "→ " .. word }, function(choice)
		if choice then
			vim.cmd("normal! ciw" .. choice)
		end
	end)
end, { desc = "Spell: suggest for word under cursor" })

-- Convenience wrappers so muscle memory stays under <leader>z*
vim.keymap.set("n", "<leader>zg", "zg", { desc = "Spell: add word to dictionary" })
vim.keymap.set("n", "<leader>zw", "zw", { desc = "Spell: mark word as wrong" })

-- <leader>zt : toggle spell on the current buffer
vim.keymap.set("n", "<leader>zt", function()
	vim.opt_local.spell = not vim.opt_local.spell:get()
	vim.notify("Spell: " .. (vim.opt_local.spell:get() and "on" or "off"))
end, { desc = "Spell: toggle" })

-- Insert mode: <C-l> fixes the previous misspelling with the top suggestion
-- without breaking your flow
vim.keymap.set("i", "<C-l>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { desc = "Spell: fix previous misspelling" })

-----------------------------------------------------------------------------
-- 5. Auto-popup of suggestions on cursor hold (VS Code-like hover)
-----------------------------------------------------------------------------

vim.api.nvim_create_autocmd("CursorHold", {
	group = vim.api.nvim_create_augroup("SpellHoverPopup", { clear = true }),
	callback = function()
		if not vim.wo.spell then
			return
		end
		local word = vim.fn.expand("<cword>")
		if word == "" or vim.fn.spellbadword(word)[1] == "" then
			return
		end

		local suggestions = vim.fn.spellsuggest(word, 5)
		if #suggestions == 0 then
			return
		end

		local lines = { " Suggestions for '" .. word .. "':", "" }
		for i, s in ipairs(suggestions) do
			table.insert(lines, ("  %d. %s"):format(i, s))
		end
		table.insert(lines, "")
		table.insert(lines, " <leader>z pick · zg accept · zw reject")

		local width = 0
		for _, l in ipairs(lines) do
			width = math.max(width, #l)
		end

		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
		vim.bo[buf].modifiable = false
		vim.bo[buf].bufhidden = "wipe"

		local win = vim.api.nvim_open_win(buf, false, {
			relative = "cursor",
			row = 1,
			col = 0,
			width = width + 2,
			height = #lines,
			border = "rounded",
			style = "minimal",
			focusable = false,
			noautocmd = true,
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter", "BufLeave" }, {
			once = true,
			callback = function()
				pcall(vim.api.nvim_win_close, win, true)
			end,
		})
	end,
})
