return { -- terminal
  "akinsho/toggleterm.nvim",
  enabled = true,
  opts = {
    -- size = 20 | function(term)
    --   if term.direction == 'horizontal' then
    --     return 15
    --   elseif term.direction == 'vertical' then
    --     return vim.o.columns * 0.4
    --   end
    -- end,
    -- -- open_mapping = [[<c-\>]],
    direction = "horizontal",
    start_in_insert = true,
  },
}
