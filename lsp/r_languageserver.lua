return {
  -- Command and arguments to start the server.
  cmd = { "R", "LANGSERVER_MODE=1 --slave", "-e", "languageserver::run()"},

  -- Filetypes to automatically attach to.
  filetypes = { "R", "r", "rmd" },

  -- Sets the "root directory" to the parent directory of the file in the
  -- current buffer that contains either a ".Rproject" or a ".lintr"
  root_markers = {".Rproject", ".lintr"},
  -- root_dir = require("lspconfig").util.root_pattern(".git", ".Rproj", ".Rprofile", ".Renviron"),

  -- Specific settings to send to the server. The schema for this is
  -- defined by the server. For example the schema for lua-language-server
  -- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {
    r = {
      lsp = {
        diagnostics       = true,   -- activar linting con lintr
        debug             = true,  -- verbose/debug LSP
        snippet_support   = true,   -- soporta snippets en su
        rich_documentation = true,  -- formateo Markdown enriquecido
        max_completions   = 500,    -- límite de ítems en autocompletar
        lint_cache        = true,  -- cache de lint (lintr)
      },
      sessionWatcher = true,
    }
  }
}
