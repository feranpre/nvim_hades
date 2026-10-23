# scripts

Todos los scripts que usa la configuración. Desde Lua se localizan con
`vim.fn.stdpath("config") .. "/scripts"` (ver `lua/config/utils/pandoc.lua`), y
cada script busca sus plantillas relativas a sí mismo, así que no dependen de
`~/.config/my_scripts` ni del `PATH`.

| Script          | Qué hace                                         | Atajo (markdown)   |
|-----------------|--------------------------------------------------|--------------------|
| `md_to_pdf.py`  | Markdown → PDF (pandoc + xelatex, eisvogel)      | `<localleader>kp`  |
| `md_to_html.py` | Markdown → HTML autocontenido (bootstrap)        | `<localleader>kh`  |
| `utamed_pdf.py` | Markdown → PDF con el estilo de las unidades UTAMED | `<localleader>ku`  |
| `pandoc_to_pdf.py` | Markdown → PDF respetando `number-offset` del YAML | —                |

## templates

```
templates/
├── latex/    # eisvogel.latex, custom_tango.theme, defaults.yaml, pandoc38_table_fix.tex, caronte_*.tex
├── html/     # bootstrap_pandoc.html, rstudio_html.css
├── slides/   # presentaciones Quarto reveal.js: clase.qmd, hades.scss, img/
└── utamed/   # template.tex, cajas.lua, apa.csl, referencias.bib, ejemplo (ver su README)
```

## Dependencias

- `pandoc` (>= 3.8 para `md_to_pdf.py`, usa `--syntax-highlighting`)
- `xelatex` (texlive)
- `mermaid-filter` (`npm install -g mermaid-filter`)
- `pandoc-latex-environment` (solo para PDF desde `md_to_html.py -tpdf`)

## Presentaciones (Quarto + reveal.js)

`templates/slides/` es la plantilla de clase, con el estilo de los apuntes
(navy + azul de acento, titulares con "/", cajas `.resumen`, `.ejemplo`,
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
