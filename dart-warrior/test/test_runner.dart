// Copyright (c) 2012 Qalqo, all rights reserved.  
//
// This open source software is governed by the license terms 
// specified in the LICENSE file

#library("qalqo:dartwarrior:test");

#import("/Applications/dart/dart-sdk/lib/unittest/unittest.dart");

#source("../board.dart");
#source("../game.dart");
#source("board_test.dart");

// TODO figure out how to test logic in game presenter (ensure that mock interfaces gets injected by factory constructor)

main() {
  new BoardTest();
}

