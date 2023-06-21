
#' Perform encryptRmd setup for non-html_documents
#'
#' This function should be called in the first chunk, with echo=FALSE and include=TRUE.
#' It will inject the necessary dependencies and setup knitr to transform the outputs and
#' plots from chunks.
#'
#' @param jquery Include jquery? If the document type already includes it, this should be FALSE
#'
#' @return an htmltools tagList
#' @export
#' @importFrom htmltools tagList tags HTML
#' @importFrom knitr knit_hooks
#'
#' @examples
encryptRmd_general_setup <- function(jquery = FALSE){

  local({
    knitr::knit_hooks$set(
      output = enc_out_hook,
      plot = enc_plot_hook
    )
  })

  htmltools::tagList(
    htmltools::tags$div(
      system.file('includes/html/key_entry.html', package='encryptRmd') |>
        readLines() |> htmltools::HTML()
    ),
    if(jquery){htmltools::tags$script(
      src=system.file('includes/js/jquery-3.7.0.min.js', package='encryptRmd')
    )},
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
    )
  )
}
