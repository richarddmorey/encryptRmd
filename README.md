# encryptRmd
R package to encrypt chunk outputs in HTML compiled from Rmd documents

## Installation

```
install.packages('remotes')
remotes::install_github('richarddmorey/encryptRmd')
```

## Usage

See the [example](https://github.com/richarddmorey/encryptRmd/blob/main/inst/examples/rmd_template.Rmd).

1. Create an Rmarkdown document compatible with the output format `rmarkdown::html_document`
2. In the chunk options for the chunks whose outputs you intend to encrypt, add the `output_encrypt` option set equal to the key, e.g.:

````
```{r output_encrypt = 'super_secret_key'}
# chunk code
```
````

3. Change the output format in the header to `encryptRmd::html_document_enc`, e.g.:

```
---
title: "Encrypted document test"
author: "Richard D. Morey"
date: "`r Sys.Date()`"
output: encryptRmd::html_document_enc
---
```

4. Compile the document.

## Decryption

The resulting document will have elements that you can click to decrypt:

---
<img alt="Compiled HTML document with encrypted elements" src="https://github.com/richarddmorey/encryptRmd/assets/1284826/6dc05cae-3b8e-4ff3-bc21-a5871844fd4b" style="width:50%;">

---

Clicking an encrypted element will bring up a box to enter a key:

---
<img alt="Open window to enter key" src="https://github.com/richarddmorey/encryptRmd/assets/1284826/510a4980-b081-43f7-a2e5-633150d6b456" style="width:50%;">

---

When you enter a key, all elements encrypted with that key will be decrypted and displayed.

---
<img alt="Page showing the first element decrypted" src="https://github.com/richarddmorey/encryptRmd/assets/1284826/8b04675c-119f-4bde-9452-8f3e0d29d632" style="width:50%;">

---

## Advanced usage

Will only encrypt elements that are handled by the `output` and `plot` [knitr hooks](https://bookdown.org/yihui/rmarkdown-cookbook/output-hooks.html). If you'd like to encrypt arbitrary content, you can use an `results='asis'` chunk and call the encryption function `encryptRmd::encrypt_content_html`.

If you'd like to use javascript to modify or apply rendering functions to the content after decryption, you can add a listener in the page for the event 'decrypted':

```
window.addEventListener('decrypted', function(e){
  const el = e.target;
  /* do stuff with el */
});
```

For an example, see the function that renders markdown and MathJax in [`inst/includes/encrypted_chunk.js`](https://github.com/richarddmorey/encryptRmd/blob/main/inst/includes/js/encrypted_chunk.js).

### Quarto (and non-html_document Rmds)

It is possible to use this package with other kinds of html documents, if you include the right chunks that inject the dependencies and explicitly set the knitr output hooks. An example can be found in the [examples directory](https://github.com/richarddmorey/encryptRmd/blob/main/inst/examples/quarto_template.qmd).
