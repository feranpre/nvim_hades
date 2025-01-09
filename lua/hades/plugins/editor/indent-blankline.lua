configs = function()
  -- vim.cmd([[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
  -- vim.cmd([[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
  -- vim.cmd([[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
  -- vim.cmd([[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]])
  -- vim.cmd([[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
  -- vim.cmd([[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])

  local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
  }

  local hooks = require("ibl.hooks")

  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
  end)

  require("ibl").setup({
    indent = { highlight = highlight },
    -- space_char_blankline = ' ',
    -- show_trailing_blankline_indent = false,
    -- show_current_context = true,
    -- show_current_context_start = true,
    -- char_highlight_list = {
    --   'IndentBlanklineIndent1',
    --   'IndentBlanklineIndent2',
    --   'IndentBlanklineIndent3',
    --   'IndentBlanklineIndent4',
    --   'IndentBlanklineIndent5',
    --   'IndentBlanklineIndent6',
    -- },
    -- indent_blankline_filetype_exclude = {
    --   'help',
    --   'alpha',
    --   'dashboard',
    --   'neo-tree',
    --   'Trouble',
    --   'lazy',
    --   'mason',
    --   'notify',
    --   'toggleterm',
    --   'lazyterm',
    -- },
  })
end

return {
  "lukas-reineke/indent-blankline.nvim",
  lazy = false,
  config = configs,
}
