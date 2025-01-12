-- To use this debug the command we need is
--
-- nvim -V9fold_debug.log
--

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "foldlevel",
  callback = function()
    print("foldlevel changed to:", vim.o.foldlevel)
    vim.cmd("echohl WarningMsg | echo 'Set by:' | debug echohl None")
  end,
})
