local M = {}
M.opts = { noremap = true, silent = true, desc = nil }

function M.unbind_key(mode, key, buffer)
  if buffer then
    -- Check for buffer-local keymap
    local keymaps = vim.api.nvim_buf_get_keymap(buffer, mode)

    -- vim.api.nvim_buf_del_keymap(buffer, mode, key)
    for _, keymap in ipairs(keymaps) do
      if keymap.lhs == key then
        -- Unbind the key if it exists
        vim.api.nvim_buf_del_keymap(buffer, mode, key)
        print("Buffer-local keybinding for '" .. key .. "' in mode '" .. mode .. "' was removed.")
        return
      end
    end
    print("Buffer-local keybinding for '" .. key .. "' in mode '" .. mode .. "' does not exist.")
  else
    -- Check for global keymap
    local keymaps = vim.api.nvim_get_keymap(mode)
    for _, keymap in ipairs(keymaps) do
      if keymap.lhs == key then
        -- Unbind the key if it exists
        vim.api.nvim_del_keymap(mode, key)
        print("Global keybinding for '" .. key .. "' in mode '" .. mode .. "' was removed.")
        return
      end
    end
    print("Global keybinding for '" .. key .. "' in mode '" .. mode .. "' does not exist.")
  end
end

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

function M.isModuleAvailable(plugin, debug)
  if debug == nil then
    debug = false
  end
  local req_present = pcall(require, plugin)
  -- local command_present = vim.fn.executable(plugin) == 1
  local command_present = vim.fn.exists(":" .. plugin) > 0
  if debug then
    print(plugin)
    print("   REQUIRE " .. tostring(req_present))
    print("   COMMAND " .. tostring(command_present))
  end
  return (req_present or command_present)
end

function M.key_or_clue(mode, key, description)
  if pcall(require, "which-key") then
    -- Register keybinding with which-key
    local wk = require("which-key")
    wk.add({ key, desc = description, mode = mode })
  elseif pcall(require, "mini.clue") then
    -- Add clue to mini.clues
    local clues = require("mini.clue")
    local new_clue = { mode = mode, keys = key, desc = description }

    -- Append clue to existing ones
    clues.config.clues = vim.list_extend(clues.config.clues or {}, { new_clue })

    -- Reinitialize mini.clues with updated clues
    clues.setup({
      clues = clues.config.clues,
    })
  else
    vim.notify("Neither 'which-key' nor 'mini.clues' is loaded", vim.log.levels.WARN)
  end
end

return M
