

/*
    Class: Background

    Represents the background of the application.

    Properties:
      - ashCount: The total count of ash to spawn (int)
      - ashes: Array of spawned Ash (Ash[])

    Methods:
      - Background(): Constructor for the Background class
      - setup(): Sets up the background by initializing the ashes
      - draw(): Draws the background by displaying the background image and updating the ashes' positions
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




/*
    Class: Ash

    The Ash class represents a falling ash particle.

    Properties:
      - x: X position of Ash (float)
      - y: Y position of Ash (float)
      - yMove: The vertical movement speed of the ash (float)

    Methods:
      - Ash(): Constructs an Ash object with the specified coordinates and vertical movement.
      - setup(): Sets up the background by initializing the ashes
      - draw(): Draws the background by displaying the background image and updating the ashes' positions
*/

class Ash {
  float x;
  float y;
  float yMove;


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
