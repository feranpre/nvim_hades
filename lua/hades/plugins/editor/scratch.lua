return {
  "swaits/scratch.nvim",
  enabled = false,
  lazy = true,
  keys = {
    { "<leader>bs", "<cmd>Scratch<cr>", desc = "Scratch Buffer", mode = "n" },
    { "<leader>bS", "<cmd>ScratchSplit<cr>", desc = "Scratch Buffer (split)", mode = "n" },
  },
  cmd = {
    "Scratch",
    "ScratchSplit",
  },
  opts = {
    buffer_name = "_SCRATCH.R",
  },
}
