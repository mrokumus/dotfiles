return {
    {
        "Shatur/neovim-ayu",
        lazy = false, -- load during startup
        priority = 1000, -- load before others
        config = function()
            require("ayu").setup({
                mirage = false, -- false = dark; true = mirage
                overrides = {},
            })

            local ok = pcall(vim.cmd, "colorscheme ayu-dark")
            if not ok then
                vim.api.nvim_create_autocmd("User", {
                    pattern = "LazyDone",
                    once = true,
                    callback = function()
                        pcall(vim.cmd, "colorscheme ayu-dark")
                    end,
                })
            end
        end,
    },

    { "nvim-tree/nvim-web-devicons", lazy = true },
    { "nvim-mini/mini.nvim",         version = false },
    { "nvim-lualine/lualine.nvim",   event = "VeryLazy", opts = { options = { theme = "auto" } } },
}
