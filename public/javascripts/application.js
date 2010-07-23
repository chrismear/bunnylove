/*
Copyright 2007, 2008, 2009, 2010 Chris Mear

This file is part of Bunnylove.

Bunnylove is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Bunnylove is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with Bunnylove.  If not, see <http://www.gnu.org/licenses/>.
*/

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
  
  document.title = "bunny fright";
  $('signupsubmit').value = "Sign me up for a confusing night of fear and whuffles!";
  $('loginsubmit').value = "Begin the terror";
}

function spooky() {
  setTimeout(doTransition, 2000);
}
