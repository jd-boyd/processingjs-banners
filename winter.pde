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
int count = 32;

// Set maximum and minimum circle size
int maxSize = 100;
int minSize = 20;

class Flake {
    float[] pos;
    float radi;
    float[] vec;
    int idx;

    int dist_cnt;

    Flake(int i, r) {
	dist_cnt = 1;
	idx = i;
	pos = new float[2];
	pos[0]=random(width); // X
	pos[1]=random(height); // Y
	radi=r; //random(minSize,maxSize); // Radius
	vec = new float[2];
	vec[0]=random(-.5,.5); // X Speed
	vec[1]=random(0.4,1.0); // Y Speed
    }

    void draw() {
	tint(100, 153, 204);
	image(flakes[idx%16], pos[0]-radi, pos[1]-radi);
	// Draw circle
	//ellipse(pos[0],pos[1],radi*2,radi*2);
    }
    
    void update() {
	// Move circle
	pos[0] += vec[0];
	pos[1] += vec[1];
	
	/* Wrap edges of canvas so circles leave the top
	   and re-enter the bottom, etc... */
	float diam=radi/2;
	if( pos[1] > height+diam) { 
	    pos[1] = -diam;       
	    pos[0]=random(width);
	    vec[0]=random(-.5,.5); // X Speed
	    vec[1]=random(0.4,1.0); // Y Speed
	}

	vec[0] = (vec[0]*dist_cnt + random(-0.5,0.5)) / (dist_cnt + 1);
	vec[1] = (vec[1]*dist_cnt + random(0.4,1.0)) / (dist_cnt + 1);
	if (dist_cnt>1) {
	    dist_cnt --;
	}

	//console.log(idx, pos[0], pos[1], vec[0], vec[1]);
    }

    void disturb(float x, float y) {
	dist_cnt = 18;
	vec[0] += x;
	vec[1] += y;
    }
};

// Build float array to store circle properties
//float[][] e = new float[count][5];
ArrayList e;// = new Flake[count];

// Set drag switch to false
boolean dragging=false;

void mouseDragged() {
    dragging=true;
}

void mouseReleased() {
    dragging=false;
}

PImage[] flakes = new PImage[16];

// Set up canvas
void setup(){

    // Frame rate
    frameRate(24);

    // Size of canvas (width,height)
    size(940,198);

    // Stroke/line/border thickness
    strokeWeight(1);
    PImage b;
    PImage c;

    // Initiate array with random values for circles
    for (j=0; j<16; j+=2) {
	b = loadImage("flake_pngs/flake_" + (j/2+1) + ".png");
	c = createImage(213, 213, RGB);
	c.copy(b, 0, 0, 213, 213, 0, 0, 213, 213);

	b.filter(BLUR, 5);
	b.resize(0, 30);

	c.resize(0, 50);

	flakes[j] = b;
	flakes[j+1] = c;
    } 

    e = new ArrayList();
    for(int j=0;j< count;j++){
	e.add(new Flake(j, (j%2)?25:15) );
    }

    fontA = loadFont("Aharoni");
}

int old_mouseX = mouseX;
int old_mouseY = mouseY;

// Begin main draw loop (called 25 times per second)
void draw() {

    // Fill background black
    background(0);
    //#25305f

    // Begin looping through circle array
    for (int j=0;j< count;j++){
	Flake f = (Flake)e.get(j);
	// Disable shape stroke/border
	noStroke();

	// Cache diameter and radius of current circle
	float radi=f.radi;

	// If the cursor is within 2x the radius of current circle...
	if( dist(f.pos[0],f.pos[1],mouseX,mouseY) < radi ){
	    // If user has mouse down and is moving...
	    //if(dragging){
		// Move circle to circle position
		f.disturb((mouseX - old_mouseX)/8,(mouseY - old_mouseY)/8 );
		//console.log(j, f[3], f[4]);
		//}
	} else {
	    // Keep fill color blue
	    fill(64,128,187,100);
	}
	//console.log(mouseX, mouseY);

	f.draw();
	f.update();
    }

    //PFont font;
    // The font must be located in the sketch's
    // "data" directory to load successfully
    fill(170, 150, 153);

    stroke(50, 200, 50);
    textFont(fontA, 96);
    text("JDBoyd", 20, 25+96);
    // Set the font and its size (in units of pixels)

    textFont(fontA, 24);
    text("Acurately predicting 20 out of the", 550, 96);
    text("last 4 zebra stampedes.", 660, 25+96);

    old_mouseX = mouseX;
    old_mouseY = mouseY;
}
