//From: http://processingjs.org/learning/topic/conway

// All Examples Written by Casey Reas and Ben Fry
// unless otherwise stated.
int sx, sy;
int off_x, off_y;
float density = 0.5;
int[][][] world;

int sizeDiv = 16;

void setup()
{
  size(940, 198);
  frameRate(10);
  sx = Math.floor(width/sizeDiv);
  sy = Math.floor(height/sizeDiv);

  off_x=Math.floor((width - sx*sizeDiv)/2);
  off_y=Math.floor((height - sy*sizeDiv)/2);

  console.log((sx*sy) + " cells in world.");
  world = new int[sx][sy][2];

  stroke(50, 200, 50);
  noFill();

  // Set random cells to 'on'
  for (int i = 0; i < sx * sy * density; i++) {
    world[(int)random(sx)][(int)random(sy)][1] = 1;
  }
}

void mouseMoved() {
     var x=Math.floor((mouseX-off_x) / sizeDiv);
     var y=Math.floor((mouseY-off_y) / sizeDiv);

     if(x>=1) {
       world[x-1][y][1]=1;
     }
     if(y>=1) {
       world[x][y-1][1]=1;
     }
     if (x<sx-1) {
       world[x+1][y][1]=1;
     }
     if (y<sy-1) {
       world[x][y+1][1]=1;
     }
}

void draw()
{
  background(0, 0, 50);

  // Drawing and update cycle
  for (int x = 0; x < sx; x=x+1) {
    for (int y = 0; y < sy; y=y+1) {
      //if (world[x][y][1] == 1)
      // Change recommended by The.Lucky.Mutt
      if ((world[x][y][1] == 1) || (world[x][y][1] == 0 &&
  world[x][y][0] == 1))
      {
        world[x][y][0] = 1;
        rect(x*sizeDiv + off_x, y*sizeDiv + off_y, sizeDiv-3, sizeDiv-3);
      }
      if (world[x][y][1] == -1)
      {
        world[x][y][0] = 0;
      }
      world[x][y][1] = 0;
    }
  }
  // Birth and death cycle
  for (int x = 0; x < sx; x=x+1) {
    for (int y = 0; y < sy; y=y+1) {
      int count = neighbors(x, y);
      if (count == 3 && world[x][y][0] == 0)
      {
        world[x][y][1] = 1;
      }
      if ((count < 2 || count > 3) && world[x][y][0] == 1)
     {
        world[x][y][1] = -1;
      }
    }
  }
}

// Count the number of adjacent cells 'on'
int neighbors(int x, int y)
{
  int r = (x + 1) % sx;
  int l = (x + sx - 1) % sx;

  int u = (y + 1) % sy;
  int d = (y + sy - 1) % sy;
  return world[r][y][0] +
         world[x][u][0] +
         world[l][y][0] +
         world[x][d][0] +
         world[r][u][0] +
         world[l][u][0] +
         world[l][d][0] +
         world[r][d][0];
}
