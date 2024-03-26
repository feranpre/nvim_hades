return {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = function()
      require('nvim-autopairs').setup {}
      require('nvim-autopairs').remove_rule '`'
    end,
}
