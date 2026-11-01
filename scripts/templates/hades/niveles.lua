--[[
niveles.lua — títulos sin saltos de nivel

Algunas funciones (p. ej. las de feR) escriben títulos con un nivel fijo
(###), que debajo de un título # del documento dejan un salto de nivel:
la numeración sale "1.0.1" y pandoc no los incluye en el índice.

Este filtro ajusta cada título para que quede como mucho un nivel por debajo
de su título padre, respetando la estructura relativa:

  #  Descripción          ->  #   (1)
  ###  mpg                ->  ##  (1.1)
  #### Normalidad         ->  ### (1.1.1)
  ###  cyl                ->  ##  (1.2)

Además, los títulos que escribe un bloque de código (results = 'asis')
pueden quedar dentro del <div class="cell"> del bloque (p. ej. si el bloque
tiene opciones que knitr no conoce, como unit = 'cm'), y pandoc no incluye
en el índice los títulos que están dentro de un div. Esos divs se deshacen.

Los documentos sin saltos de nivel ni títulos dentro de bloques no cambian.
]]

local CELL_CLASSES = { cell = true, ["cell-output-display"] = true, ["cell-output"] = true }

local function is_cell(div)
  for _, c in ipairs(div.classes) do
    if CELL_CLASSES[c] then
      return true
    end
  end
  return false
end

local function has_header(blocks)
  local found = false
  pandoc.Blocks(blocks):walk({
    Header = function()
      found = true
    end,
  })
  return found
end

-- Bloques de salida con títulos: su contenido pasa al nivel del documento
local function unwrap_cells(doc)
  return doc:walk({
    Div = function(div)
      if is_cell(div) and has_header(div.content) then
        return div.content
      end
    end,
  })
end

function Pandoc(doc)
  doc = unwrap_cells(doc)

  -- pila de títulos abiertos: { original, nuevo }
  local stack = {}

  return doc:walk({
    traverse = "topdown",
    Header = function(h)
      while #stack > 0 and stack[#stack].original >= h.level do
        table.remove(stack)
      end

      local parent = stack[#stack]
      local level = (parent and parent.new or 0) + 1
      level = math.min(level, h.level)

      table.insert(stack, { original = h.level, new = level })

      if level ~= h.level then
        h.level = level
        return h
      end
    end,
  })
end
