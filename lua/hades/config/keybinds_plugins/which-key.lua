wk = require("which-key")

wk.register({
  g = {
    ["<C-a>"] = {"inc [++] number"},
    ["<C-x>"] = {"ded [--] number"}
  }
}, {mode = "x"}
)
