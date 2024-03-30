local M = {}

function M.spin_r(file_path, file_format)
  if not file_path then
    print("Error: File path not provided.")
    return
  end

  local output_dir = vim.fn.fnamemodify(file_path, ":p:h") -- Current file's directory
  local file_name = vim.fn.fnamemodify(file_path, ":t:r")
  local file_name_base = vim.fn.fnamemodify(file_path, ":t")

  print("KNITTING file:" .. file_name_base)
  if file_name == "" then
    print("Error: Invalid file name.")
    return
  end

  -- Check if the file extension is .R or .Rmd
  local extension = vim.fn.fnamemodify(file_path, ":e")
  if extension ~= "R" and extension ~= "Rmd" then
    print("Error: Invalid file extension. Must be .R or .Rmd.")
    return
  end

  if file_format ~= "pdf" and file_format ~= "html" then
    print("Error: Invalid file format. Must be 'pdf' or 'html'.")
    return
  end

  -- Define the command to generate the .md file using knitr::spin()
  local spin_command = string.format("Rscript -e 'knitr::spin(\"%s\", knit=TRUE)'", file_path)
  -- local spin_command = string.format('Rscript -e \'knitr::spin("%s", knit = FALSE, format = "md")\'', file_name_base)
  print("SPIN --> " .. spin_command)

  -- Run the spin command to generate .md file
  os.execute(spin_command)

  -- Define the path to the generated .md file
  -- local md_file = output_dir .. "/" .. file_name .. ".md"
  local html_file = output_dir .. "/" .. file_name .. "." .. file_format
  -- Define the command to render .md file to HTML using rmarkdown::render()
  local render_command = ""
  local md_file = output_dir .. "/" .. file_name .. ".md"
  if file_format == "html" then
    render_command = string.format("Rscript -e 'rmarkdown::render(\"%s\")'", md_file, output_dir, file_name)
  end
  if file_format == "pdf" then
    render_command = string.format(
      'Rscript -e \'rmarkdown::render("%s", output_format = "pdf_document")\'',
      -- 'Rscript -e \'rmarkdown::render("%s", output_format = rmarkdown::pdf_document(toc = TRUE, latex_engine = "xelatex"))\'',
      md_file,
      output_dir,
      file_name
    )
  end

  -- Run the render command to generate HTML file
  os.execute(render_command)

  print("RENDER --> " .. render_command)
  print("Output file generated successfully!" .. html_file)

  -- After rendering HTML, delete the .md file
  os.remove(md_file)
  print("Temporal file deleted." .. md_file)
end

return M
