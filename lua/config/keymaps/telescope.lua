local map = vim.keymap.set

map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {
    desc = "[f]ind [f]iles",
})

map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {
    desc = "[f]ind by [g]rep",
})

map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {
    desc = "[f]ind [b]uffers",
})

map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", {
    desc = "[f]ind [h]elp",
})
