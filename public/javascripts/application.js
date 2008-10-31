function createValentineFormSubmit() {
  Form.disable('create_valentine_form');
  $('create_valentine_form_submit').value = "Sending";
}

function createValentineFormComplete() {
  Form.enable('create_valentine_form');
  $('create_valentine_form_submit').value = "Send my valentine!";
}

function createFrightFormSubmit() {
  Form.disable('create_fright_form');
  $('create_fright_form_submit').value = "Channelling...";
}

function createFrightFormComplete() {
  Form.enable('create_fright_form');
  $('create_fright_form_submit').value = "Send my fright!";
}

function setActiveStyleSheet(title) {
   var i, a, main;
   for(i=0; (a = document.getElementsByTagName("link")[i]); i++) {
     if(a.getAttribute("rel").indexOf("style") != -1
        && a.getAttribute("title")) {
       a.disabled = true;
       if(a.getAttribute("title") == title) a.disabled = false;
     }
   }
}

function doTransition() {
  new Effect.Appear('lightning', {duration: 0.1, queue: 'end'});
  new Effect.Appear('darkness', {duration: 0.1, queue: 'end'});
  new Effect.Fade('darkness', {duration: 0.1, queue: 'end'});
  new Effect.Appear('darkness', {duration: 0.1, queue: 'end',
    afterUpdate: function callback(obj) {
      setActiveStyleSheet('frights');
  }});
  new Effect.Fade('darkness', {duration: 0.1, queue: 'end'});
  new Effect.Fade('lightning', {duration: 0.1, queue: 'end'});
  
  new Effect.Shrink('bunnyloveheading', {duration: 0.2, queue: 'end'});
  new Effect.Appear('bunnyfrightheading', {duration: 0.1, queue: 'with-last'});
  new Effect.Pulsate('bunnyfrightheading', {duration: 0.5, queue: 'with-last'});
  
  new Effect.Shrink('bunnylovesubheading', {duration: 0.2, queue: 'with-last'});
  new Effect.Appear('bunnyfrightsubheading', {duration: 0.1, queue: 'with-last'});
  new Effect.Pulsate('bunnyfrightsubheading', {duration: 0.5, queue: 'with-last'});
}

function spooky() {
  setTimeout(doTransition, 2000);
}
