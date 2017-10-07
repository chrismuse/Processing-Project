/*
Chris Muse LMC 2700 Project 2
I have created a storm system with color changing snow flakes.
The storm system will take the place of the cursor and will change the color of the snowflakes on mouseclick.
Dragging the mouse will cause the snow to stop falling. The color of the snow will reset to white upon release.
*/


PShape cloud, pieceOne, pieceTwo, pieceThree, pieceFour, piece5;
boolean raining = false;
RainSystem drops;

void setup() {
  size(700, 700);
  drops = new RainSystem(new PVector(mouseX, mouseY));

  // Create the shape group
  cloud = createShape(GROUP);

  // Make five shapes
  noCursor();
  frameRate(60);
  noStroke();
  pieceOne = createShape(ELLIPSE, 15, 40, 120, 120);
  pieceOne.setFill(color(100));
  pieceTwo = createShape(ELLIPSE, 200, 80, 90, 90);
  pieceTwo.setFill(color(100));
  pieceThree = createShape(ELLIPSE, 100, 100, 200, 100);
  pieceThree.setFill(color(100));
  pieceFour = createShape(ELLIPSE, 100, 40, 145, 100);
  pieceFour.setFill(color(100));
  piece5 = createShape(ELLIPSE, 0, 100, 60, 60);
  piece5.setFill(color(100));

  // Add the two "child" shapes to the parent group
  cloud.addChild(pieceOne);
  cloud.addChild(pieceTwo);
  cloud.addChild(pieceThree);
  cloud.addChild(pieceFour);
  cloud.addChild(piece5);
}

//Begins running the Snowstorm and draws the cloud
void draw() {
  background(204);
  translate(50, 15);
  drops.addParticle();
  drops.run();
  shape(cloud, mouseX, mouseY); // Draw the group
}

// interactive portion - Click the mouse to change the color of the snowflakes
void mousePressed() {
  drops.changeColor();
}

//Drag the mouse to stop the snow from falling; upon release the snow will return to its white color
void mouseDragged() {
  drops.pause();
}
void mouseReleased() {
  drops.unpause();
}


// A class to describe a group of Snow drops
// An ArrayList is used to manage the list of Particles 

class RainSystem {
  ArrayList<Drop> drops;
  PVector origin;
  int r = 255;
  int g = 255;
  int b = 255;
  boolean pause = false;

  RainSystem(PVector position) {
    origin = position.copy();
    drops = new ArrayList<Drop>();
  }

//Creates movable Particle System with custom RGB values
  void addParticle() {
    if (pause) {
      r = 255;
      g = 255;
      b = 255;
    } else {
      Drop snow = new Drop(new PVector(mouseX + 80, mouseY + 60),r,g,b);
      drops.add(snow);
    }
  }
  
  void pause(){
    pause = true;
  }
  
  void unpause() {
    pause = false;
  }

  void run() {
    for (int i = drops.size()-1; i >= 0; i--) {
      Drop p = drops.get(i);
      p.run();
      if (p.isDead()) {
        drops.remove(i);
      }
    }
  }
  
  // sets new RGB values upon mouseclick 
  void changeColor() {
    r = int(random(255));
    g = int(random(255));
    b = int(random(255));
  }
}


// A class representing the drops

class Drop {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  int r;
  int g;
  int b;

  Drop(PVector l, int red, int green, int blue) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    position = l.copy();
    lifespan = 255.0;
    r = red;
    g = green;
    b = blue;
    
  }

  void run() {
    update();
    display(r,g,b);
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display(int red, int green, int blue) {
    red = r;
    green = g;
    blue = b;
    stroke(r,g,b, lifespan);
    fill(r,g,b, lifespan);
    ellipse(position.x, position.y, 8, 8);
  }
  

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}