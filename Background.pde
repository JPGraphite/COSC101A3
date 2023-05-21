class Background {
  int ashCount = 200;
  Ash[] ashes = new Ash[ashCount];
  
  Background() {
    setup();
  }

  void setup() {
    smooth();

    for (int i = 0; i < ashCount; i++) {
      ashes[i] = new Ash(random(width), random(height), random(1, 3));
    }

    
  }

  void draw() {
    imageMode(CORNER);
    image(imgBackground, 0, 0, width, height);

    // Falling ash
    for (int i = 0; i < ashCount; i++) {
      ashes[i].display();
      ashes[i].update();

      if (ashes[i].y > height) {
        ashes[i].resetY();
      }
      if (ashes[i].x < 0) {
        ashes[i].resetX(0);
      }
    }
  }
}

class Ash {
  float x;
  float y;
  float yMove;

  Ash(float x, float y, float yMove) {
    this.x = x;
    this.y = y;
    this.yMove = yMove;
  }


  void resetX(float maxX) {
    x = maxX;
  }

  void resetY() {
    y = 0;
  }

  void display() {
    stroke(0);
    strokeWeight(1);
    fill(85, 85, 85);
    ellipse(x, y, 2.5, 2.5);
  }

  void update() {
    x += random(-0.5, 0.5);
    y += yMove / 10;
  }
}
