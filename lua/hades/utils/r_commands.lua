local M = {}
-- function M.r_to_html(file_path)
--   pandoc +RTS -K512m -RTS 10_analisis_bruto.knit.md --to html4 --from markdown+autolink_bare_uris+tex_math_single_backslash --output 10_analisis_bruto.html --lua-filter /usr/lib/R/library/rmarkdown/rmarkdown/lua/pagebreak.lua --lua-filter /usr/lib/R/library/rmarkdown/rmarkdown/lua/latex-div.lua --embed-resources --standalone --variable bs3=TRUE --section-divs --table-of-contents --toc-depth 4 --variable toc_float=1 --variable toc_selectors=h1,h2,h3,h4 --variable toc_collapsed=1 --variable toc_smooth_scroll=1 --variable toc_print=1 --template /usr/lib/R/library/rmarkdown/rmd/h/default.html --no-highlight --variable highlightjs=1 --number-sections --variable theme=bootstrap --mathjax --variable 'mathjax-url=https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML' --include-in-header /tmp/RtmpihXWTR/rmarkdown-strc5e72c9128d9.html
-- end
function M.rmarkdown_render(file_path)
  if not file_path then
    vim.notify("Error: File path not provided.")
    return
  end

  local file_name = vim.fn.fnamemodify(file_path, ":t:r")

  local spin_command = string.format("Rscript -e 'rmarkdown::render(\"%s\")' ", file_path)
  vim.fn.jobstart(spin_command, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        -- Log any stdout output for debugging or updates
        vim.notify("Output: " .. table.concat(data, "\n"), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        -- Display errors to the user
        vim.notify("Error: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify("Spin command OK " .. file_name, vim.log.levels.INFO)
      else
        vim.notify("Spin command ERROR " .. file_name, vim.log.levels.ERROR)
      end
    end,
  })
end

function M.spin_r(file_path, file_format)
  if not file_path then
    vim.notify("Error: File path not provided.")
    return
  end

  local output_dir = vim.fn.fnamemodify(file_path, ":p:h") -- Current file's directory
  local file_name = vim.fn.fnamemodify(file_path, ":t:r")
  local file_name_base = vim.fn.fnamemodify(file_path, ":t")

  local spin_command = string.format(
    'Rscript -e \'rmarkdown::render("%s", output_format = "%s")\' ',
    file_path,
    file_format .. "_document"
  )
  vim.fn.jobstart(spin_command, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        -- Log any stdout output for debugging or updates
        vim.notify("Output: " .. table.concat(data, "\n"), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        -- Display errors to the user
        vim.notify("Error: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify("Spin command OK " .. file_name, vim.log.levels.INFO)
      else
        vim.notify("Spin command ERROR " .. file_name, vim.log.levels.ERROR)
      end
    end,
  })
end

return M
