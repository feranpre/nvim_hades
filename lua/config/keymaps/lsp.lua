local map = vim.keymap.set

local function opts(desc)
    return {
        silent = true,
        desc = desc,
    }
end

-- Navigation
map("n", "<leader>ld", vim.lsp.buf.definition, opts("[d]efinition"))
map("n", "<leader>lD", vim.lsp.buf.declaration, opts("[D]eclaration"))
map("n", "<leader>lr", vim.lsp.buf.references, opts("[r]eferences"))
map("n", "<leader>li", vim.lsp.buf.implementation, opts("[i]mplementation"))
map("n", "<leader>lt", vim.lsp.buf.type_definition, opts("[t]ype definition"))

-- Information
map("n", "<leader>lh", vim.lsp.buf.hover, opts("[h]over"))
map("n", "<leader>ls", vim.lsp.buf.signature_help, opts("[s]ignature help"))

-- Actions
map("n", "<leader>la", vim.lsp.buf.code_action, opts("code [a]ction"))
map("n", "<leader>ln", vim.lsp.buf.rename, opts("re[n]ame"))

-- Workspace
map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, opts("[w]orkspace [a]dd"))
map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, opts("[w]orkspace [r]emove"))
map("n", "<leader>lwl", vim.lsp.buf.list_workspace_folders, opts("[w]orkspace [l]ist"))

-- Restart / info
map("n", "<leader>lR", "<cmd>lsp restart<CR>", opts("[R]estart LSP"))
map("n", "<leader>lI", "<cmd>LspInfo<CR>", opts("[I]nfo"))
