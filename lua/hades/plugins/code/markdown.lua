return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    file_types = { "markdown", "norg", "rmd", "org", "quarto" },
  },
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  ft = { "markdown", "norg", "rmd", "org", "quarto" },
  config = function(_, opts)
    require("render-markdown").setup(opts)
    -- LazyVim.toggle.map("<leader>um", {
    --   name = "Render Markdown",
    --   get = function()
    --     return require("render-markdown.state").enabled
    --   end,
    --   set = function(enabled)
    --     local m = require("render-markdown")
    --     if enabled then
    --       m.enable()
    --     else
    --       m.disable()
    --     end
    --   end,
    -- })
  end,
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
}
