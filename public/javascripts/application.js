function createValentineFormSubmit() {
  Form.disable('create_valentine_form');
  $('create_valentine_form_submit').value = "Sending";
}

function createValentineFormComplete() {
  Form.enable('create_valentine_form');
  $('create_valentine_form_submit').value = "...send my valentine!";
}