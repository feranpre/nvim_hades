local theme = require("config.theme")

-- return {
--     {
--         "Mofiqul/dracula.nvim",
--
--         lazy = false,
--         priority = 1000,
--
--         config = function()
--             if theme.current == "dracula" then
--                 vim.cmd.colorscheme("dracula")
--             end
--         end,
--     },
-- }


return {
    "folke/tokyonight.nvim",

    lazy = false,
    priority = 1000,

    config = function()
        if theme.current == "tokyonight-storm" then
            vim.cmd.colorscheme("tokyonight-storm")
        end
    end,
}
