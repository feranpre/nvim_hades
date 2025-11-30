#' ---
#' title: 'Resultados temporales'
#' author: 'Fernando Andres-Pretel'
#' output:
#'    html_document:
#'         toc: yes
#'         toc_depth: 4
#'         number_sections: true
#'         toc_float:
#'            collapsed: true
#' ---
#+ , echo=FALSE, include=FALSE
rm(list = ls(all.names = TRUE))

#' # Titulo 1
#'
#+ , results = 'asis', error = TRUE,  eval =TRUE, echo = FALSE, message = FALSE, warning = FALSE, fig.width = 5, fig.height = 5, unit = 'cm', comment = ''

knitr::kable(head(mtcars))


#+ , error = TRUE,  eval =TRUE, echo = FALSE, message = FALSE, warning = FALSE, fig.width = 5, fig.height = 5, unit = 'cm', comment = ''

summary(mtcars)

sumary(mtcars)

asdf

x <- 5

x + "a"
