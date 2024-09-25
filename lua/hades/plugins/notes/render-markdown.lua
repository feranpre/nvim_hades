return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    file_types = { "markdown", "norg", "rmd", "org", "quarto" },
    checkbox = {
      enabled = true,
      position = "inline",
      unchecked = {
        icon = " ",
        highlight = "RenderMarkdownUnchecked",
      },
      checked = {
        -- Replaces '[x]' of 'task_list_marker_checked'
        icon = " ",
        -- Highligh for the checked icon
        highlight = "RenderMarkdownChecked",
      },
      custom = {
        todo = { raw = "[.]", rendered = " " },
        not_happening = { raw = "[-]", rendered = "󰬅 " },
      },
    },
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
