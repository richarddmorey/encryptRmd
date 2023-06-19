
#' Encrypt content for placing into html_document
#'
#' @param content content to encrypt
#' @param key key to use for the encryption
#' @param md content is to be rendered as markdown on decryption
#' @param mathjax content is to be rendered as MathJax on decryption
#' @param character output as a character vector (if FALSE, an `htmltools` tag)
#'
#' @return Returns an protected HTML span containing the encrpyted information
#' @export
#' @importFrom htmltools tags htmlPreserve HTML
#' @importFrom stringi stri_enc_toutf8
#' @importFrom sodium hash random data_encrypt
#' @importFrom base64enc base64encode
#'
encrypt_content_html = function(content, key, md = FALSE, mathjax = FALSE, character = TRUE){

  paste(
    if(md) "markdownme",
    if(mathjax) "mathjaxme"
  ) |>
    trimws() -> class

  content |>
    htmltools::HTML() |>
    htmltools::tags$span(class = class) |>
    as.character() |>
    stringi::stri_enc_toutf8() |>
    charToRaw() -> raw_out

  key = sodium::hash(charToRaw(key), size = 32)
  nonce = sodium::random(24)
  tag <- sodium::data_tag(raw_out, key)

  sodium::data_encrypt(raw_out, key, nonce) |>
    base64enc::base64encode() -> cypher64

  spn = htmltools::tags$span(
    htmltools::tags$span(cypher64, class = 'ct'),
    class="encrypted",
    'data-nonce'= base64enc::base64encode(nonce),
    'data-tag' = base64enc::base64encode(tag),
    onclick = "openNav()"
  )

  if(character)
    spn = as.character(spn)

  return(htmltools::htmlPreserve(spn))
}


