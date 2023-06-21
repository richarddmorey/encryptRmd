
#' Perform encryptRmd setup for non-html_documents
#'
#' This function should be called in the first chunk, with echo=FALSE and include=TRUE.
#' It will inject the necessary dependencies and setup knitr to transform the outputs and
#' plots from chunks.
#'
#' @param hljs Include highlight.js dependency? This will highlight R code after it is decrypted in source code.
#' @return an htmltools tagList
#' @export
#' @importFrom htmltools tagList tags HTML
#' @importFrom knitr knit_hooks
#'
encryptRmd_general_setup <- function(hljs = FALSE){

  local({
    knitr::knit_hooks$set(
      output = enc_out_hook,
      plot = enc_plot_hook,
      source = enc_source_hook
    )
  })

  htmltools::tagList(
    htmltools::tags$div(
      system.file('includes/html/key_entry.html', package='encryptRmd') |>
        readLines() |> htmltools::HTML()
    ),
    htmltools::tags$script(
      src=system.file('includes/js/highlight.js', package='encryptRmd')
    ),
    htmltools::tags$script(
      src=system.file('includes/js/encrypted_chunk.js', package='encryptRmd')
    ),
    htmltools::tags$script(
      src=system.file('includes/js/markdown-it.min.js', package='encryptRmd')
    ),
    htmltools::tags$script(
      src=system.file('includes/js/sodium.js', package='encryptRmd'),
      async=NA
    ),
    htmltools::tags$link(
      rel="stylesheet",
      href=system.file('includes/css/encrypted_chunk.css', package='encryptRmd')
    ),
    htmltools::tags$link(
      rel="stylesheet",
      href=system.file('includes/css/hljs_default.css', package='encryptRmd')
    )
  )
}
