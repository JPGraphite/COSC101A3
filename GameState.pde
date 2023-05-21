import java.util.ArrayList;

class GameState {
    int score = 0; // Used to store current game score
    int levelNumber; // Current level number for fetching level data
    int numBatteries; // Number of shots left to fire
    int totalBatteries; // Total number of shots possible
    int maxMissiles; // Total number of incoming missiles
    boolean paused; // Stores pause state of the game
    int numMissiles; // Current number of missiles
    int destroyedMissiles = 0; // Number of destroyed missile from either lasers, or hitting the ground/cities
    int playerKilledMissile = 0; // Number of missile killed by the player
    int previousScore; // Score from the previous level used for Menu
    int previousHighScore; // Highest score from previous level for Menu
    PApplet p; // Store processing applet
    ArrayList < Missile > missiles; // List of currently spawned missiles
    ArtilleryBattery battery; // Class for player controlled battery
    ArrayList < City > cities; // All city classes
    int highScore; // High score for this level


    float spawnInterval; // Random interval between missile spawns
    float lastSpawnTime; // Time of the last missile spawn


    GameState(PApplet p, Level nextLevel, int previousScore, int previousHighScore) {
        this.p = p;
        this.score = 0;
        this.levelNumber = nextLevel.levelNumber;
        this.numBatteries = nextLevel.numBatteries;
        this.totalBatteries = nextLevel.numBatteries;
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
        if (numBatteries < 0) return;
        battery.fire();
        numBatteries--;
        laserFire.play();
    }

    void keyPressed() {
        if (key == ' ') {
            paused = !paused;
        }
    }


    /*
        update();
        This function serves as a central point for updating various game elements and managing collisions for missiles, cities and lasers.
    */
    void update() {
        spawnMissiles();
        // trigger battery update function
        battery.update();

        // Check for collision every update call
        checkForLaserCollision();
        checkForMissileCollisions();
    }

    /*
        draw();
        This function controls the displaying of most gameState elements on the screen
    */
    void draw() {
        // Trigger battery display function
        battery.display();
        drawCities();
        drawMissiles();
        drawAmmo();
    }


    /*
        getScore();
        This function calculates the score for the current game based off below factors and returns the total score;
        Remaining Ammo
        Missiles destroyed
        Cities left allive
    */
    int getScore() {
        int scoreValForAmmo = 20;
        int scoreValForMissilesDestroyed = 50;
        int scoreValForCitiesAlive = 200;

        for (City city: cities) {
            if (!city.alive) continue;
            score += scoreValForCitiesAlive;
        }

        score += numBatteries * scoreValForAmmo;
        score += playerKilledMissile * scoreValForMissilesDestroyed;
        return score;
    }


    /*
        spawnMissiles();
        This function handles the spawning of missiles in a game by checking the time interval and the maximum number of missiles.
        It creates a new missile object, updates the relevant variables, and controls the frequency of missile spawns.
    */
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



    /*
        spawnCities();
        This function generates cities in an arraylist.
        The cities are positioned in two rows, with three cities on each side of the Artillery Batter.
        The function calculates the x-coordinate for each city and assigns a fixed y-coordinate near the bottom of the screen.
        It handles the creation of cities and their initial positioning.
    */
    void spawnCities() {
        float cityWidth = 80;
        float cityHeight = 60;
        for (int i = 1; i < 4; i++) {
            float x = i * 140 - cityWidth;
            cities.add(new City(x, height - 40, cityWidth, cityHeight));
        }

        for (int i = 1; i < 4; i++) {
            float x = i * 140;
            cities.add(new City(width - x, height - 40, cityWidth, cityHeight));
        }
    }


    /*
        drawCities();
        This function iterates over the cities arrayList.
        It calls their update function before drawing them on the screen.
    */
    void drawCities() {
        // Update and draw existing missiles
        for (int i = cities.size() - 1; i >= 0; i--) {
            City city = cities.get(i);
            city.update(); // Update the position of the city
            city.display(); // Display the city
        }
    }


    /*
        drawMissiles() iterates over a list of missiles, updates their positions, and displays them on the screen.
        It utilizes an iterator to safely remove missiles that have finished exploding or have moved off the screen.
    */
    void drawMissiles() {
        // Create an iterator for the missiles list
        Iterator < Missile > iterator = missiles.iterator();

        // Iterate over the missiles using the iterator
        while (iterator.hasNext()) {
            Missile missile = iterator.next();

            if (missile.explodeFinished) {
                iterator.remove(); // Remove the current missile using the iterator
                destroyedMissiles++;
            }

            // Remove missiles that are off the screen
            if (missile.pos.y + missile.missileHeight > height && !missile.exploding) {
                missile.explode(missile.pos.x, height - missile.missileHeight / 2);
                missileHit.play();
                iterator.remove(); // Remove the current missile using the iterator
            } else {
                missile.update(); // Update the position of the missile
                missile.display(); // Display the missile
            }
        }
    }

    /*
    	drawAmmo() visually represents the ammunition inventory by drawing empty and filled ammo blocks on the screen,
        providing a visual indicator of the available ammunition for the artillery battery.
    */
    void drawAmmo() {
        int ammoWidth = 20; // Width of each ammo block
        int ammoHeight = 10; // Height of each ammo block
        int spacing = 5; // Spacing between ammo blocks


        int startY = 55; // Y position of the first ammo block
        textSize(30);
        fill(255, 0, 0);
        stroke(0);
        strokeWeight(2);
        text("AMMO", width - 40, startY - 38);
        rectMode(CORNER);
        fill(100); // Set the fill color to grey
        rect(width - ammoWidth - 15, startY - ammoHeight, ammoWidth + 10, (ammoHeight + spacing) * totalBatteries + spacing + ammoHeight); // Draw the grey rectangle

        for (int i = 0; i < totalBatteries; i++) {
            int x = width - ammoWidth - 10; // X position of the ammo blocks
            int y = startY + (ammoHeight + spacing) * i; // Y position of each ammo block
            stroke(0);
            strokeWeight(1);
            fill(0, 0, 0); // Set the fill color
            rect(x, y, ammoWidth, ammoHeight); // Draw the ammo block
        }

        for (int i = 0; i < numBatteries; i++) {
            int x = width - ammoWidth - 10; // X position of the ammo blocks
            int y = startY + (ammoHeight + spacing) * i; // Y position of each ammo block
            stroke(0);
            strokeWeight(1);
            fill(0, 150, 0); // Set the fill color
            rect(x, y, ammoWidth, ammoHeight); // Draw the ammo block
        }
    }

    /*
    	checkForLaserCollision();
        This function checks for collisions between lasers from the lasers ArrayList (from the ArtilleryBattery class) and missiles from the missiles ArrayList.
        It iterates over the lasers and checks if they collide with any missiles.
        If a collision occurs, the missile is removed from the missiles ArrayList, a sound effect is triggered, and score related variables are updated.
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
                            playerKilledMissile++;
                            destroyedMissiles++;
                            break;
                        }
                    }
                }
            }
        }
    }

    /*
    	checkForLaserCollision();
        This function iterates over the cities ArrayList to check for collisions between missiles and currently alive cities.
        It ensures that the city is alive and the missile has not already collided with an element before checking for another collision.
        The function handles the necessary actions when a collision is detected, such as;
        exploding the missile,
        playing a sound effect,
        and marking the city as not alive.
    */
    void checkForMissileCollisions() {
        for (City city: cities) {
            if (!city.alive) continue;
            //
            missileLoop:
                for (Missile missile: missiles) {
                    if (missile.exploding) continue;

                    float centerOfCityX = city.x + city.cityWidth / 2;
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