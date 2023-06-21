if quarto.doc.is_format('html') then
  function Div (elem)
    elem.attributes.output_encrypt = nil
    elem.attributes.source_encrypt = nil
    return elem
  end
end
