-- TODO: haciendo los fold, quiero hacer un fold que abra/cierre los de nivel 1,
-- nivel 2 y nivel 3
--
-- CREDIT: https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/config/keymaps.lua
--
local M = {}

function M.load_colorscheme(opts)
  if type(opts.colorscheme) == "function" then
    opts.colorscheme()
  else
    vim.cmd.colorscheme(opts.colorscheme)
  end
end

function M.load_color_highlights(opts)
  if not opts.colors.highlight then
    return
  end

  local hl = opts.colors.highlight
  for group, settings in pairs(hl) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end
return M
