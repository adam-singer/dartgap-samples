// Copyright (c) 2012 Qalqo, all rights reserved.  
//
// This open source software is governed by the license terms 
// specified in the LICENSE file

#library("qalqo:dartwarrior");

#import("dart:html");

#source("board.dart");
#source("dom_helper.dart");
#source("game.dart");
#source("views.dart");
#source("presenters.dart");

#resource("styles/main.css");
#resource("styles/fontfaces.css");
#resource("styles/mobile.css");

void main() {
  browserSetup();
  new DartWarrior();
}

class DartWarrior {
  DartWarrior() {
    var presenter = new GamePresenter();
    presenter.show();
  }
}
