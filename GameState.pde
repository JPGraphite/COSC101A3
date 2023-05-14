import java.util.ArrayList;

class GameState {
  private int score = 0;
	private int levelNumber;
	private int numCities;
	private int numBatteries;
	private int maxMissiles;
	private boolean paused;
	private int numMissiles;
	private int destroyedMissiles = 0;
	private int previousScore;
	SoundFile laserFire, missileHit;
	PApplet p;

  	ArrayList<Missile> missiles;
  	ArtilleryBattery battery;

  GameState(PApplet p, int levelNumber, int numCities, int numBatteries, int maxMissiles, int previousScore) {
    this.p = p;
	this.score = 0;
    this.levelNumber = levelNumber;
    this.numCities = numCities;
    this.numBatteries = numBatteries;
 	this.maxMissiles = maxMissiles;
	this.previousScore = previousScore;
	this.paused = true;

  }


	public int getScore() {
		return score;
	}

	public int getLevelNumber() {
		return levelNumber;
	}

	public int getNumCities() {
		return numCities;
	}

	public int getNumBatteries() {
		return numBatteries;
	}

	public int getMaxMissiles() {
		return maxMissiles;
	}
	public int getPreviousScore() {
		return previousScore;
	}

	public boolean isPaused() {
		return paused;
	}

	public int getDestroyedMissileCount() {
		return destroyedMissiles;
	}

  void setup() {
    size(500, 500); // Set the size of the game window
    battery = new ArtilleryBattery(width / 2 - 30, height - 20);

    // Initialize missiles array list
    missiles = new ArrayList<Missile>();
	laserFire = new SoundFile(p, "./data/laserFire.wav");
	missileHit = new SoundFile(p, "./data/missileHit.wav");
	numMissiles = 0;

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
			missileHit.play();
			destroyedMissiles++;
			score++;
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
  }

  void draw() {
    background(255); // Clear the background to white
    battery.display();

    // Add a new missile every 60 seconds (60 frames * frameRate)
    if (frameCount % 60  == 0 && numMissiles < maxMissiles) {
      missiles.add(new Missile());
	  numMissiles++;
    }

    // Update and draw existing missiles
    for (int i = missiles.size() - 1; i >= 0; i--) {
      Missile missile = missiles.get(i);

	  // Remove missiles that are off the screen
      if (missile.pos.y - missile.size > height) {
        missiles.remove(i);

      } else {
		missile.update(); // Update the position of the missile
      	missile.display(); // Display the missile
	  }
    }
  }

	void setPaused(boolean pause) {
		paused = pause;
	}




  void mouseClicked() {
    // Calculate angle between ArtilleryBattery position and mouse position
    battery.fire();
	laserFire.play();
  }

  void keyPressed() {
     if (key == ' ') {
		paused = !paused;

	}
  }
}