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
| `,ss` | mandar la sección del cursor (de su título al siguiente) |
| `,su` | mandar todo el script hasta la línea del cursor |
| `,so` | evaluar la línea e insertar el resultado debajo como comentario |
| `gO` / `]]` / `[[` | índice del documento / sección siguiente / anterior. Títulos: `#' ## Título` y secciones de RStudio `# Título ----` |
| `,vt` / `,vs` | `str()` / `summary()` del objeto bajo el cursor en ventana flotante (repetir para entrar, `q` cierra) |
| `,vd` | ver un data.frame |
| `,p` / `,h` / `,o` | imprimir objeto / ayuda / explorador de objetos |
| `Alt+-` / `Alt+m` | insertar ` <- ` / ` \|> ` |
| `,ep` / `,eh` | exportar a PDF / HTML (los `#'` son el texto, como `knitr::spin`) |
| `,b…` | desarrollo de paquetes (build, check, test, document…) |
| `,rC` / `:RRebuildCompl [paquete]` | rehacer el autocompletado de un paquete reinstalado sin cambiar de versión (feR por defecto) |

R.nvim solo rehace la lista de autocompletado de un paquete cuando cambia su
versión: si reinstalas feR con funciones nuevas y la misma versión, no
aparecen al escribir `feR::`. `,rC` la rehace en un R aparte y hace que el
autocompletado la vuelva a leer sin reiniciar nada.

Al pulsar Intro en una línea `#'` se continúa el comentario. Al guardar, el
código se formatea con [air](https://posit-dev.github.io/air/) (si está
instalado) y se revisa con lintr (si el paquete está instalado).

## Exportar (`,ep` / `,eh`)

Mientras exporta aparece una ventana abajo a la derecha con la barra de
progreso, el bloque en curso (y el paso dentro del bloque cuando feR recorre
muchas variables), el tiempo transcurrido y una estimación de lo que queda.
También se ve en la barra de estado. `,ex` (o `:ExportCancel`) la cancela.

`,ew` exporta cada vez que guardas (pregunta el formato; otra vez `,ew` lo
quita). La primera vez abre el resultado: los visores de PDF que recargan
solos (zathura, evince, okular, sioyek) muestran siempre la última versión; en
HTML basta con recargar el navegador. Si guardas mientras exporta, se vuelve a
exportar al terminar.

Los `.R`, `.qmd` y `.Rmd` se exportan con Quarto, así que la cabecera es la
de Quarto (`format: html: ...`; los snippets `_informe` / `informe` la traen
hecha). El índice y la numeración también se leen de una cabecera antigua de
rmarkdown (`output: html_document: toc / toc_depth / number_sections`).

En HTML el índice va en una columna fija a la izquierda (también en los
`.md`), y las tablas anchas pueden ocupar el espacio libre de la derecha. El
botón de arriba a la izquierda, o la tecla `i`, lo oculta; el navegador
recuerda la elección. En pantallas estrechas empieza oculto. Se muestran
todos los niveles hasta `toc-depth` (`toc-expand` y `toc-location` dan igual).

Para que el progreso se lea bien, pon nombre a los bloques: `#+ descriptivos`.

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

### Escribir texto (markdown, quarto, R markdown)

- Las líneas largas se ven partidas por palabras (el archivo no cambia) y
  `j` / `k` se mueven por líneas de pantalla.
- `gO` abre el índice del documento; `]]` / `[[` saltan entre secciones.
- Con una selección: `,mb` negrita, `,mi` cursiva, `,mc` código, `,mk` enlace.
- Ortografía en castellano e inglés: `<leader>s` (o `:Ortografia`) la activa;
  la primera vez descarga el diccionario. `z=` da sugerencias, `]s` / `[s`
  saltan entre errores y `zg` añade la palabra al diccionario. Si el
  diccionario está instalado, se activa sola en estos archivos.

## Snippets de R (escribir el prefijo y elegir en el menú de completado)

En scripts `.R` (informes al estilo `knitr::spin`, se exportan con `,ep` / `,eh`):

| Prefijo | Inserta |
|---|---|
| `_informe` | cabecera YAML + chunk `setup` (feR, datos) lista para exportar |
| `_seccion` / `_texto` | sección `#' ##` con texto / bloque de texto `#'` |
| `_fig` / `_tabla` | figura / tabla numeradas (citar con `@fig-nombre` / `@tbl-nombre`) |
| `_nota` | caja de la plantilla: nota, resumen, ejemplo, definición |
| `_formula` | fórmula en bloque |
| `_asis` | chunk con `results = 'asis'` |
| `_compare_vars` | comparar varias variables con un grupo (feR) |
| `_carga_datos` | leer `DATOS_BASE/…`, limpiar nombres y guardar en `DATOS_R` |
| `_describe`, `_describe_grupo`, `_compare`, `_compare_pareado`, `_cor` | funciones de feR (también en `.qmd` / `.Rmd`) |
| `_supervivencia`, `_reg_lineal_mult`, `_reg_log_bin`, `_reg_ordinal`, `_gg_*`, `_teoria` | análisis y gráficos habituales |

En `.qmd`: `informe`, `compare_vars`, `rfig`, `rtbl`, `rchunk`… En `.Rmd`: `informe`.

## Proyectos

Cada proyecto es una carpeta. La portada de Neovim muestra los **proyectos
recientes** (teclas `1`…`8`), `p` abre la lista completa y `P` crea uno nuevo.

| Atajo | Acción |
|---|---|
| `<leader>p` / `,Pp` / `:Projects` | lista de proyectos: `Enter` abre, `Ctrl-n` nuevo, `Ctrl-x` quitar de la lista, `Ctrl-a` añadir la carpeta actual |
| `,PN` / `:ProjectNew` | nuevo proyecto: carpeta (por defecto en `~/Proyectos`, se cambia en `lua/config/hades.lua`) y tipo: análisis de R (`.Rproj`, `.lintr`, `air.toml`, carpetas `DATOS_*`, git), R básico o carpeta vacía |
| `,Pa` / `:ProjectAdd` | añadir la carpeta actual a la lista |

Al abrir un proyecto, Neovim cambia su directorio de trabajo a esa carpeta y
abre el último archivo que editaste en ella (o la carpeta, con oil). Si es un
proyecto de R (tiene `.Rproj`, `DESCRIPTION`, `renv.lock` o scripts de R),
también cambia el de R: `setwd()` si R ya está abierto; si no, R arrancará en
esa carpeta. Abrir `nvim` dentro de una carpeta con `.Rproj` la apunta en la
lista.

### Utilidades de proyecto de R (`,P`, en cualquier buffer)

La raíz del proyecto es la carpeta con un `.Rproj` más cercana a la carpeta de
trabajo de Neovim (o esa misma carpeta).

| Atajo | Acción |
|---|---|
| `,Pc` | crear proyecto en la carpeta de trabajo: `.Rproj`, `.lintr`, `air.toml` |
| `,Pd` | carpetas `DATOS_BASE`, `DATOS_R`, `DATOS_EXPORTADOS`, `GRAFICOS`, `versiones` |
| `,Pg` | `git init` + `.gitignore` para R |
| `,Pn` | informe `.R` nuevo con la cabecera del snippet `_informe` |
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
