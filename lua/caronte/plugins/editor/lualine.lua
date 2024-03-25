return { -- statusline
  -- PERF: I found this to slow down the editor
  "nvim-lualine/lualine.nvim",
  enabled = false,
  config = function()
    local function macro_recording()
      local reg = vim.fn.reg_recording()
      if reg == "" then
        return ""
      end
      return "📷[" .. reg .. "]"
    end

    ---@diagnostic disable-next-line: undefined-field
    require("lualine").setup({
      options = {
        section_separators = "",
        component_separators = "",
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode", macro_recording },
        lualine_b = { "branch", "diff", "diagnostics" },
        -- lualine_b = {},
        lualine_c = { "searchcount" },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "nvim-tree" },
    })
  end,
}
