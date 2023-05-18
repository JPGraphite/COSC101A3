import java.util.ArrayList;

class GameState {
    int score = 0;
    int levelNumber;
    int numBatteries;
    int maxMissiles;
    boolean paused;
    int numMissiles;
    int destroyedMissiles = 0;
    int previousScore;
    int previousHighScore;
    PApplet p;
    ArrayList < Missile > missiles;
    ArtilleryBattery battery;
    ArrayList < City > cities;
    int highScore;


    float spawnInterval; // Random interval between missile spawns
    float lastSpawnTime; // Time of the last missile spawn


    GameState(PApplet p, Level nextLevel, int previousScore, int previousHighScore) {
        this.p = p;
        this.score = 0;
        this.levelNumber = nextLevel.levelNumber;
        this.numBatteries = nextLevel.numBatteries;
        this.maxMissiles = nextLevel.numMissiles;
        this.previousScore = previousScore;
        this.previousHighScore = previousHighScore;
        this.paused = true;
        this.spawnInterval = random(1, 5); // Initialize the random interval
        this.lastSpawnTime = p.millis(); // Initialize the last spawn time
        this.highScore = nextLevel.highScore;
    }

	void setPaused(boolean pause) {
        paused = pause;
    }

    void setup() {
        // Initialise battery at the center of the screen
        battery = new ArtilleryBattery(width / 2, height - 30, numBatteries);

        // Initialize missiles array list
        missiles = new ArrayList < Missile > ();


        numMissiles = 0;

        cities = new ArrayList < City > ();
        spawnCities();
    }

	void mouseClicked() {
        // Calculate angle between ArtilleryBattery position and mouse position
		if ( numBatteries < 0) return;
        battery.fire();
		numBatteries--;
        laserFire.play();
    }

    void keyPressed() {
        if (key == ' ') {
            paused = !paused;
        }
    }

    void update() {
		spawnMissiles();
        // trigger battery update function
        battery.update();

        // Check for collision every update call
        checkForLaserCollision();
		checkForMissileCollisions();
    }

    void draw() {
        // Trigger battery display function
        battery.display();
        drawCities();
        drawMissiles();
		drawAmmo();
    }

    void spawnMissiles() {
        // Check if it's time to spawn a missile
        float currentTime = p.millis();
        if (currentTime - lastSpawnTime >= spawnInterval * 1000 && numMissiles < maxMissiles) {
            missiles.add(new Missile());
            numMissiles++;
            // Update the last spawn time and generate a new random interval
            lastSpawnTime = currentTime;
            spawnInterval = random(1, 5);
        }
    }

    void spawnCities() {
		float cityWidth = 80;
		float cityHeight = 60;
		for (int i = 1; i < 4; i++) {
			float x = i * 140 - cityWidth;
			cities.add(new City(x , height - 40,cityWidth,cityHeight));
		}

		for (int i = 1; i < 4; i++) {
			float x = i * 140;
			cities.add(new City(width - x , height - 40,cityWidth, cityHeight));
		}
    }

    void drawCities() {
        // Update and draw existing missiles
        for (int i = cities.size() - 1; i >= 0; i--) {
            City city = cities.get(i);
            city.update(); // Update the position of the city
            city.display(); // Display the city
        }
    }

    void drawMissiles() {
        // Update and draw existing missiles
        for (int i = missiles.size() - 1; i >= 0; i--) {
            Missile missile = missiles.get(i);
            if (missile.explodeFinished) {
                missiles.remove(i);
                destroyedMissiles++;
            }
            // Remove missiles that are off the screen
            if (missile.pos.y + missile.missileHeight > height && !missile.exploding) {
                missile.explode(missile.pos.x, height - missile.missileHeight /2);
				missileHit.play();
            } else {
                missile.update(); // Update the position of the missile
                missile.display(); // Display the missile
            }
        }
    }

	void drawAmmo() {
		int ammoWidth = 20; // Width of each ammo block
		int ammoHeight = 10; // Height of each ammo block
		int spacing = 10; // Spacing between ammo blocks


		int startY = 10; // Y position of the first ammo block

		for (int i = 0; i < numBatteries; i++) {
			int x = width - ammoWidth - 10; // X position of the ammo blocks
			int y = startY + (ammoHeight + spacing) * i; // Y position of each ammo block
			stroke(0);
			strokeWeight(0);
			fill(150); // Set the fill color
			rect(x, y, ammoWidth, ammoHeight); // Draw the ammo block
		}
	}

	/*
    	checkForLaserCollision() iterates over the lasers arraylist from the ArtilleryBattery class
    	checking if they collide with any missiles from the missiles ArrayList
    	If they collide, the missile is removed from the array list, triggering a sound effect.
    */
    void checkForLaserCollision() {
        for (Laser laser: battery.lasers) {
            // Check if laser is travelling, or if it's hit it's target
            // Laser should not explode before hitting it's target
            if (laser.reachedTarget && !laser.exploded) {

                // Create iterator as we need to run the remove function on hit missiles
                Iterator < Missile > iterator = missiles.iterator();
                while (iterator.hasNext()) {
                    Missile missile = iterator.next();
                    // Calculate explosion radius
					PVector[] points = missile.getCoords();

					for (int i = 0; i < points.length; i++) {
						PVector point = points[i];
						// Perform operations on each point
						float distance = dist(laser.x, laser.y, point.x, point.y);
						if (distance < laser.explosionMaxRadius) {
							// If missile hit, remove it from the array list
							iterator.remove();

							// Ensure duplicate sounds not playing
							missileHit.stop();
							// Play explosion sound
							missileHit.play();
							// Increment destroyedMissiles for level complete condition
							destroyedMissiles++;
							// Add score ( To be updated )
							score++;
							if (iterator.hasNext()) {
								iterator.next();
								}
							else {
								break;
							}
						}
					}
                }
            }
        }
    }


    void checkForMissileCollisions() {
    for (City city : cities) {
        if (!city.alive) continue;
		//
		missileLoop:
        for (Missile missile : missiles) {
            if (missile.exploding) continue;

			float centerOfCityX = city.x + city.cityWidth/2;
			float centerOfCityY = city.y;
			float overlapThreshold = missile.explosionMaxRadius + 20;

			PVector[] points = missile.getCoords();
			for (int i = 0; i < points.length; i++) {
				PVector point = points[i];

				// Perform operations on each point
				float distance = dist(centerOfCityX, centerOfCityY, point.x, point.y);
				 if (distance <= overlapThreshold) {
					// Collision occurred
					missile.explode(point.x, point.y);
					missileHit.play();
					city.setAlive(false);
					continue missileLoop;
            	}
			}

        }
    }
}


}