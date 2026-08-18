local map = vim.keymap.set

local function show_messages()
    local messages = vim.fn.execute("messages")

    vim.cmd("botright new")

    local buf = vim.api.nvim_get_current_buf()

    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = "text"
    vim.bo[buf].modifiable = true

    local lines = vim.split(messages, "\n", {
        plain = true,
    })

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    vim.bo[buf].modifiable = false

    vim.cmd("normal! gg")
end

map("n", "<leader>E", show_messages, {
    desc = "[E]rrors/messages in buffer",
})
