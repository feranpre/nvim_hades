return {
  {
    "echasnovski/mini.comment",
    enabled = true,
    version = "*",
    config = function()
      require("mini.comment").setup()
      -- require("mini.comment").setup({
      --   options = {
      --     ignore_blank_lien = false, -- dont comment blank lines
      --   }
      -- })
    end,
  },
}
