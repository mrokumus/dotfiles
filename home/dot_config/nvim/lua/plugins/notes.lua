return {
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		ft = "markdown",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			workspaces = {
				{
					name = "notes",
					path = "~/notes",
				},
			},
			notes_subdir = "inbox",
			new_notes_location = "notes_subdir",
			daily_notes = {
				folder = "daily",
				date_format = "%Y-%m-%d",
				template = nil,
			},

			attachments = {
				img_folder = "attachments",
			},
			disable_frontmatter = false,
			completion = {
				nvim_cmp = false,
				min_chars = 2,
			},

			picker = {
				name = "telescope.nvim",
			},

			wiki_link_func = function(opts)
				return require("obsidian.util").wiki_link_id_prefix(opts)
			end,
			ui = { enable = false },
		},
	},
}
