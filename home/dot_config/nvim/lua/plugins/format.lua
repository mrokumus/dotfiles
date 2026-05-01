return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        opts = {
            format_on_save = function(bufnr)
                -- disable for very large files
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
                if ok and stats and stats.size > 512 * 1024 then return end
                return { timeout_ms = 1000, lsp_fallback = true }
            end,
            formatters_by_ft = {
                lua = { "stylua" },
                javascript = { "prettierd", "prettier" },
                typescript = { "prettierd", "prettier" },
                typescriptreact = { "prettierd", "prettier" },
                json = { "prettierd", "prettier" },
                css = { "prettierd", "prettier" },
                html = { "prettierd", "prettier" },
                go = { "gofumpt", "goimports" },
                php = { "pint", "php_cs_fixer" },
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                typescriptreact = { "eslint_d" },
            }
            vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
                callback = function() require("lint").try_lint() end,
            })
        end
    },

    -- QoL
    { "numToStr/Comment.nvim",     event = "VeryLazy",    opts = {} },
    { "echasnovski/mini.surround", event = "VeryLazy",    opts = {} },
    { "windwp/nvim-autopairs",     event = "InsertEnter", opts = {} },
    {
        url = "https://codeberg.org/andyg/leap.nvim",
        event = "VeryLazy",
        config = function()
            vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
            vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
            vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
        end
    },
}
