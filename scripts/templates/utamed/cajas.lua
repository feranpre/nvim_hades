-- cajas.lua
-- ---------------------------------------------------------------
-- Filtro de pandoc que traduce los bloques "fenced div" de Markdown
--   ::: {.resumen}
--   contenido...
--   :::
-- en entornos LaTeX
--   \begin{resumen}
--   contenido...
--   \end{resumen}
-- definidos como tcolorbox en template.tex.
--
-- Se activa automáticamente desde utamed_pdf.py con:
--   --lua-filter=cajas.lua
--
-- Clases admitidas (deben coincidir con los \newtcolorbox del
-- template): resumen, ejemplo, definicion, nota, formuladestacada,
-- competencias, cajatitulo
-- ---------------------------------------------------------------

local CAJAS = {
  resumen = true,
  ejemplo = true,
  definicion = true,
  nota = true,
  formuladestacada = true,
  competencias = true,
  cajatitulo = true,
}

function Div(el)
  if FORMAT:match("latex") then
    for _, clase in ipairs(el.classes) do
      if CAJAS[clase] then
        local inicio = pandoc.RawBlock("latex", "\\begin{" .. clase .. "}")
        local fin = pandoc.RawBlock("latex", "\\end{" .. clase .. "}")
        local bloques = { inicio }
        for _, b in ipairs(el.content) do
          table.insert(bloques, b)
        end
        table.insert(bloques, fin)
        return bloques
      end
    end
  end
  return nil
end
