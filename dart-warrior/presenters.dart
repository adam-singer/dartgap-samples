// Copyright (c) 2012 Qalqo, all rights reserved.  
//
// This open source software is governed by the license terms 
// specified in the LICENSE file

class GamePresenter {
  GamePresenter() {
    // TODO feature detect that window.navigator.standalone exists
    _container = createElement("div", id:"game");
    document.body.nodes.add(_container);
    
    _splashScreen = new SplashScreen(this);
    _mainMenu = new MainMenu(this);
    _gameScreen = new GameScreen(this);
    _highScores = new HighScores(this);
  }
  
  void onSplashScreenClick() {
    _showView(_mainMenu);
  }
  
  void onMainMenuChange(String target) {
    var view;
    switch(target) {
    case "game-screen":
      view = _gameScreen;
      break;
    case "hiscore":
      view = _highScores;
      break;
    case "exit-screen":
      view = _splashScreen;
      break;
    case "about":
      view = _splashScreen;
      break;
    default:
      throw new IllegalArgumentException("unhandled target $target");
    }
    _showView(view);
  }
  
  _showView(View view) {
    _container.nodes = [view.asWidget];
    view.classes.add("active");
  }
  
  show() => _showView(_splashScreen);
  
  View _splashScreen, _mainMenu, _gameScreen, _highScores;
  DivElement _container;
}