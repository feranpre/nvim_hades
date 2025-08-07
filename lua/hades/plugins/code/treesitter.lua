---@diagnostic disable: missing-fields
return {
    "nvim-treesitter/nvim-treesitter",
    enabled = true,
    build = ":TSUpdate",
    lazy = false,
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "lua",
                "regex",
                "json",
                "html",
                "css",
                "bash",
                "yaml",
                "vim",
                "vimdoc",
                "r",
                "rnoweb",
                "python",
                "latex",
                "markdown",
                "markdown_inline",
                -- "julia",
                "mermaid",
            },
            auto_install = true,
            sync_install = true,
            highlight = {
                enable = true,
                -- disable parsing for very large files
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
            },
            indent = { enable = true },
            auto_tag = { enable = true },
            -- incremental selection based on context
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<Enter>", -- set to `false` to disable one of the mappings
                    node_incremental = "<Enter>",
                    scope_incremental = false,
                    node_decremental = "<Backspace>",
               },
            },
      playgroud = { enable = true,},
        })
    end,
}
