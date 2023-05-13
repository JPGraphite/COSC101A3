import java.util.ArrayList;

class GameState {
	int levelNumber;
	int numCities;
	int numBatteries;
	int numMissiles;
	int score;
	ArrayList < Missile > missiles;
	ArtilleryBattery battery;

	GameState(int levelNumber, int numCities, int numBatteries, int numMissiles) {
		this.score = 0;
		this.levelNumber = levelNumber;
		this.numCities = numCities;
		this.numBatteries = numBatteries;
		this.numMissiles = numMissiles;


		// Initialize missiles array list
		missiles = new ArrayList < Missile > ();
		for (int i = 0; i < numMissiles; i++) {
			missiles.add(new Missile());
		}
	}

	void setup() {
		battery = new ArtilleryBattery(width / 2 - 30, height - 20);
	}

	void checkForCollision() {
     for (Laser laser: battery.lasers) {
        if (laser.hasReachedTarget()){
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

		for (Missile missile: missiles) {
			missile.update();
		}
		checkForCollision();
	}

	void draw() {
		// Draw the game state every frame
		// Draw cities, missile batteries, score, etc.
		// Draw objects, such as missiles, explosions, etc.
		battery.display();
		for (Missile missile: missiles) {
			missile.display();
		}
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