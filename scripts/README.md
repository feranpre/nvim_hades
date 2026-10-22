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

## templates

```
templates/
├── latex/    # eisvogel.latex, custom_tango.theme, defaults.yaml, pandoc38_table_fix.tex, caronte_*.tex
├── html/     # bootstrap_pandoc.html, rstudio_html.css
└── utamed/   # template.tex, cajas.lua, apa.csl, referencias.bib, ejemplo (ver su README)
```

## Dependencias

- `pandoc` (>= 3.8 para `md_to_pdf.py`, usa `--syntax-highlighting`)
- `xelatex` (texlive)
- `mermaid-filter` (`npm install -g mermaid-filter`)
- `pandoc-latex-environment` (solo para PDF desde `md_to_html.py -tpdf`)
