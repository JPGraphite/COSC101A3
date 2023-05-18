class Background {
  int ashCount = 200;
  Ash[] ashes = new Ash[ashCount];
  float edgeWidth = 50;
  float bottomHeight = 20;

    Background() {
        this.setup();
    }

    void setup() {
    smooth();
    for (int i = 0; i < ashCount; i++) {
      ashes[i] = new Ash(random(width), random(height), random(1, 3));
    }
  }


  void draw() {
    stroke(1);
    strokeWeight(1);
  // falling ash
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

  // horizon and valley edges
    fill(204, 198, 177);
    rect(width/2, height - bottomHeight/2, width, bottomHeight);
    rect(0, height - edgeWidth/2 - bottomHeight, 25 + bottomHeight, edgeWidth);
    rect(width, height - edgeWidth/2 - bottomHeight, 25 + bottomHeight, edgeWidth);

  }
}
