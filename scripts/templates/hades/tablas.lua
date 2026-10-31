--[[
tablas.lua — numeración correcta de las tablas en PDF

longtable incrementa el contador de tablas aunque la tabla no tenga título,
así que tras varias tablas sin título (p. ej. las de feR) la primera tabla
con título sale como "Tabla 7". Este filtro guarda el contador antes de cada
tabla sin título y lo restaura después: funciona con cualquier versión de
pandoc (>= 3.8 ya lo evita por su cuenta) y también dentro de las tablas
flotantes de quarto.
]]

local function has_caption(tbl)
  local long = tbl.caption and tbl.caption.long
  return long ~= nil and #long > 0
end

function Table(tbl)
  if not FORMAT:match("latex") or has_caption(tbl) then
    return nil
  end

  return {
    pandoc.RawBlock("latex", "{\\edef\\hadestablecount{\\the\\value{table}}% tabla sin título: no numerar"),
    tbl,
    pandoc.RawBlock("latex", "\\setcounter{table}{\\hadestablecount}}"),
  }
end
