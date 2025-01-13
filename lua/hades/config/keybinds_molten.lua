vim.api.nvim_create_autocmd({ "FileType", "VimEnter", "BufEnter" }, {
  desc = "molten file binds",
  -- pattern = { "r", "quarto" },
  pattern = { "python", "quarto" },
  callback = function(ev)
    local opts = { noremap = true, silent = true, desc = nil }
    local keymap_buffer = require("hades.misc.utils").keymap_buffer
    local key_or_clue = require("hades.misc.utils").key_or_clue
    local isModuleAvailable = require("hades.misc.utils").isModuleAvailable

    keymap_buffer(ev.buf, "n", "<C-CR>", "<cmd>MoltenEvaluateLine<CR>", opts, "(Molten) Evaluate line")
  end,
})
