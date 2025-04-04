return {
  { -- preview equations
    "jbyuki/nabla.nvim",

    enabled = true,
    config = function()
      require"nabla".enable_virt({
        autogen = true, -- auto-regenerate ASCII art when exiting insert mode
        silent = true,     -- silents error messages
      })
    end,
    keys = {
      {
        -- "<leader>qm", ':lua require"nabla".toggle_virt()<cr>', desc = "toggle [m]ath equations",
        "<leader>p", ':lua require("nabla").popup()<cr>', desc = "asdf",
      },
    },
  },
}
