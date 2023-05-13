class Missile {
  PVector pos; // Position of missile
  PVector vel; // Velocity of missile
  float size; // Size of missile
  float angle; // Angle of missile
  PVector velocity;
  PImage img;

  Missile() {
    // Initial velocity set to 2 for in both x and y direction
    velocity = new PVector(2, 2);
    // Initialize missile at random x position at the top of the screen
    pos = new PVector(random(width), 0);
    // Set angle between -PI/4 and PI/4 to keep missile on screen
    angle = this.getAngle();
    velocity = PVector.fromAngle(angle);
    // Set speed and size of missile

    velocity.mult(5); // Set speed of missile
    size = 20;

    img = loadImage("missile.png");
    img.resize(30, 30);
  }

  void update() {
    // Update position of missile based on velocity
    pos.add(velocity);


    // Reset missile position when it reaches the bottom of the screen
    if (pos.y - size > height) {
      pos = new PVector(random(width), 0);
      angle = getAngle();
      velocity = PVector.fromAngle(angle);
      velocity.mult(5); // Set speed of missile
    }
  }

  float getAngle() {
    // Generate a random starting x position at the top of the screen
    float startX = pos.x;
    float startY = pos.y;

    // Generate a random ending x position at the bottom of the screen
    float endX = random(width);
    float endY = height;

    // Calculate the vector between the two points
    float dx = endX - startX;
    float dy = endY - startY;

    // Calculate the angle between the vector and the x-axis
    float calcAngle = atan2(dy, dx);
    return calcAngle;
  }

  void display() {
    stroke(0);
    strokeWeight(3);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(velocity.heading() + PI / 2);
    tint(255, 100);
    image(img, -size/2, -size/2); // Adjust image positioning based on size
    noTint();
    popMatrix();
  }
}