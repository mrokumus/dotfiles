return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "frappe",
				transparent_background = false,
				term_colors = true,
				styles = {
					comments = { "italic" },
					keywords = { "italic" },
				},
				integrations = {
					telescope = true,
					treesitter = true,
					gitsigns = true,
					mason = true,
					lualine = true,
					native_lsp = {
						enabled = true,
						underlines = {
							errors = { "underline" },
							hints = { "underline" },
							warnings = { "underline" },
							information = { "underline" },
						},
					},
				},
			})
			vim.cmd.colorscheme("catppuccin-frappe")
		end,
	},
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				theme = "auto",
				component_separators = "│",
				section_separators = "",
			},
		},
	},
}
