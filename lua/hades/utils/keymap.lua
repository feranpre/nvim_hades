local M = {}

M.opts = { noremap = true, silent = true, desc = nil }

function M.keymap(mode, keys, func, opts, desc)
  if desc then
    opts.desc = desc
  end
  vim.keymap.set(mode, keys, func, opts)
end

function M.keymap_buffer(buffer, mode, keys, func, opts, desc)
  if desc then
    opts.desc = desc
  end
  if buffer then
    opts.buffer = buffer
  end
  vim.keymap.set(mode, keys, func, opts)
end

return M
