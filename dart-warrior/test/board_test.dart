// Copyright (c) 2012 Qalqo, all rights reserved.  
//
// This open source software is governed by the license terms 
// specified in the LICENSE file

class BoardTest {
  BoardTest() {
    test("board", () {
      var board = new Board();
      board.initialize(() => print("first board"));
      board.printBoard();
      bool swaped = false;
      while(swaped == false) {
        board.swap(4,3,4,2, (e,b) {
          swaped = b;
        });
        if(swaped == false) {
          board.initialize(() => print("swap impossible reinitialize board"));
        }
      }
      print("final board");
      board.printBoard();
    });
  }
}
