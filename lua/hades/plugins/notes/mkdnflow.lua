return {
  'jakewvincent/mkdnflow.nvim',
  enabled = false,
  config = function()
    local mkdnflow = require('mkdnflow')
    mkdnflow.setup({})
  end,
}
