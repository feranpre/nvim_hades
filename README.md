# nvim_hades

Configuración de Neovim orientada a R, Quarto y Markdown. `<localleader>` es `,`.
Pulsando `,` aparece el menú de which-key con todo lo disponible en cada sitio.

## R (`.R`)

| Atajo | Acción |
|---|---|
| `,rs` / `,rq` / `,rc` | arrancar / cerrar / limpiar la consola de R |
| `<S-Enter>` | ejecutar la línea |
| `<C-Enter>` | ejecutar el bloque y bajar |
| `,rl` / `,rp` | línea (o selección) / párrafo |
| `,sf` | mandar el archivo entero |
| `,sc` | mandar el pipeline desde el principio hasta el paso del cursor (para depurarlo paso a paso) |
| `,vt` / `,vs` | `str()` / `summary()` del objeto bajo el cursor en ventana flotante (repetir para entrar, `q` cierra) |
| `,vd` | ver un data.frame |
| `,p` / `,h` / `,o` | imprimir objeto / ayuda / explorador de objetos |
| `Alt+-` / `Alt+m` | insertar ` <- ` / ` \|> ` |
| `,ep` / `,eh` | exportar a PDF / HTML (los `#'` son el texto, como `knitr::spin`) |
| `,b…` | desarrollo de paquetes (build, check, test, document…) |

Al pulsar Intro en una línea `#'` se continúa el comentario. Al guardar, el
código se formatea con [air](https://posit-dev.github.io/air/) (si está
instalado) y se revisa con lintr (si el paquete está instalado).

## Quarto / R Markdown / Markdown

Dentro de un chunk aparece el menú `,r` del lenguaje (R va a la misma consola
que los `.R`); fuera, el de quarto (`,q`) o markdown (`,m`, `,t`).

| Atajo | Acción |
|---|---|
| `<S-Enter>` | ejecutar el chunk |
| `,sf` | ejecutar todos los chunks de R |
| `Alt+r` | insertar un chunk de R |
| `,ep` / `,eh` (`,eP` / `,eH` abren) | exportar a PDF / HTML con `scripts/templates/hades` |
| `,qr` / `,qp` | quarto render / preview |
| `,qn` / `,qh` / `,qP` | presentación nueva / a HTML / a PDF |

## Proyectos (`,P`, en cualquier buffer)

La raíz del proyecto es la carpeta con un `.Rproj` más cercana a la carpeta de
trabajo de Neovim (o esa misma carpeta).

| Atajo | Acción |
|---|---|
| `,Pc` | crear proyecto en la carpeta de trabajo: `.Rproj`, `.lintr`, `air.toml` |
| `,Pd` | carpetas `data/raw`, `data/processed`, `R`, `output/…`, `reports` |
| `,Pg` | `git init` + `.gitignore` para R |
| `,Pn` | script de R nuevo con cabecera `#'` |
| `,Pf` | buscar archivos del proyecto |
| `,Pl` | lintr de todo el proyecto en la lista quickfix |
| `,Pw` | `setwd()` de R a la raíz del proyecto |
| `,Pr` / `,Ps` / `,PR` / `,Pu` | renv: init / snapshot / restore / status |

Nunca se sobrescribe un archivo que ya exista.

## Dependencias de R

```r
install.packages(c("lintr", "renv", "styler", "devtools", "rmarkdown"))
```

Además: [air](https://posit-dev.github.io/air/), `quarto`, `pandoc` y TeX Live
(ver `scripts/templates/hades/README.md`), y `tree-sitter-cli` con Neovim 0.12.
