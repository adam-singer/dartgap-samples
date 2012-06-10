// Copyright (c) 2012 Qalqo, all rights reserved.  
//
// This open source software is governed by the license terms 
// specified in the LICENSE file

class SplashScreen extends View {
  SplashScreen(GamePresenter presenter): super("splash-screen", presenter) {
    innerHTML = """
      <h1 class='logo'>Dart <br/>Warrior</h1>
      <span class='continue-text'>Click to continue</span>
    """;
    
    _setupEventHandlers();
  }
  
  _setupEventHandlers() {
    on.click.add((Event e) => presenter.onSplashScreenClick());
  }
}

class MainMenu extends View {
  MainMenu(GamePresenter presenter): super("main-menu", presenter) {
    // TODO externalize strings
    innerHTML = "<h2 class='logo'>Dart <br/>Warrior</h2>";
      
    var menuList = createElement("ul", classes:"menu");
    _addButton("game-screen", "Play", menuList);
    _addButton("hiscore", "Highscore", menuList);
    _addButton("about", "About", menuList);
    _addButton("exit-screen", "Exit", menuList);
    add(menuList);
  }
  
  _addButton(String name, String text, Element target) {
    var button = new Element.html("<button name='$name'>$text</button>");
    button.on.click.add((Event e) {
      var menuClicked = button.attributes['name'];
      presenter.onMainMenuChange(menuClicked);
    });
    
    var menuEntry = new Element.html("<li></li>");
    menuEntry.nodes.add(button);
    target.nodes.add(menuEntry);
  }
}

class GameScreen extends View {
  GameScreen(GamePresenter presenter): super("game-screen", presenter);
}

class HighScores extends View {
  HighScores(GamePresenter presenter): super("high-scores", presenter);
}

class View {
  final GamePresenter presenter;
  Element _wrapped;
  
  View(String widgetId, this.presenter) {
    _wrapped = createElement("section", id:widgetId, classes:"screen");
  }
  
  Set<String> get classes() => _wrapped.classes;
  
  Element get asWidget() => _wrapped;
  
  void add(Element element) => _wrapped.nodes.add(element);

  ElementEvents get on() => _wrapped.on;
  
  void set innerHTML(String html) {
    _wrapped.innerHTML = html;
  }
}