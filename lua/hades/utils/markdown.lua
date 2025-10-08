local function md_to_pdf()
  print("convirtiendo a pdf")
end

vim.api.nvim_create_autocmd("md_to_pdf", {
  pattern = "*.md",
  callback = md_to_pdf,
})
