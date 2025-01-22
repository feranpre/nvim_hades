vim.api.nvim_create_autocmd({ "FileType", "VimEnter", "BufEnter" }, {
  desc = "HADES file binds",
  pattern = { "r", "python", "quarto", "markdown" },
  callback = function(ev)
    --
    -- MOLTEN
    --
    if IsModuleAvailable("MoltenInfo") then
      if DEBUG then
        print("Molten - keys loaded")
      end
      require("hades.config.keybinds_molten").load_keys(ev)
    else
      if DEBUG then
        print("Molten - keys NOT loaded")
      end
    end

    --
    -- SLIME
    --
    if IsModuleAvailable("SlimeConfig") then
      if DEBUG then
        print("Slime - keys loaded")
      end
      require("hades.config.keybinds_slime").load_keys(ev)
    else
      if DEBUG then
        print("Slime - keys NOT loaded")
      end
    end

    require("hades.config.keybinds_r").load_keys(ev)
  end,
})

vim.api.nvim_create_autocmd({ "FileType", "VimEnter", "BufEnter" }, {
  desc = "molten file binds",
  pattern = { "quarto" },
  callback = function(ev)
    if IsModuleAvailable("quarto") then
      if DEBUG then
        print("Quarto - keys loaded")
      end
      require("hades.config.keybinds_quarto").load_keys(ev)
    else
      if DEBUG then
        print("Quarto - keys NOT loaded")
      end
    end
  end,
})
