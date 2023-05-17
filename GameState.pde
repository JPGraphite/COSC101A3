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
	Background background;

  	ArrayList<Missile> missiles;
  	ArtilleryBattery battery;
	ArrayList<City> cities;


  float spawnInterval; // Random interval between missile spawns
  float lastSpawnTime; // Time of the last missile spawn

  GameState(PApplet p, int levelNumber, int numCities, int numBatteries, int maxMissiles, int previousScore) {
    this.p = p;
	this.score = 0;
    this.levelNumber = levelNumber;
    this.numCities = numCities;
    this.numBatteries = numBatteries;
 	this.maxMissiles = maxMissiles;
	this.previousScore = previousScore;
	this.paused = true;
  this.spawnInterval = random(1, 5); // Initialize the random interval
    this.lastSpawnTime = p.millis(); // Initialize the last spawn time
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

	// Initialise battery at the center of the screen
    battery = new ArtilleryBattery(width / 2 , height - 30);

    // Initialize missiles array list
    missiles = new ArrayList<Missile>();

	// Set up sounds files for lasers and missiles
	laserFire = new SoundFile(p, "./data/laserFire.wav");
	missileHit = new SoundFile(p, "./data/missileHit.wav");
	numMissiles = 0;
	background = new Background();
	cities = new ArrayList<City>();
	cities.add(new City(70, height - 50));
	cities.add(new City(160, height - 50));
	cities.add(new City(width - 160, height - 50));
	cities.add(new City(width - 70, height - 50));
  }

	/*
		checkForCollision() iterates over the lasers arraylist from the ArtilleryBattery class
		checking if they collide with any missiles from the missiles ArrayList
		If they collide, the missile is removed from the array list, triggering a sound effect.
	*/
  void checkForCollision() {
    for (Laser laser : battery.lasers) {
		// Check if laser is travelling, or if it's hit it's target
		// Laser should not explode before hitting it's target
      if (laser.hasReachedTarget()) {

		// Create iterator as we need to run the remove function on hit missiles
        Iterator<Missile> iterator = missiles.iterator();
        while (iterator.hasNext()) {
          Missile missile = iterator.next();
		  // Calculate explosion radius
          float distance = dist(laser.x, laser.y, missile.pos.x, missile.pos.y);
          if (distance < laser.explosionMaxRadius) {

			// If missile hit, remove it from the array list
            iterator.remove();
			// Play explosion sound
			missileHit.play();
			// Increment destroyedMissiles for level complete condition
			destroyedMissiles++;
			// Add score ( To be updated )
			score++;
          }
        }
      }
    }
  }

  void update() {

     // Check if it's time to spawn a missile
    float currentTime = p.millis();
    if (currentTime - lastSpawnTime >= spawnInterval * 1000 && numMissiles < maxMissiles) {
      missiles.add(new Missile());
      numMissiles++;
      // Update the last spawn time and generate a new random interval
      lastSpawnTime = currentTime;
      spawnInterval = random(1, 5);
    }
    // trigger battery update function
    battery.update();

	// Check for collision every update call
    checkForCollision();
  }

  void draw() {
  	background(200); // Clear the background to white
	background.draw();
	// Trigger battery display function
	battery.display();

//   // Hardcoded city drawing
//   float citySpacing = 100; // Adjust the spacing between cities if needed
//   float cityStartX = (width - (numCities - 1) * citySpacing) / 2;
//   float cityY = height - 60; // Adjust the y-coordinate of the cities if needed

//   for (int i = 0; i < numCities; i++) {
//     float cityX = cityStartX + i * citySpacing;
//     rectMode(CENTER);
//     fill(0, 100, 200);
//     stroke(0, 100, 200);
//     rect(cityX, cityY, 80, 40);
//   }
	// Update and draw existing missiles
  for (int i = cities.size() - 1; i >= 0; i--) {
    City city = cities.get(i);
      city.update(); // Update the position of the city
      city.display(); // Display the city
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