# Plantillas de exportación (pandoc / Quarto)

Plantillas que usa `scripts/md_to_pdf.py` para exportar documentos Markdown,
Quarto y R Markdown a PDF y HTML desde Neovim. Color principal: `#9b5de5`.

## Uso

En Neovim, en archivos `.md`, `.qmd`, `.Rmd` (y `.R`, que se exportan con
`rmarkdown`):

| Atajo | Acción |
|---|---|
| `,ep` | Exportar a PDF |
| `,eh` | Exportar a HTML |
| `,eP` / `,eH` | Exportar y abrir el resultado |

También `:Export pdf`, `:Export html` y `:Export! pdf` (exporta y abre).

Desde la terminal:

```bash
scripts/md_to_pdf.py apuntes.md              # -> apuntes.pdf
scripts/md_to_pdf.py apuntes.md -t html      # -> apuntes.html
scripts/md_to_pdf.py informe.qmd salida.pdf
```

## Contenido

| Archivo | Para qué sirve |
|---|---|
| `template.tex` | Diseño del PDF (portada, cabecera, pie, titulares, cajas) |
| `cajas.lua` | Filtro: `::: {.resumen}` … `:::` → cajas de color de `template.tex` |
| `callouts.lua` | Filtro: callouts de Quarto (`::: {.callout-note}`) y alertas de GitHub (`> [!NOTE]`) |
| `hades.theme` | Colores del resaltado de código |
| `hades.css` | Estilo del HTML exportado desde `.md` |
| `hades.scss` | Tema de Quarto para el HTML exportado desde `.qmd` / `.Rmd` |
| `pdf.yaml`, `html.yaml` | Opciones de pandoc para `.md` |
| `quarto.yaml` | Opciones que se pasan a `quarto render` para `.qmd` / `.Rmd` |
| `apa.csl` | Estilo de citas APA 7 (por defecto) |
| `referencias.bib`, `ejemplo_unidad.md` | Ejemplo con todos los elementos |

## Instalación (Arch Linux)

```bash
sudo pacman -S pandoc texlive-basic texlive-latexextra texlive-fontsextra \
               texlive-science texlive-langspanish python
# Opcional: tipografías del diseño (si no están, se usan Carlito / Liberation Sans)
sudo pacman -S ttf-fira-sans ttf-lato
# Para .qmd / .Rmd: quarto (AUR: quarto-cli-bin)
```

Si faltan Fira Sans o Lato verás avisos de `mktextfm`/`METAFONT` al compilar:
son inofensivos, el PDF se genera igualmente.

## Cabecera YAML

Todos los campos son opcionales salvo `title`:

```yaml
---
title: "Estadística descriptiva"
subtitle: "Opcional"
author: "Tu nombre"
date: "Curso 2025-2026"
toc: true
bibliography: referencias.bib
# Campos para apuntes por unidades:
unidad-numero: "1"            # muestra "Unidad 1" en portada y cabecera
unidad-titulo: "Estadística descriptiva"
asignatura: "Análisis de Datos en Psicología I"
institucion: "Grado en Psicología"   # texto grande de la portada
institucion-lema: "Apuntes de la asignatura"
subtitulo-portada: "Material de estudio personal"
pie-institucion: "Texto del pie de página"
---
```

Si no indicas `unidad-numero`, la portada muestra solo el título. Si no
indicas `institucion`, la portada solo lleva el emblema.

## Cajas

```markdown
::: {.resumen}
Síntesis del apartado.
:::

::: {.ejemplo}
**Ejemplo aplicado.** …
:::

::: {.definicion}
**Término clave**: …
:::

::: {.nota}
Advertencia o matización.
:::

::: {.formuladestacada}
$$\bar{x} = \frac{1}{n}\sum x_i$$
:::

::: {.competencias}
- Objetivo 1
- Objetivo 2
:::
```

Para añadir una caja nueva: define su `\newtcolorbox{...}` en `template.tex`
(sección "Cajas de contenido didáctico"), añade la clase a `CAJAS` en
`cajas.lua` y, si quieres que también se vea en HTML, dale estilo en
`hades.css` / `hades.scss`.

También funcionan los callouts de Quarto y las alertas de GitHub:

```markdown
::: {.callout-tip title="Consejo"}
…
:::

> [!WARNING]
> …
```

## Citas

Añade `bibliography: referencias.bib` al YAML y cita con `[@clave]`,
`@clave` o `[@clave1; @clave2]`. El estilo es APA 7 (`apa.csl`) salvo que
indiques otro con `csl:`. Para colocar la bibliografía en un sitio concreto:

```markdown
# Bibliografía

::: {#refs}
:::
```

## Personalizar

Los colores están al principio de `template.tex` (sección `Color`). El color
principal es `accent` (`#9B5DE5`); `navy` es el morado oscuro de portada,
cabecera y pie.
