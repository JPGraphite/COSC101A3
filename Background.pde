class Background {
  float[] xCoords = new float[500];
  float[] yCoords = new float[500];
  float[] xMove = new float[500];
  float[] yMove = new float[500];
  float edgeWidth = 50;
  float bottomHeight = 20;

    Background() {
        this.setup();
    }

    void setup() {
    smooth();
    for (int i = 0; i < 50; i++) {
      xCoords[i] = random(width);
      yCoords[i] = random(height);
      yMove[i] = random(1,3);
    }
  }


  void draw() {
    stroke(1);
    strokeWeight(1);
  // falling ash
    for (int i = 0; i < 500; i++) {
      ellipse(xCoords[i], yCoords[i], 1.5, 1.5);
      xCoords[i] += xMove[i] / 10;
      yCoords[i] += yMove[i] / 10;

      xCoords[i] += random(-0.5, 0.5);

      if (yCoords[i] > height - 50) {
        yCoords[i] = 0;
      }
      if (xCoords[i] < 0) {
        xCoords[i] = width;
      }
    }

  // horizon and valley edges
    fill(204, 198, 177);
    rect(width/2, height - bottomHeight/2, width, bottomHeight);
    rect(0, height - edgeWidth/2 - bottomHeight, 25 + bottomHeight, edgeWidth);
    rect(width, height - edgeWidth/2 - bottomHeight, 25 + bottomHeight, edgeWidth);

  }
}


