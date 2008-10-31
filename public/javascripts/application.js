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
