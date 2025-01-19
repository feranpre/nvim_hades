vim.api.nvim_create_user_command("MdNumberHeadings", require("hades.utils.utils").md_number_headings, {})
vim.api.nvim_create_user_command(
  "MdGenerateTOC",
  function(opts)
    require("hades.utils.utils").md_generate_toc(tonumber(opts.args) or nil)
  end,
  { nargs = "?" } -- Allow an optional argument
)

vim.api.nvim_create_user_command("MdJumpToTOCLink", require("hades.utils.utils").md_jump_to_toc_link, {})
