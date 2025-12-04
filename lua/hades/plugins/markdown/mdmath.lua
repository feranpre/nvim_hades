return {
    'Thiago4532/mdmath.nvim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      filetypes = {"markdown", "quarto"}

    }
}

-- :MdMath enable: Enable the plugin for the current buffer
-- :MdMath disable: Disable the plugin for the current buffer
-- :MdMath clear: Refresh all equations
-- :MdMath build: Build the node.js server

