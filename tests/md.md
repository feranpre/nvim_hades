---
title: "Titulo"
subtitle: "Subtitle"
author: "Fernando Andres-Pretel"
titlepage: true
toc: true
toc-depth: 3
number-offset: 1
secnumberdepth: 1
number-sections: false
number-depth: 4
colorlinks: true
mainfont: DejaVu Sans
mathfont: DejaVu Math TeX Gyre
monofont: Source Code Pro
fontsize: 12pt
highlight-style: tango
code-block-font-size: \footnotesize
code-block-font-size: \scriptsize
header-includes:
- |
  ```{=latex}
  \usepackage{awesomebox}
  \providecommand{\pandocbounded}[1]{#1}
  ```
pandoc-latex-environment:
  noteblock: [note]
  tipblock: [tip]
  warningblock: [warning]
  cautionblock: [caution]
  importantblock: [important]
---

Text

# Primera prueba

Esto es texto.

## Una subsección

Más texto.

```{r}
x <- 10
x + 20
```

# Documento

texto

## Introducción

texto

### Detalles

texto

## Métodos

texto

# Resultados

texto
