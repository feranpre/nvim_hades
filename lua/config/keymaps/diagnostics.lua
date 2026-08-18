local map = vim.keymap.set

map("n", "<leader>dd", vim.diagnostic.open_float, {
	desc = "[d]iagnostic [d]etails",
})

map("n", "<leader>dn", function()
	vim.diagnostic.goto_next()
end, {
	desc = "[d]iagnostic [n]ext",
})

map("n", "<leader>dp", function()
	vim.diagnostic.goto_prev()
end, {
	desc = "[d]iagnostic [p]revious",
})

map("n", "<leader>dq", vim.diagnostic.setloclist, {
	desc = "[d]iagnostic [q]uickfix list",
})
