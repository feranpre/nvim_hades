# Plantilla "estilo UTAMED" para Análisis de Datos en Psicología I

Kit para escribir tus apuntes en Markdown y exportarlos a PDF con **pandoc +
XeLaTeX**, replicando el sistema visual de las unidades de la asignatura:
portada azul marino, cabecera/pie de página de unidad, titulares en azul con
prefijo "/", cajas de color para resúmenes/ejemplos/definiciones/notas, y
bibliografía en formato APA 7 generada automáticamente a partir de un
archivo `.bib`.

> **Nota sobre fidelidad visual.** Se ha reproducido la paleta de colores
> exacta (`#151A30` navy, `#348ECA` azul de acento), la tipografía, la
> estructura de cabecera/pie y los estilos de titulares de las unidades
> originales. **No** se reproducen las fotografías ni el escudo/logo
> propios de UTAMED (son material con derechos de autor de la universidad);
> en su lugar se usa un emblema geométrico genérico y configurable.

---

## 1. Contenido del kit

El kit forma parte de la configuración de Neovim (`nvim_hades`):

```
~/.config/nvim/scripts/
├── utamed_pdf.py              # el script que ejecuta pandoc
└── templates/utamed/          # archivos de soporte
    ├── template.tex           # Plantilla LaTeX para pandoc (el "diseño")
    ├── cajas.lua              # Filtro pandoc: traduce ::: {.resumen} ::: a cajas de color
    ├── apa.csl                # Estilo de citas APA 7ª edición (oficial, CSL project)
    ├── referencias.bib        # Bibliografía de ejemplo (referencias reales, con DOI)
    ├── ejemplo_unidad.md      # Markdown de ejemplo que usa todos los elementos
    └── README.md              # Este archivo
```

`utamed_pdf.py` busca los archivos de soporte en `templates/utamed/` junto a
sí mismo, sin importar desde qué carpeta lo ejecutes. Si alguna vez quieres
tener la carpeta de soporte en otro sitio, indícalo con
`--support-dir /ruta/a/utamed` o exportando `UTAMED_PSICOLOGIA_DIR=/ruta/a/utamed`.

Desde Neovim, en un buffer markdown: `<localleader>ku`.

---

## 2. Instalación en Arch Linux

```bash
# Motor de conversión y LaTeX
sudo pacman -S pandoc texlive-basic texlive-latexextra texlive-fontsextra \
               texlive-science texlive-langspanish python

# Tipografías recomendadas (las mismas familias que usan las unidades:
# geométricas de palo seco). Si no existieran en tus repos, están en el
# AUR:
sudo pacman -S ttf-fira-sans ttf-lato
# o, si tu gestor de repos no las tiene:
paru -S ttf-fira-sans ttf-lato        # o el AUR helper que uses
```

**No es obligatorio instalar Fira Sans / Lato.** `template.tex` detecta si
existen con `\IfFontExistsTF` y, si no las encuentra, usa automáticamente
**Carlito** o **Liberation Sans** como alternativa sin romper la
compilación (verás avisos ruidosos de `kpathsea`/`mktextfm` en la consola;
son inofensivos, no impiden que el PDF se genere).

Comprueba la instalación:

```bash
pandoc --version     # recomendado >= 2.11 (citeproc integrado)
xelatex --version
fc-list | grep -i "fira sans\|lato"    # confirma si las instalaste
```

---

## 3. Uso básico

Desde **cualquier carpeta** (por ejemplo, la de tus apuntes de la
asignatura, no la de `templates/utamed/`):

```bash
python3 ~/.config/nvim/scripts/utamed_pdf.py unidad_1.md
# → genera unidad_1.pdf en la misma carpeta, usando por defecto
#   ~/.config/nvim/scripts/templates/utamed/{template.tex,cajas.lua,apa.csl}

# Si tu unidad usa bibliografía, recuerda tener tu propio referencias.bib
# (o el .bib que uses) junto al .md, o apuntar a él con --bib
```

Otras formas de uso:

```bash
# Ruta de salida distinta
utamed_pdf.py unidad_1.md -o pdf/unidad_1.pdf

# Varias unidades de una vez
utamed_pdf.py unidad_1.md unidad_2.md unidad_3.md

# Sin bibliografía (ignora citas @clave aunque existan)
utamed_pdf.py unidad_1.md --sin-bibliografia

# Recompilar automáticamente cada vez que guardas el .md (útil mientras escribes)
utamed_pdf.py unidad_1.md --watch

# Si moviste la carpeta de soporte a otro sitio
utamed_pdf.py unidad_1.md --support-dir /ruta/a/utamed

# Pasar argumentos extra directamente a pandoc
utamed_pdf.py unidad_1.md -- --toc-depth=2
```

---

## 4. Cómo debe empezar tu archivo `.md`

Cabecera YAML mínima (cópiala de `ejemplo_unidad.md` y adáptala):

```yaml
---
title: "Título de la unidad"
unidad-numero: "1"
unidad-titulo: "Título de la unidad"
asignatura: "Análisis de Datos en Psicología I"
institucion: "Grado en Psicología"
author: "Tu nombre"
date: "Curso 2025-2026"
lang: es
toc: true
bibliography: referencias.bib
csl: apa.csl
---
```

| Campo | Para qué sirve |
|---|---|
| `title` | Título que aparece en la portada junto a "/ " |
| `unidad-numero` | Número mostrado en la cabecera ("UNIDAD 1") y portada |
| `unidad-titulo` | Texto de la cabecera ("/ ESTADÍSTICA DESCRIPTIVA") |
| `asignatura` | Tercera línea de la cabecera, en cursiva |
| `institucion` / `institucion-lema` | Texto grande de portada y su lema |
| `pie-institucion` | Texto del pie de página (por defecto, el nombre de la asignatura) |
| `bibliography` / `csl` | Activan la bibliografía automática (ver §6) |
| `toc` | `true`/`false`: incluir índice tras la portada |

---

## 5. Fórmulas en LaTeX

Tal y como pediste, usa `$...$` para fórmulas en línea y `$$...$$` para
fórmulas en bloque. Pandoc las interpreta de forma nativa (no hace falta
ningún ajuste):

```markdown
La media aritmética $\bar{x}$ se calcula como:

$$
\bar{x} = \frac{1}{n}\sum_{i=1}^{n} x_i
$$
```

---

## 6. Bibliografía y citas (APA 7, con DOI verificado)

1. Añade tus referencias a `referencias.bib` en formato BibTeX (o crea tu
   propio `.bib` y apunta a él desde el YAML). Verifica siempre el DOI en
   [pubmed.ncbi.nlm.nih.gov](https://pubmed.ncbi.nlm.nih.gov) o
   [doi.org](https://doi.org) antes de incluir una referencia.
2. Cita en el texto con la sintaxis de pandoc:
   - `[@clave]` → cita entre paréntesis: `(Kim, 2013)`
   - `@clave` → cita narrativa: `Kim (2013)`
   - `[@clave1; @clave2]` → varias referencias: `(Kim, 2013; Field, 2013)`
3. Al final del documento, añade la sección de bibliografía **exactamente
   así** (el `::: {#refs} :::` es donde pandoc insertará la lista generada):

   ```markdown
   # Bibliografía

   ::: {#refs}
   :::
   ```

El estilo `apa.csl` incluido es la **APA 7ª edición oficial** del proyecto
Citation Style Language (el mismo que usan Zotero/Mendeley), por lo que el
formato de las referencias es correcto y verificable. `referencias.bib`
incluye ya algunas referencias reales indexadas en PubMed a modo de ejemplo.

---

## 7. Cajas de contenido (resumen, ejemplo, definición, nota…)

Se escriben como *fenced divs* de pandoc. El filtro `cajas.lua` las
convierte en las cajas de color definidas en `template.tex`:

```markdown
::: {.resumen}
Síntesis del apartado en 2-3 frases.
:::

::: {.ejemplo}
**Ejemplo aplicado.** Descripción de un caso o estudio psicológico real
que ilustre el concepto.
:::

::: {.definicion}
**Término clave**: definición precisa del concepto.
:::

::: {.nota}
Advertencia metodológica o matización importante.
:::

::: {.formuladestacada}
Para resaltar una fórmula especialmente importante dentro de un recuadro.
:::

::: {.competencias}
- Objetivo o competencia 1
- Objetivo o competencia 2
:::
```

¿Quieres añadir una caja nueva (por ejemplo, "Estudio de caso")? Solo tienes
que:
1. Definir el color en `template.tex` (busca la sección "Cajas de contenido
   didáctico" y copia el patrón de `\newtcolorbox{...}`).
2. Añadir el nombre de la clase a la tabla `CAJAS` en `cajas.lua`.

---

## 8. Tablas

Las tablas Markdown estándar de pandoc funcionan sin configuración
adicional:

```markdown
| Estadístico | Fórmula | Interpretación |
|---|---|---|
| Media | $\bar{x} = \frac{1}{n}\sum x_i$ | Valor central promedio |
```

---

## 9. Personalizar colores / tipografía

Todo el diseño está centralizado al principio de `template.tex`, en el
bloque `% ---------- Color ----------`. Por ejemplo, para cambiar el azul de
acento:

```latex
\definecolor{accent}{RGB}{52,142,202}   % ← cambia estos valores RGB
```

Y en `% ---------- Idioma y tipografía ----------` puedes forzar otra
familia tipográfica si lo prefieres, sustituyendo `Fira Sans` / `Lato` por
el nombre exacto de la fuente que tengas instalada (tal y como aparece en
`fc-list`).

---

## 10. Solución de problemas

**"Undefined control sequence... \tightlist" o errores similares al
compilar tu propio `.tex` manual**: usa siempre `utamed_pdf.py`, no invoques
`xelatex` directamente sobre el `.md`; el script añade automáticamente el
filtro `cajas.lua` y las extensiones de pandoc necesarias.

**Los acentos/ñ no se ven bien**: asegúrate de guardar tus `.md` en UTF-8
(por defecto en la mayoría de editores en Linux).

**"Faltan archivos del kit de plantilla"**: por defecto se buscan en
`~/.config/nvim/scripts/templates/utamed/`. Comprueba que copiaste allí
`template.tex`, `cajas.lua` y `apa.csl` (§1), o usa `--support-dir` /
`UTAMED_PSICOLOGIA_DIR` si los tienes en otra ruta.

**Quiero previsualizar rápido sin instalar TeX Live completo**: no es
posible evitarlo del todo (XeLaTeX es necesario para las fuentes OpenType y
las cajas de color), pero `texlive-basic` + los paquetes indicados en el
§2 son suficientes; no hace falta `texlive-full`.

**Avisos de `mktextfm`/`METAFONT` en la consola al compilar**: `utamed_pdf.py`
ya desactiva esto (`MKTEXTFM=0`) para que la comprobación automática de
fuentes no dispare intentos de generar fuentes bitmap; si aun así los ves
(por ejemplo, compilando el `.tex` a mano sin pasar por el script), son un
efecto colateral inofensivo de `\IfFontExistsTF` cuando una fuente no está
instalada — no indican un error real si al final ves "✓ PDF generado".

**"LaTeX Error: No counter 'none' defined" / errores en tablas con
`\real{...}`**: corregido en esta versión (el paquete `calc`, necesario
para los anchos de columna que genera pandoc, estaba cargado solo
condicionalmente). Si ves este error, asegúrate de estar usando la versión
más reciente de `template.tex` de este kit.
