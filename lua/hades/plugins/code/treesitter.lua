local configs = function()
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
      "python",
      "markdown",
      "markdown_inline",
      "julia",
      "mermaid",
    },
    auto_install = true,
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
    auto_tag = { enable = true },
    -- MINI.COMMENT --
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.inner",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.inner",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
    },
    modules = {},
    ignore_install = {},
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  enabled = true,
  build = ":TSUpdate",
  lazy = false,
  config = configs,
}
