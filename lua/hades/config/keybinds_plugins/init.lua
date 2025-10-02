local path = vim.fn.stdpath("config") .. "/lua/hades/config/keybinds_plugins"
-- print(path)

for _, file in ipairs(vim.fn.readdir(path)) do
  if file:sub(-4) == ".lua" and file ~= "init.lua" then
    local module = "hades.config.keybinds_plugins." .. file:sub(1, -5)
    require(module)
  end
end
