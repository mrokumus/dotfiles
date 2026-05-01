return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        local mason = require("mason")
        local mason_lsp = require("mason-lspconfig")

        mason.setup()

        mason_lsp.setup({
            ensure_installed = { "gopls", "ts_ls", "intelephense" },
            -- Disable automatic setup since we're using the new API
            automatic_installation = false,
        })

        local on_attach = function(client, bufnr)
            local bufmap = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, {
                    buffer = bufnr,
                    desc = desc
                })
            end

            bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
            bufmap("n", "gr", vim.lsp.buf.references, "References")
            bufmap("n", "K", vim.lsp.buf.hover, "Hover doc")
            bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
            bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        end

        local capabilities = vim.lsp.protocol.make_client_capabilities()

        -- Server configurations with Mason paths
        local servers = {
            gopls = {
                cmd = { vim.fn.stdpath("data") .. "/mason/bin/gopls" },
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                root_markers = { "go.work", "go.mod", ".git" },
            },
            ts_ls = {
                cmd = { vim.fn.stdpath("data") .. "/mason/bin/typescript-language-server", "--stdio" },
                filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
            },
            intelephense = {
                cmd = { vim.fn.stdpath("data") .. "/mason/bin/intelephense", "--stdio" },
                filetypes = { "php" },
                root_markers = { "composer.json", ".git" },
            },
        }

        for name, config in pairs(servers) do
            -- Register the LSP configuration
            vim.lsp.config(name, {
                cmd = config.cmd,
                filetypes = config.filetypes,
                root_markers = config.root_markers,
                on_attach = on_attach,
                capabilities = capabilities,
            })

            -- Enable the LSP for matching filetypes
            vim.api.nvim_create_autocmd("FileType", {
                pattern = config.filetypes,
                callback = function(args)
                    vim.lsp.enable(name, { bufnr = args.buf })
                end,
            })
        end
    end
}
