-- send code from python/r/qmd documets to a terminal or REPL
-- like ipython, R, bash
return {
  "jpalardy/vim-slime",
  -- 'chadvoegele/nvim-slime',
  enabled = true,
  init = function()
    -- vim.g.slime_target = "neovim"
    vim.g.slime_no_mappings = 1

    -- vim.g.slime_target = "tmux"
    -- MUST be "neovim" if using quarto
    vim.g.slime_target = "neovim"

    vim.g.slime_default_config = {
      socket_name = "default",
      target_pane = "{last}",
    }

    vim.g.slime_python_ipython = 1
    -- vim.g.slime_bracketed_paste = 1
    vim.g.slime_cell_delimiter = "# %%"
    -- require('which-key').register({
    --   ['<leader>cm'] = { mark_terminal, 'mark terminal' },
    --   ['<leader>cs'] = { set_terminal, 'set terminal' },
    -- })
  end,
  config = function()
    vim.g.slime_suggest_default = true
  end,
}
