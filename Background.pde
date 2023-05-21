/**
 * The Background class represents the background of the application.
 * It displays a background image and falling ashes.
 */
class Background {
  int ashCount = 200;
  Ash[] ashes = new Ash[ashCount];

  /**
   * Constructs a Background object and sets up the background.
   */
  Background() {
    setup();
  }

  /**
   * Sets up the background by initializing the ashes.
   */
  void setup() {
    smooth();

    for (int i = 0; i < ashCount; i++) {
      ashes[i] = new Ash(random(width), random(height), random(1, 3));
    }
  }

  /**
   * Draws the background by displaying the background image and updating the ashes' positions.
   */
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

/**
 * The Ash class represents a falling ash particle.
 */
class Ash {
  float x;
  float y;
  float yMove;

  /**
   * Constructs an Ash object with the specified coordinates and vertical movement.
   * 
   * @param x      The x-coordinate of the ash.
   * @param y      The y-coordinate of the ash.
   * @param yMove  The vertical movement speed of the ash.
   */
  Ash(float x, float y, float yMove) {
    this.x = x;
    this.y = y;
    this.yMove = yMove;
  }

  /**
   * Resets the x-coordinate of the ash to the specified maximum x-coordinate.
   * 
   * @param maxX  The maximum x-coordinate to reset the ash's x-coordinate to.
   */
  void resetX(float maxX) {
    x = maxX;
  }

  /**
   * Resets the y-coordinate of the ash to 0.
   */
  void resetY() {
    y = 0;
  }

  /**
   * Displays the ash on the screen.
   */
  void display() {
    stroke(0);
    strokeWeight(1);
    fill(85, 85, 85);
    ellipse(x, y, 2.5, 2.5);
  }

  /**
   * Updates the position of the ash by randomly moving it horizontally and vertically.
   */
  void update() {
    x += random(-0.5, 0.5);
    y += yMove / 10;
  }
}
