
#' Output format to enable encrypted chunks in html_document
#'
#' @param ... Arguments to be passed `rmarkdown::html_document`
#'
#' @returns Returns an output_format that extends html_document
#' @export
#' @importFrom htmltools htmlDependency
#' @importFrom rmarkdown output_format knitr_options html_document pandoc_options includes
#' @importFrom utils packageName
#'
html_document_enc <- function(...){

  # locations of resource files in the package
  pkg_resource = function(...) {
    system.file(..., package = packageName())
  }

  main_dep = htmltools::htmlDependency(
    'encryptRmd', '0.1',
    src = pkg_resource('includes'),
    script = 'js/encrypted_chunk.js',
    stylesheet = 'css/encrypted_chunk.css'
  )

  sodium_dep = htmltools::htmlDependency(
    'sodium', '0.7.11',
    src = pkg_resource('includes'),
    script = 'js/sodium.js'
  )

  markdownit_dep = htmltools::htmlDependency(
    'markdown-it', '13.0.1',
    src = pkg_resource('includes'),
    script = 'js/markdown-it.min.js'
  )

  dots = list(...)

  if(is.null(dots$includes)){
    dots$includes = rmarkdown::includes(
      after_body = pkg_resource('includes/html/key_entry.html')
    )
  }else{
    dots$includes$after_body = c(
      pkg_resource('includes/html/key_entry.html'),
      dots$includes$after_body
    )
  }

  dots$extra_dependencies = list(main_dep, sodium_dep, markdownit_dep)

  rmarkdown::output_format(
    knitr = rmarkdown::knitr_options(
      opts_chunk = list(
        dev = 'png',
        dpi = 96,
        fig.width = 7,
        fig.height = 5,
        fig.retina = 2
      ),
      knit_hooks = list(
        output = enc_out_hook,
        plot = enc_plot_hook
      )
    ),
    pandoc = rmarkdown::pandoc_options(to = "html"),
    keep_md = NULL,
    base_format = do.call(rmarkdown::html_document, dots)
  )
}

#' @importFrom knitr hooks_markdown
enc_out_hook <- function(x, options) {

  out <- knitr::hooks_markdown()$output(x, options)

  if(is.null(options$output_encrypt))
    return(out)

  return(encrypt_content_html(out,options$output_encrypt, md = TRUE))

}

#' @importFrom knitr hooks_markdown hook_plot_html
enc_plot_hook <- function(x, options) {

  if(is.null(options$output_encrypt))
    return(knitr::hooks_markdown()$plot(x, options))

  out = knitr::hook_plot_html(knitr::image_uri(x), options)
  return(encrypt_content_html(out,options$output_encrypt, md = FALSE))
}

