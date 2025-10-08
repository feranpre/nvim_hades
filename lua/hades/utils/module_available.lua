local M = {}

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

return M
