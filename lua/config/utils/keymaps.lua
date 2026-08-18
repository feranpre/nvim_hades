local M = {}

M.default_opts = {
	silent = true,
}

function M.map(mode, lhs, rhs, desc, opts)
	opts = vim.tbl_deep_extend("force", M.default_opts, opts or {})

	if desc then
		opts.desc = desc
	end

	vim.keymap.set(mode, lhs, rhs, opts)
end

function M.buffer(buf, mode, lhs, rhs, desc, opts)
	opts = vim.tbl_deep_extend("force", {
		buffer = buf,
	}, opts or {})

	M.map(mode, lhs, rhs, desc, opts)
end

return M
