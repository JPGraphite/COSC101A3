
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
    ellipse(x, y, 1.5, 1.5);
  }

  void update() {
    x += random(-0.5, 0.5);
    y += yMove / 10;
  }
}