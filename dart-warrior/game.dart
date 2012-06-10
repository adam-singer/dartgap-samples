// Copyright (c) 2012 Qalqo, all rights reserved.  
//
// This open source software is governed by the license terms 
// specified in the LICENSE file

/**
 * Various classes needed for keeping track of the game
 */

class Settings {
  Settings() {
    rows = 8;
    cols = 8;
    baseScore = 100;
    numJewelTypes = 7;
  }
  
  int rows, cols, baseScore, numJewelTypes;
}

class JewelPosition {
  JewelPosition(this.x, this.y, this.type);
  
  int x, y, type;
}

class JewelMove {
  JewelMove(this.toX, this.toY, this.fromX, this.fromY, this.type);
  
  int toX, toY, fromX, fromY, type;
}

abstract class BoardEvent<T> {
  BoardEvent(this.type, this.data);
  
  String type;
  T data;
}

class BoardRemoveEvent extends BoardEvent<List<JewelPosition>> {
  BoardRemoveEvent(List<JewelPosition> data): super("remove", data);
}

class BoardScoreEvent extends BoardEvent<int> {
  BoardScoreEvent(int data): super("score", data);
}

class BoardMoveEvent extends BoardEvent<List<JewelMove>> {
  BoardMoveEvent(List<JewelMove> data): super("move", data);
}

class BoardRefilEvent extends BoardEvent<List<List<int>>> {
  BoardRefilEvent(List<List<int>> data): super("refil", data);
}

