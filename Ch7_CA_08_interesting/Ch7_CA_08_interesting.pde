// See page 130, Listing 7.1 of Generative Art by Matt Pearson
// Added Vichniac vote, with some randomness
// Changing the definition of "neighbor"
// ... results in interesting halftones!

Cell[][] cellArray;
final int CELL_SIZE = 10;
final int NEIGHBOR_SPACING = 2;
int numX, numY;

void setup() {
  size(400,400);
  background(120);
  numX = floor(width / CELL_SIZE);
  numY = floor(height / CELL_SIZE);
  restart();
}

void restart() {
  cellArray = new Cell[numX][numY];
  for (int x=0; x < numX; x++) {
    for (int y=0; y < numY; y++) {
      Cell newCell = new Cell(x,y); // create the Cell
      cellArray[x][y] = newCell; // record it in the array
    }
  }
  for (int x=0; x < numX; x++) {
    for (int y=0; y < numY; y++) {
      // ID neighbors (once removed!)
      int above = y - NEIGHBOR_SPACING;
      int below = y + NEIGHBOR_SPACING;
      int left = x - NEIGHBOR_SPACING;
      int right = x + NEIGHBOR_SPACING;
      // wrapping (with dispersed neighbors)
//      if (above < 0) {above += numY - 1;}
//      if (below > numY-1) {below -= numY;}
//      if (left < 0) {left += numX - 1;}
//      if (right > numX-1) {right -= numX;}

      // Attempt to improve wrapping....
      above = (above + numY) % numY;
      below = (below + numY) % numY;
      right = (right + numX) % numX;
      left = (left + numX) % numX;
      
      // Add neighbors
      cellArray[x][y].addNeighbor(cellArray[left][above]);
      cellArray[x][y].addNeighbor(cellArray[left][y]);
//      println(x + " " + y + " " + left + " " + below);
      cellArray[x][y].addNeighbor(cellArray[left][below]);
      cellArray[x][y].addNeighbor(cellArray[x][above]);
      cellArray[x][y].addNeighbor(cellArray[x][below]);
      cellArray[x][y].addNeighbor(cellArray[right][above]);
      cellArray[x][y].addNeighbor(cellArray[right][y]);
      cellArray[x][y].addNeighbor(cellArray[right][below]);
    }
  }
}

void draw() {
  background(120);
  for (int x=0; x<numX; x++) {
    for (int y=0; y < numY; y++) {
      cellArray[x][y].calcNextState();
    }
  }
  translate(CELL_SIZE/2, CELL_SIZE/2);
  for (int x=0; x<numX; x++) {
    for (int y=0; y < numY; y++) {
      cellArray[x][y].drawMe();
    }
  }
}

void mousePressed() {
  restart();
}
    
