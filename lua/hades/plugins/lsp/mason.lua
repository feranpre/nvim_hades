return {
    "mason-org/mason.nvim",
    dependencies = {
        { "williamboman/mason-lspconfig.nvim" },
        { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    },
    config = function()
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                },
            },
        })

        require("mason-lspconfig").setup({
            automatic_installation = true,
            ensure_installed = {
                "lua_ls",
            },
        })
        require("mason-tool-installer").setup({
            ensure_installed = {
                "black",
                "stylua",
                -- "shfmt",
                -- "isort",
            },
        })
    end,
}
