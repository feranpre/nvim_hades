---
title: "Estadística descriptiva"
unidad-numero: "1"
unidad-titulo: "Estadística descriptiva"
asignatura: "Análisis de Datos en Psicología I"
institucion: "Grado en Psicología"
institucion-lema: "Apuntes de la asignatura"
subtitulo-portada: "Material de estudio personal"
pie-institucion: "Análisis de Datos en Psicología I"
author: "Tu nombre"
date: "Curso 2025-2026"
lang: es
toc: true
bibliography: referencias.bib
csl: apa.csl
---

# Introducción y objetivos

## Introducción

El análisis descriptivo de datos constituye una fase esencial en cualquier
investigación psicológica. Antes de contrastar hipótesis es necesario
**organizar, resumir y representar** los datos recogidos, de forma que
permitan una interpretación clara y rigurosa.

::: {.resumen}
Esta unidad presenta los fundamentos del muestreo, los tipos de variables
psicológicas y las principales medidas descriptivas (tendencia central,
dispersión y forma de la distribución), con ejemplos aplicados a la
investigación en psicología clínica, social y de la salud.
:::

## Objetivos

::: {.competencias}
- Diferenciar los tipos de muestreo probabilístico y no probabilístico.
- Clasificar variables psicológicas según su nivel de medida.
- Calcular e interpretar medidas de tendencia central y de dispersión.
- Reconocer el efecto de la asimetría y la curtosis en la elección de
  pruebas estadísticas.
:::

# Medidas de tendencia central

## Media aritmética

La media aritmética $\bar{x}$ de una muestra de $n$ observaciones se define
como:

$$
\bar{x} = \frac{1}{n}\sum_{i=1}^{n} x_i
$$

donde $x_i$ representa la puntuación de cada participante $i$. Por ejemplo,
si $n = 5$ participantes obtienen las puntuaciones $x = \{12, 15, 14, 18, 16\}$
en una escala de ansiedad, la media es $\bar{x} = 15$.

::: {.ejemplo}
**Ejemplo aplicado.** En un estudio sobre síntomas depresivos con el
inventario BDI-II, un grupo clínico ($n = 30$) obtiene una media de
$\bar{x} = 24.3$ ($DT = 6.1$), mientras que el grupo control ($n = 30$)
obtiene $\bar{x} = 8.7$ ($DT = 4.2$). La comparación de medias, junto con su
dispersión, permite valorar tanto la magnitud de la diferencia como la
homogeneidad interna de cada grupo.
:::

## Mediana y moda

La mediana ($Md$) es el valor que divide la distribución ordenada en dos
mitades iguales. Es especialmente recomendable cuando la distribución es
asimétrica o contiene valores atípicos, algo frecuente en variables como el
tiempo de reacción o los ingresos familiares [@field2013].

::: {.definicion}
**Moda ($Mo$)**: valor que presenta la frecuencia más alta en el conjunto de
datos. En variables discretas —por ejemplo, número de visitas al servicio de
salud mental— aporta información complementaria a la media y la mediana.
:::

# Medidas de dispersión

La varianza muestral $s^2$ y la desviación típica $s$ cuantifican la
variabilidad de las puntuaciones respecto a la media:

$$
s^2 = \frac{\sum_{i=1}^{n}(x_i-\bar{x})^2}{n-1}
\qquad\qquad
s = \sqrt{s^2}
$$

::: {.formuladestacada}
Cuando se trabaja con la **población completa** (y no con una muestra), el
denominador es $n$ en lugar de $n-1$, ya que no es necesario corregir el
sesgo del estimador:
$$
\sigma^2 = \frac{1}{N}\sum_{i=1}^{N}(x_i-\mu)^2
$$
:::

::: {.nota}
**Nota metodológica.** Dividir por $n-1$ (corrección de Bessel) proporciona
un estimador insesgado de la varianza poblacional a partir de una muestra.
Usar $n$ en su lugar subestima sistemáticamente la variabilidad real.
:::

# Asimetría y curtosis

La asimetría (*skewness*) y la curtosis (*kurtosis*) describen la forma de
la distribución. @hoyu2015 muestran que las distribuciones no
normales son mucho más frecuentes en datos psicométricos y educativos de lo
que suele asumirse, lo que tiene implicaciones directas sobre qué pruebas
estadísticas resultan apropiadas. En la misma línea, @kim2013 recomienda
inspeccionar de forma rutinaria los índices de asimetría y curtosis antes de
aplicar pruebas paramétricas.

Una tabla resumen de referencia:

| Estadístico       | Símbolo     | Fórmula                                              | Interpretación                          |
|--------------------|:-----------:|-------------------------------------------------------|------------------------------------------|
| Media              | $\bar{x}$   | $\frac{1}{n}\sum x_i$                                  | Valor central promedio                   |
| Mediana            | $Md$        | Valor central en datos ordenados                       | Robusta a valores atípicos               |
| Desviación típica  | $s$         | $\sqrt{\frac{\sum (x_i-\bar{x})^2}{n-1}}$              | Dispersión en unidades originales        |
| Asimetría          | $g_1$       | $\frac{n}{(n-1)(n-2)}\sum \left(\frac{x_i-\bar{x}}{s}\right)^3$ | Simetría de la distribución    |

# Muestreo en investigación psicológica

Elegir un método de muestreo adecuado condiciona la validez externa de
cualquier estudio. @parsaeian2021 proponen un método de
muestreo eficiente para encuestas nacionales con tamaños muestrales
limitados, aplicable a estudios de salud pública y, por extensión, a
investigaciones psicosociales con recursos acotados.

# Bibliografía

::: {#refs}
:::
