// Copyright (c) 2012 Qalqo, all rights reserved.  
//
// This open source software is governed by the license terms 
// specified in the LICENSE file

class Board {
  fillBoard() {
    jewels = [];
    for(var x=0; x<cols; x++) {
      jewels.add([]);
      for(var y=0; y<rows; y++) {
        var type = randomJewel();
        while((type == getJewel(x-1,y) && type == getJewel(x-2,y)) ||
              (type == getJewel(x,y-1) && type == getJewel(x,y-2))) {
          // Pick a new jewel as the existing was already aligned
          type = randomJewel();
        }
        jewels[x].add(randomJewel());
      }
    }
    // Recursive fill if new board has no moves
    if(!hasMoves()) {
      fillBoard();
    }
  }
  
  printBoard() {
    var str = "";
    for(var y=0; y<rows; y++) {
      for(var x=0; x<cols; x++) {
        str = "${str}${getJewel(x, y)} ";
      }
    }
    str = str.concat("\r\n");
    print(str);
  }
  
  initialize(callback) {
    var settings = new Settings();
    rows = settings.rows;
    cols = settings.cols;
    baseScore = settings.baseScore;
    numJewelTypes = settings.numJewelTypes;
    
    fillBoard();
    callback();
  }
  
  int randomJewel() => (Math.random() * numJewelTypes).floor().toInt();
  
  int getJewel(int x, int y) {
    if(x < 0 || x > cols-1 || y<0 || y>rows-1) {
      return -1;
    }
    return jewels[x][y];
  }
  
  // Check if jewels are chained together
  int checkChain(int x, int y) {
    var type = getJewel(x, y);
    var left = 0, right = 0, down = 0, up = 0;
    // Check right
    while(type == getJewel(x + right + 1, y)) {
      right++;
    }
    // Check left
    while(type == getJewel(x - left - 1, y)) {
      left++;
    }
    // Check up
    while(type == getJewel(x, y + up + 1)) {
      up++;
    }
    // Check down
    while(type == getJewel(x, y - down - 1)) {
      down++;
    }
    return Math.max(left + 1 + right, up + 1 + down);
  }
 
  // True when we can swap (x1,y1) with (x2,y2)
  bool canSwap(int x1, int y1, int x2, int y2) {
    var type1 = getJewel(x1, y1);
    var type2 = getJewel(x2, y2);
    if(!isAdjacent(x1,y1,x2,y2)) {
      return false;
    }
    // Temporarily swap jewels
    jewels[x1][y1] = type2;
    jewels[x2][y2] = type1;
    bool chain = checkChain(x2, y2) > 2 || checkChain(x1, y1) > 2;
    // Put back
    jewels[x1][y1] = type1;
    jewels[x2][y2] = type2;
    
    return chain;
  }
  
  // True when (x1,y1) and (x2,y2) are neighbors
  bool isAdjacent(int x1, int y1, int x2, int y2) {
    var dx = (x1 - x2).abs();
    var dy = (y1 - y2).abs();
    return (dx + dy == 1);
  }
  
  /*
   * Check board status, remove jewels that are chained and add new ones from the top
   *
   * Returns list of events that happend on the board so we can animate it later
   */
  List<BoardEvent> check(List<BoardEvent> events) {
    var chains = getChains();
    bool hadChains = false;
    int score = 0;
    List<JewelPosition> removed = [];
    List<JewelMove> moved = [];
    var gaps = [];
    
    for(var x=0; x<cols; x++) {
      gaps.add(0);
      // Move existing jewels down
      for(var y=rows-1; y>=0; y--) {
        var jewel = getJewel(x,y);
        if(chains[x][y] > 2) {
          hadChains = true;
          gaps[x] = gaps[x]++;
          removed.add(new JewelPosition(x, y, jewel));
          // Add points to score
          score += baseScore * Math.pow(2, (chains[x][y] - 3));
        } else if(gaps[x] > 0) {
          moved.add(new JewelMove(x,y+gaps[x], x,y, jewel));
          jewels[x][y + gaps[x]] = jewel;
        }
      }
      // Fill from top
      for(var y=0; y<gaps[x]; y++) {
        var newJewel = randomJewel();
        jewels[x][y] = newJewel;
        moved.add(new JewelMove(x,y, x,y-gaps[x], newJewel));
      }
    }
    
    // Check to see if the newly added jewels created chains, if so remove them
    if(hadChains) {
      events.add(new BoardRemoveEvent(removed));
      events.add(new BoardScoreEvent(score));
      events.add(new BoardMoveEvent(moved));
      // Refil if no more moves
      if(!hasMoves()) {
        fillBoard();
        events.add(new BoardRefilEvent(getBoard()));
      }
      return check(events);
    } 
    return events;
  }
  
  // True when moves are possible
  bool hasMoves() {
    for(var x=0; x<cols; x++) {
      for(var y=0; y<rows; y++) {
        if(canJewelMove(x,y)) {
          return true;
        }
      }
    }
    return false;
  }
  
  // Check if a jewel can move
  bool canJewelMove(int x, int y) {
    bool canMove = (
        (x > 0      && canSwap(x,y, x-1,y)) ||
        (x < cols-1 && canSwap(x,y, x+1,y)) ||
        (y > 0      && canSwap(x,y, x,y-1)) ||
        (y < rows-1 && canSwap(x,y, x,y+1)) 
    );
    return canMove;
  }
  
  // Returns a two-dimensional array of chain-lengths
  List<List<int>> getChains() {
    List<List<int>> chains = [];
    for(var x=0; x<cols; x++) {
      chains.add([]);
      for(var y=0; y<rows; y++) {
        chains[x].add(checkChain(x,y));
      }
    }
    return chains;
  }
  
  // Create a copy of the jewel board
  List<List<int>> getBoard() {
    var copy = [];
    for(var x=0; x<cols; x++) {
      copy.add(new List.from(jewels[x]));
    }
    return copy;
  }
  
  // If possible swap the two jewels and call callback
  swap(int x1, int y1, int x2, int y2, callback(List<BoardEvent> boardEvents, bool swaped)) {
    var events = new List<BoardEvent>();
    var tmp;
    if(canSwap(x1,y1, x2,y2)) {
      // Swap the jewels
      tmp = getJewel(x1,y1);
      jewels[x1][y1] = getJewel(x2,y2);
      jewels[x2][y2] = tmp;
      // Check the board
      callback(check(events), true);
    } else {
      callback(events, false);
    }
  }
  
  int rows, cols, baseScore, numJewelTypes;
  List<List<int>> jewels;
}
