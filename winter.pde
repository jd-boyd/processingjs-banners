/* 
   @pjs preload="flake_pngs/flake_1.png,flake_pngs/flake_2.png,flake_pngs/flake_3.png,flake_pngs/flake_4.png,flake_pngs/flake_5.png,flake_pngs/flake_6.png,flake_pngs/flake_7.png,flake_pngs/flake_8.png"; 
*/
/*
  PROCESSINGJS.COM HEADER ANIMATION
  MIT License - Hyper-Metrix.com/F1LT3R
  Native Processing compatible
*/


PFont fontA; // = loadFont("Aharoni");

// Set number of circles
int count = 20;

// Set maximum and minimum circle size
int maxSize = 100;
int minSize = 20;

// Build float array to store circle properties
float[][] e = new float[count][5];

// Set size of dot in circle center
float ds=2;

// Selected mode switch
int sel = 0;

// Set drag switch to false
boolean dragging=false;

// If use drags mouse...
void mouseDragged(){

  // Set drag switch to true
  dragging=true;
}

// If user releases mouse...
void mouseReleased(){

  // ..user is no-longer dragging
  dragging=false;
}

PImage[] flakes = new PImage[8];

// Set up canvas
void setup(){

  // Frame rate
  frameRate(15);

  // Size of canvas (width,height)
  size(940,198);

  // Stroke/line/border thickness
  strokeWeight(1);

  // Initiate array with random values for circles
  for(int j=0;j< count;j++){
    e[j][0]=random(width); // X
    e[j][1]=random(height); // Y
    e[j][2]=random(minSize,maxSize); // Radius
    e[j][3]=random(-.5,.5); // X Speed
    e[j][4]=random(0.1,0.5); // Y Speed
  }
    PImage b;  

  for (j=0; j<8; j+=1) {
      b = loadImage("flake_pngs/flake_" + (j+1) + ".png");
      b.filter(THRESHOLD, 0.1);
      if (!(j%4)) {
	  b.resize(0, 30);
	  b.filter(BLUR, 10);
      } else {
	  b.resize(0, 50);
      }
      flakes[j] = b;
  } 

  fontA = loadFont("Aharoni");

}

// Begin main draw loop (called 25 times per second)
void draw(){

   // Fill background black
   background(0);
   //#25305f

  // Begin looping through circle array
  for (int j=0;j< count;j++){

    // Disable shape stroke/border
    noStroke();

    // Cache diameter and radius of current circle
    float radi=e[j][2];
    float diam=radi/2;

    // If the cursor is within 2x the radius of current circle...
    if( dist(e[j][0],e[j][1],mouseX,mouseY) < radi ){

      // Change fill color to green.
      fill(64,187,128,100);

      // Remember user has circle "selected"
      sel=1;

      // If user has mouse down and is moving...
      if(dragging){

        // Move circle to circle position
        e[j][0]=mouseX;
        e[j][1]=mouseY;
      }
    } else {
      // Keep fill color blue
      fill(64,128,187,100);

      // User has nothing "selected"
      sel=0;
    }

    // Draw circle
    //    ellipse(e[j][0],e[j][1],radi,radi);
    image(flakes[j%8], e[j][0],e[j][1]);

    // Move circle
    e[j][0]+=e[j][3];
    e[j][1]+=e[j][4];


    /* Wrap edges of canvas so circles leave the top
       and re-enter the bottom, etc... */
    if( e[j][0] < -diam      ){ e[j][0] = width+diam;  }
    if( e[j][0] > width+diam ){ e[j][0] = -diam;       }
    if( e[j][1] < 0-diam     ){ e[j][1] = height+diam; }
    if( e[j][1] > height+diam){ e[j][1] = -diam;       }

    // If current circle is selected...
    if(sel==1){

      // Set fill color of center dot to white..
      fill(255,255,255,255);

      // ..and set stroke color of line to green.
      //stroke(128,255,0,100);
    } else {

      // otherwise set center dot color to black..
      fill(0,0,0,255);

      // and set line color to turquoise.
      //stroke(64,128,128,255);
    }

    // Loop through all circles
    for(int k=0;k< count;k++){

      // If the circles are close...
      if( dist(e[j][0],e[j][1],e[k][0],e[k][1]) < radi){

        // Stroke a line from current circle to adjacent circle
        //line(e[j][0],e[j][1],e[k][0],e[k][1]);
      }
    }

    // Turn off stroke/border
    noStroke();

    // Draw dot in center of circle
    //rect(e[j][0]-ds,e[j][1]-ds,ds*2,ds*2);
  }

//PFont font;
// The font must be located in the sketch's
// "data" directory to load successfully
//font = loadFont("FFScala-32.vlw");
//textFont(font);
fill(170, 150, 153);
//text("JDBoyd", 15, 30);
    stroke(50, 200, 50);
    textFont(fontA, 96);
    text("JDBoyd", 20, 25+96);
  // Set the font and its size (in units of pixels)

  textFont(fontA, 24);
  text("Acurately predicting 20 out of the", 550, 96);
  text("last 4 zebra stampedes.", 660, 25+96);


}
