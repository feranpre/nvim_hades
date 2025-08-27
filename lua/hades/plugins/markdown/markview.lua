return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "OXY2DEV/markview.nvim" },
  lazy = false,
  priority = 40,

  config = function()
    local presets = require("markview.presets");

    require("markview").setup({
      markdown = {
        -- headings = presets.headings.slanted
        headings = presets.headings.glow
      }
    });
  vim.api.nvim_set_hl(0, 'MarkviewHeading1', { bg = '#cb7676', fg = '#402626', italic = false })
  vim.api.nvim_set_hl(0, 'MarkviewHeading2', { bg = '#c99076', fg = '#66493c', italic = false })
  vim.api.nvim_set_hl(0, 'MarkviewHeading3', { bg = '#80a665', fg = '#3d4f2f', italic = false })
  vim.api.nvim_set_hl(0, 'MarkviewHeading4', { bg = '#4c9a91', fg = '#224541', italic = false })
  vim.api.nvim_set_hl(0, 'MarkviewHeading5', { bg = '#6893bf', fg = '#2b3d4f', italic = false })
  vim.api.nvim_set_hl(0, 'MarkviewHeading6', { bg = '#d3869b', fg = '#6b454f', italic = false })
  end,

}
