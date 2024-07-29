return {
    'windwp/nvim-autopairs',
    enabled = false, 
    event = 'InsertEnter',
    opts = function()
      require('nvim-autopairs').setup {}
      require('nvim-autopairs').remove_rule '`'
    end,
}
