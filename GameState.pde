import java.util.ArrayList;

class GameState {
  int levelNumber;
  int numCities;
  int numBatteries;
  int numMissiles;
  int score;
  ArrayList<Missile> missiles;
  ArtilleryBattery battery;

  GameState(int levelNumber, int numCities, int numBatteries, int numMissiles) {
    this.score = 0;
    this.levelNumber = levelNumber;
    this.numCities = numCities;
    this.numBatteries = numBatteries;
    this.numMissiles = numMissiles;
  }

  void setup() {
    size(500, 500); // Set the size of the game window
    frameRate(30); // Set the frame rate of the game
    battery = new ArtilleryBattery(width / 2 - 30, height - 20);

    // Initialize missiles array list
    missiles = new ArrayList<Missile>();
    for (int i = 0; i < numMissiles; i++) {
      missiles.add(new Missile());
    }
  }

  void checkForCollision() {
    for (Laser laser : battery.lasers) {
      if (laser.hasReachedTarget()) {
        Iterator<Missile> iterator = missiles.iterator();
        while (iterator.hasNext()) {
          Missile missile = iterator.next();
          float distance = dist(laser.x, laser.y, missile.pos.x, missile.pos.y);
          if (distance < laser.explosionMaxRadius) {
            iterator.remove();
          }
        }
      }
    }
  }

  void update() {
    // Update the game state every frame
    // Handle input, update objects, check for collisions, etc.
    battery.update();
    checkForCollision();

    // Add a new missile every 60 seconds (60 frames * frameRate)
    if (frameCount % (60 * frameRate) == 0) {
      missiles.add(new Missile());
    }
  }

  void draw() {
    background(255); // Clear the background to white
    battery.display();

    // Update and draw existing missiles
    for (int i = missiles.size() - 1; i >= 0; i--) {
      Missile missile = missiles.get(i);
      missile.update(); // Update the position of the missile
      missile.display(); // Display the missile

      // Remove missiles that are off the screen
      if (missile.pos.y - missile.size > height) {
        missiles.remove(i);
      }
    }

    // Add a new missile
    missiles.add(new Missile());
  }






  void mouseClicked() {
    // Calculate angle between ArtilleryBattery position and mouse position
    battery.fire();
  }

  void keyPressed() {
    // Handle key presses
    // Fire counter-missiles, switch missile batteries, etc.
  }
}

