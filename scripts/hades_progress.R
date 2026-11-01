# ---------------------------------------------------------------------------
# hades_progress.R — progreso de la exportación para Neovim
#
# md_to_pdf.py lo carga como perfil de R (R_PROFILE_USER) en el proceso de R
# que lanza quarto / rmarkdown. Escribe por stderr líneas que empiezan por
# "@@hades" y que config/utils/export.lua convierte en una ventana de
# progreso. No cambia nada del documento generado.
#
#   @@hades chunk <i> <total> <es_codigo> <etiqueta>   empieza el grupo i
#   @@hades knit-done                                   código ejecutado
#   @@hades step <i> <n> <tarea>\t<detalle>             paso dentro del bloque
#   @@hades step-end                                    fin de los pasos
#
# Los pasos dentro de un bloque los envían las funciones de feR que recorren
# muchas variables (canal progress_task_*), si el paquete lo permite.
# ---------------------------------------------------------------------------

local({
  # 1. El perfil habitual del usuario (renv, opciones...), como haría R
  original <- Sys.getenv("HADES_R_PROFILE_USER", "")
  profile <- if (nzchar(original)) {
    original
  } else if (file.exists(".Rprofile")) {
    ".Rprofile"
  } else {
    file.path(Sys.getenv("HOME"), ".Rprofile")
  }
  if (file.exists(profile)) sys.source(profile, envir = globalenv())

  emit <- function(...) {
    cat("@@hades ", paste0(...), "\n", sep = "", file = stderr())
  }
  clean <- function(x) gsub("[\r\n\t]", " ", as.character(x)[1])

  # 2. Bloque a bloque: gancho de knitr (>= 1.42)
  options(knitr.progress.fun = function(total, labels) {
    list(
      update = function(i) {
        emit("chunk ", i, " ", total, " ", as.integer(nzchar(labels[i])), " ", clean(labels[i]))
      },
      done = function() emit("knit-done")
    )
  })

  # 3. Dentro de un bloque: canal de progreso de feR
  listener <- function(event, stack) {
    if (length(stack) == 0) {
      emit("step-end")
      return(invisible())
    }
    outer <- stack[[1]] # fracción: la tarea más externa
    inner <- stack[[length(stack)]] # detalle: la más interna
    detail <- if (length(stack) > 1) {
      paste0(inner$task, " ", inner$i, "/", inner$n, " ", inner$label)
    } else {
      inner$label
    }
    emit("step ", outer$i, " ", outer$n, " ", clean(outer$task), "\t", clean(detail))
  }

  # API pública (opción) y, si no existe, el oyente interno de feR 0.6
  options(feR.progress.listener = listener)
  setHook(packageEvent("feR", "onLoad"), function(...) {
    ns <- asNamespace("feR")
    if (exists(".progress_listen", envir = ns, inherits = FALSE)) {
      try(get(".progress_listen", envir = ns)(listener), silent = TRUE)
    }
  })
})
