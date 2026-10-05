--[[
callouts.lua — cajas de aviso para la exportación con pandoc

Convierte en callouts:

  * Divs de Quarto:       ::: {.callout-note title="Opcional"} ... :::
  * Alertas de GitHub:    > [!NOTE]
                          > texto

Tipos: note, tip, warning, important, caution (y sus alias).

En LaTeX se usa el entorno `hadescallout` de hades.tex; en HTML un
<div class="callout callout-TIPO"> que estiliza hades.css.
]]

local TYPES = {
  note = { color = "hadesnote", title = "Nota" },
  tip = { color = "hadestip", title = "Consejo" },
  important = { color = "hadesimportant", title = "Importante" },
  warning = { color = "hadeswarning", title = "Atención" },
  caution = { color = "hadescaution", title = "Precaución" },
}

local ALIASES = {
  info = "note",
  hint = "tip",
  attention = "warning",
  danger = "caution",
  error = "caution",
}

-- Copia de una lista sin su primer elemento (List:slice no existe en
-- versiones antiguas de pandoc)
local function tail(list)
  local out = pandoc.List()
  for i = 2, #list do
    out:insert(list[i])
  end
  return out
end

local function normalize(kind)
  kind = kind:lower()
  kind = ALIASES[kind] or kind
  if TYPES[kind] then
    return kind
  end
  return nil
end

local function latex_escape(s)
  return (s:gsub("[\\{}$&#^_%%~]", function(c)
    if c == "\\" then
      return "\\textbackslash{}"
    elseif c == "^" then
      return "\\^{}"
    elseif c == "~" then
      return "\\~{}"
    end
    return "\\" .. c
  end))
end

local function build(kind, title_inlines, content)
  local spec = TYPES[kind]

  if FORMAT:match("latex") or FORMAT:match("beamer") then
    local title
    if title_inlines and #title_inlines > 0 then
      title = pandoc.write(pandoc.Pandoc({ pandoc.Plain(title_inlines) }), "latex")
    else
      title = latex_escape(spec.title)
    end
    title = title:gsub("%s+$", "")

    local blocks = { pandoc.RawBlock("latex", "\\begin{hadescallout}{" .. spec.color .. "}{" .. title .. "}") }
    for _, b in ipairs(content) do
      table.insert(blocks, b)
    end
    table.insert(blocks, pandoc.RawBlock("latex", "\\end{hadescallout}"))
    return blocks
  end

  if FORMAT:match("html") then
    local title = (title_inlines and #title_inlines > 0) and title_inlines or { pandoc.Str(spec.title) }
    local header = pandoc.Div({ pandoc.Plain(title) }, pandoc.Attr("", { "callout-title" }))
    local body = pandoc.Div(content, pandoc.Attr("", { "callout-body" }))
    return pandoc.Div({ header, body }, pandoc.Attr("", { "callout", "callout-" .. kind }))
  end

  return nil
end

-- Quarto: ::: {.callout-note title="..."}
function Div(el)
  local kind
  for _, class in ipairs(el.classes) do
    local k = class:match("^callout%-(%w+)$")
    if k then
      kind = normalize(k)
      break
    end
  end

  if not kind then
    return nil
  end

  local title
  if el.attributes.title then
    title = pandoc.read(el.attributes.title, "markdown").blocks[1]
    title = title and title.content or nil
  end

  local content = el.content

  -- Quarto también permite poner el título como primer encabezado del div
  if not title and content[1] and content[1].t == "Header" then
    title = content[1].content
    content = tail(content)
  end

  return build(kind, title, content)
end

-- GitHub: > [!NOTE] Título opcional
function BlockQuote(el)
  local first = el.content[1]
  if not first or (first.t ~= "Para" and first.t ~= "Plain") then
    return nil
  end

  local marker = first.content[1]
  if not marker or marker.t ~= "Str" then
    return nil
  end

  local k = marker.text:match("^%[!(%a+)%]$")
  local kind = k and normalize(k)
  if not kind then
    return nil
  end

  -- El resto de la primera línea (hasta el salto) es el título
  local inlines = tail(first.content)
  local title = pandoc.List()
  local rest = pandoc.List()
  local in_title = true
  for _, inl in ipairs(inlines) do
    if in_title and (inl.t == "SoftBreak" or inl.t == "LineBreak") then
      in_title = false
    elseif in_title then
      title:insert(inl)
    else
      rest:insert(inl)
    end
  end

  -- quitar espacios sobrantes
  while #title > 0 and title[1].t == "Space" do
    title:remove(1)
  end

  local content = pandoc.List()
  if #rest > 0 then
    content:insert(pandoc.Para(rest))
  end
  content:extend(tail(el.content))

  return build(kind, #title > 0 and title or nil, content)
end
