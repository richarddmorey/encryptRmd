HTMLCollection.prototype.forEach = Array.prototype.forEach

window.sodium = {
  onload: function (sodium) {
    let h = sodium.crypto_generichash(64, sodium.from_string('test'));
    console.log(sodium.to_hex(h));
  }
};

/* Set the width of the sidebar to 250px (show it) */
function openNav() {
  const el = document.getElementById("mySidepanel");
  el.style.width = "250px";
  el.querySelector('input').focus();
}

/* Set the width of the sidebar to 0 (hide it) */
function closeNav() {
  const el = document.getElementById("mySidepanel");
  el.querySelector('input').value = '';
  el.style.width = "0";
}

function decrypt(el, key){
  if(!key) return;
  const ctEl = el.getElementsByClassName('ct')[0];
  const text = ctEl.innerText.trim();

  const b_key = sodium.crypto_generichash(32, sodium.from_string(key));
  const b_text = sodium.from_base64(text, sodium.base64_variants.ORIGINAL);
  const b_nonce = sodium.from_base64(el.dataset.nonce, sodium.base64_variants.ORIGINAL);
  const b_tag = sodium.from_base64(el.dataset.tag, sodium.base64_variants.ORIGINAL);

  try{
    const out = sodium.crypto_secretbox_open_easy(b_text, b_nonce, b_key);
    const dec = sodium.to_string(out);
    el.innerHTML = dec;
    const event = new Event("decrypted0", { bubbles: true });
    el.dispatchEvent(event);
    closeNav();
  }
  catch(err){
    // throw new Error(err);
  }
}

window.addEventListener('decrypted0', function(e){
  const el = e.target;
  el.classList.remove('encrypted');
  el.classList.add('decrypted');
  el.getElementsByClassName('markdownme')
    .forEach((el, i)=>{
      el.innerHTML = markdownit().render(
          el.innerHTML
        )
    });
  const els = el.getElementsByClassName('mathjaxme');
  if(typeof(MathJax) !== 'undefined' && typeof MathJax?.Hub?.Queue === 'function'){
    MathJax.Hub.Queue(["Typeset",MathJax.Hub,els]);
  }
  const event = new Event("decrypted", { bubbles: true });
  el.dispatchEvent(event);
})


function triggerDecrypt(el){
  const key = el.value;
  const text = document.querySelectorAll('span.encrypted');
  text.forEach((el,i)=>{
      decrypt(el, key);
  });
}
