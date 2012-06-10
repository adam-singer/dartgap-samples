// Copyright (c) 2012 Qalqo, all rights reserved.  
//
// This open source software is governed by the license terms 
// specified in the LICENSE file

Element createElement(String type, [String id = null, String text = null, Dynamic classes = null]) {
  var element = new Element.tag(type);
  if(id != null) element.id = id;
  if(text != null) element.innerHTML += text;
  if(classes != null) {
    (classes is List) ? element.classes.addAll(classes) : element.classes.add(classes);
  }
  
  return element;
}

// TODO feature detect like on page 67
featureDetect() {
  var navigator = window.navigator; 
  if(navigator.standalone == null) {
    print("not running in iOS browser");
  } else if (navigator.standalone == false) {
    print("using mobile safari");
  } else {
    print("running standalone app on iOS");
  }
}

browserSetup() {
  // game uses entire screen area so prevent scrolling by disabling touchmove
  document.on.touchMove.add((Event e) => e.preventDefault()); 
}
