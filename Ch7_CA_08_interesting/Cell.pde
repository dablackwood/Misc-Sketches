class Cell {
  float x,y;
  boolean state;
  boolean nextState;
  Cell[] neighbors;
  
  Cell(float ex, float why) {
    x = ex * CELL_SIZE;
    y = why * CELL_SIZE;
    if (random(2) > 1) {
      nextState = true;
    } else {
      nextState = false;
    }
    state = nextState;
    neighbors = new Cell[0];
  }
  
  void addNeighbor(Cell cell) {
    neighbors = (Cell[])append(neighbors,cell);
  }
  
  void calcNextState() {
    int liveCount = 0;
    for (int i=0; i < neighbors.length; i++) {
      if (neighbors[i].state == true) {
        liveCount++;
      }
    }
    if ( state == true) {
      liveCount++;
    }
    if (liveCount < 5) {
      nextState = false;
    } else {
      nextState = true;
    }
    // Create some instability...
    if ( (liveCount == 4) || (liveCount == 5) ) {
      // Flip a coin...
      if (random(2) > 1) {
        nextState = true;
      } else {
        nextState = false;
      }
    }
  }
  
  void drawMe() {
    state = nextState;
    stroke(0);
    if (state == true) {
      fill(0);
    } else {
      fill(255);
    }
    ellipse(x,y, CELL_SIZE, CELL_SIZE);
  }
  
}
