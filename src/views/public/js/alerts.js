function sendAlert(messageType, message){
  function removeElementsByClass(className){
    const elements = document.getElementsByClassName(className);
    while(elements.length > 0){
      elements[0].parentNode.removeChild(elements[0]);
    }
  }

  const alertBoxId = Math.floor(Math.random() * (999 - 0 + 1) + 0);

  const body = document.querySelector("body")
  body.innerHTML = body.innerHTML + `<div class="alert-box alert-box-${alertBoxId} ${messageType}">${message}</div>`

  setTimeout(()=> {
    removeElementsByClass(`alert-box-${alertBoxId}`)
  }, 3000)

}
