PFont fontA; // = loadFont("Aharoni");

// Set number of circles
int count = 32;
//int count = 4;

// Set maximum and minimum circle size
int maxSize = 0.75;
int minSize = 0.125;

class Heart {
    float[] pos;
    float radi;
    float rot;
    float[] vec;
    float rot_d; //Rotation delta

    int dist_cnt;

    Heart(int i) {
	dist_cnt = 1;

	pos = new float[2];
	pos[0]=random(width); // X
	pos[1]=random(height); // Y
	radi=random(minSize,maxSize); 
	vec = new float[2];
	vec[0]=random(-.5,.5); // X Speed
	vec[1]=random(0.4,1.0); // Y Speed
	
	rot = random(0, 2*PI);
	int mul = random(0, 1.0) < 0.5 ? -1 : 1;
	rot_d = mul * random(PI/128, PI/48);
    }

    void draw() {
	pushMatrix();
	// Draw circle
	fill(192,96,96, 228);

	translate(pos[0], pos[1]);
	rotate(rot);

	scale(radi);

	/*
	arc(0-radi/2, 0, radi,radi, PI, PI*2);
	arc(0+radi/2, 0, radi,radi, PI, PI*2);
	triangle(-radi, 0, 
		 radi, 0, 
		 0, 0+1.5*radi);
	*/

	beginShape();
	vertex(0,0);
	bezierVertex( 0,-30, -50,-30, -50, 0);
	bezierVertex( -50,30, 0,35, 0, 60 );
	bezierVertex( 0,35, 50,30, 50, 0 );  
	bezierVertex( 50,-30, 0,-30, 0, 0 );  
	endShape();

	/*		
	fill(50, 50, 200);
	ellipse(0, 0, 10,10);
	fill(50, 200, 50);
	ellipse(0, -30, 10,10);
	ellipse(-50, -30, 10,10);

	fill(50, 50, 200);
	ellipse(-50, 0, 10,10);

	fill(50, 200, 50);
	ellipse(-50, 30, 10,10);
	ellipse(0, 35, 10,10);

	fill(50, 50, 200);
	ellipse(0, 60, 10,10);

	fill(50, 200, 50);
	ellipse(50, 30, 10,10);

	fill(50, 50, 200);
	ellipse(50, 0, 10,10);

	fill(50, 200, 50);
	ellipse(50, -30, 10,10);
	ellipse(0, -30, 10,10);
	*/

	popMatrix();
    }
    
    void update() {
	// Move circle
	pos[0] += vec[0];
	pos[1] += vec[1];
	
	/* Wrap edges of canvas so circles leave the top
	   and re-enter the bottom, etc... */
	float diam=50*radi;
	if( pos[1] > height+diam) { 
	    pos[1] = -diam;       
	    pos[0]=random(width);
	    vec[0]=random(-.5,.5); // X Speed
	    vec[1]=random(0.4,1.0); // Y Speed

	    rot = random(0, 2*PI);
	    int mul = random(0, 1.0) < 0.5 ? -1 : 1;
	    rot_d = mul * random(PI/128, PI/48);
	}

	vec[0] = (vec[0]*dist_cnt + random(-0.5,0.5)) / (dist_cnt + 1);
	vec[1] = (vec[1]*dist_cnt + random(0.4,1.0)) / (dist_cnt + 1);
	if (dist_cnt>1) {
	    dist_cnt --;
	}

	rot += rot_d;

	//console.log(idx, pos[0], pos[1], vec[0], vec[1]);
    }

    void disturb(float x, float y, float r) {
	dist_cnt = 18;
	vec[0] += x;
	vec[1] += y;
    }
};

// Build float array to store circle properties
ArrayList e;

// Set drag switch to false
boolean dragging=false;

void mouseDragged() {
    dragging=true;
}

void mouseReleased() {
    dragging=false;
}

// Set up canvas
void setup(){

    // Frame rate
    frameRate(24);

    // Size of canvas (width,height)
    size(940,198);

    // Stroke/line/border thickness
    strokeWeight(1);

    e = new ArrayList();
    for(int j=0;j< count;j++){
	e.add(new Heart(j));
    }

    fontA = loadFont("Aharoni");
}

int old_mouseX = mouseX;
int old_mouseY = mouseY;

// Begin main draw loop (called 25 times per second)
void draw() {

    // Fill background black
    background(0);

    // Begin looping through circle array
    for (int j=0;j< count;j++){
	Heart f = (Heart)e.get(j);
	// Disable shape stroke/border
	noStroke();

	// Cache diameter and radius of current circle
	float radi=f.radi;

	// If the cursor is within 2x the radius of current circle...
	if( dist(f.pos[0],f.pos[1],mouseX,mouseY) < 50*radi ){
	    // If user has mouse down and is moving...
	    //if(dragging){
		// Move circle to circle position


	    float delta_x = (mouseX - old_mouseX)/8;
	    float delta_y = (mouseY - old_mouseY)/8;

	    if (mouseY > f.pos[1]) {
		//console.log("under", f.rot_d, delta_x/100);
		f.rot_d -= delta_x/100;
	    } else {
		//console.log("over", f.rot_d, delta_x/100);
		f.rot_d += delta_x/100;
	    }

	    f.disturb(delta_x, delta_y, 1.0 );
	}
	//console.log(mouseX, mouseY);

	f.draw();
	f.update();
    }

    //PFont font;
    // The font must be located in the sketch's
    // "data" directory to load successfully
    fill(190, 190, 190);

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
