return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            ensure_installed = {
                "lua",
                "go",
                "php",
                "javascript",
                "typescript",
                "tsx",
                "json",
                "yaml",
                "html",
                "css",
            },
            auto_install = false,
        })
    end
}
