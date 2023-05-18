class Background {
  int ashCount = 200;
  Ash[] ashes = new Ash[ashCount];
  float edgeWidth = 50;
  float bottomHeight = 20;
  float[] terrain;
  float terrainScale = 0.02;

  Background() {
    setup();
  }

  void setup() {
    smooth();

    for (int i = 0; i < ashCount; i++) {
      ashes[i] = new Ash(random(width), random(height), random(1, 3));
    }

    // generateTerrain();
  }

  // void generateTerrain() {
  //   terrain = new float[width];
  //   float xOffset = 0;

    // for (int i = 0; i < width; i++) {
    //   terrain[i] = map(noise(xOffset), 0, 1, height * 0.6, height);
    //   xOffset += terrainScale;
    // }
  //}

  void draw() {
    imageMode(CORNER);
    image(imgBackground, 0, 0, width, height);

    // Draw terrain background
    // noStroke();
    // for (int i = 0; i < width; i++) {
    //   fill(204, 198, 177);
    //   rect(i, height, 1, -terrain[i]);
    //}

    // Falling ash
    for (int i = 0; i < ashCount; i++) {
      ashes[i].display();
      ashes[i].update();

      if (ashes[i].getY() > height) {
        ashes[i].resetY();
      }
      if (ashes[i].getX() < 0) {
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

  float getX() {
    return x;
  }

  float getY() {
    return y;
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
