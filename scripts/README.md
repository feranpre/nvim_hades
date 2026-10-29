# scripts

Todos los scripts que usa la configuración. Desde Lua se localizan con
`vim.fn.stdpath("config") .. "/scripts"` (ver `lua/config/utils/export.lua`), y
cada script busca sus plantillas relativas a sí mismo, así que no dependen de
`~/.config/my_scripts` ni del `PATH`.

| Script          | Qué hace                                         | Atajo   |
|-----------------|--------------------------------------------------|---------|
| `md_to_pdf.py`  | `.md` / `.qmd` / `.Rmd` → PDF o HTML con la plantilla de `templates/hades` (ver su README) | `,ep` / `,eh` (`,eP` / `,eH` abren el resultado) |
| `md_to_html.py` | Markdown → HTML autocontenido (bootstrap, plantilla antigua) | —       |
| `pandoc_to_pdf.py` | Markdown → PDF con eisvogel respetando `number-offset` del YAML | — |

También `:Export pdf`, `:Export html` y `:Export! pdf` (exporta y abre). En
archivos `.R`, `,ep` / `,eh` hacen knit con `rmarkdown::render`.

## templates

```
templates/
├── hades/    # plantilla de exportación: template.tex, cajas.lua, callouts.lua,
│             # hades.css/.scss/.theme, pdf/html/quarto.yaml, apa.csl (ver su README)
├── slides/   # presentaciones Quarto reveal.js: clase.qmd, hades.scss, img/
├── latex/    # eisvogel.latex y caronte_* (para md_to_html.py -tpdf / pandoc_to_pdf.py)
└── html/     # bootstrap_pandoc.html, rstudio_html.css (para md_to_html.py)
```

## Dependencias

- `pandoc`
- `xelatex` o `lualatex` (texlive; en Arch `texlive-basic texlive-latexextra
  texlive-fontsextra texlive-science texlive-langspanish`)
- `quarto` para exportar `.qmd` / `.Rmd` (ejecuta el código R)
- opcional: `mermaid-filter` (`npm install -g mermaid-filter`)

## Presentaciones (Quarto + reveal.js)

`templates/slides/` es la plantilla de clase, con el estilo de los apuntes
(morado oscuro + #9b5de5 de acento, titulares con "/", cajas `.resumen`, `.ejemplo`,
`.definicion`, `.nota` y `.formula`). Desde Neovim (`lua/config/utils/slides.lua`):

| Atajo | Qué hace |
|---|---|
| `<leader>qn`, `,qn` o `s` en la portada | Nueva presentación: pide título y carpeta y copia la plantilla |
| `,qp` | Vista previa en el navegador (se recarga al guardar) |
| `,qh` | Genera el `.html` (un solo archivo, funciona sin internet) |
| `,qP` | Genera el `.html` y lo exporta a PDF con decktape |

En el navegador: `S` vista del ponente (notas, reloj, siguiente), `F` pantalla
completa, `O` vista general.

Dependencias: `quarto`, y para el PDF `decktape` (`npm install -g decktape`;
si no está, se usa `npx decktape`). Al generar el `.html` Quarto descarga
KaTeX una vez para incrustarlo, así que hace falta internet al *generar*,
no al *presentar*.
