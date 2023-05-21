/***************************************************
* COSC101 Assignment 3 - Missile Command
* By Jayden Potts, Thyson Rosen, and Reece Offer.
* The aim of this program was to create a replica of the
* classic Atarai game "Missile Command", along with making some
* changes to personalise the program.
*
* Sources for all files loaded into the game as below:
*
* Sound files:
* Soundtrack - https://pixabay.com/music/upbeat-space-120280/
* Success - https://freesound.org/people/Kagateni/sounds/404360/
* laserFire - https://freesound.org/people/newlocknew/sounds/514020/
* missileHit - https://freesound.org/people/Robinhood76/sounds/273332/
* 
* Image files:
* imgCity - https://www.clipartkey.com/downpng/JbbTh_skyscraper-clipart-transparent-city-clipart-transparent/ 
* imgFlames - https://www.clipartkey.com/downpng/xwowJ_flame-fire-flames-clipart-bottom-border-transparent-free/
* img Battery - https://www.pngwing.com/en/free-png-tovsr/download/
* imgMissile - https://www.clipartkey.com/downpng/Tohhoo_nuke-clipart-missile-launch-transparent-background-missile-png/ 
* imgBackground - https://www.freepik.com/free-vector/alien-planet-landscape-space-view-frozen-canyon_28641061/
* imgLaser - https://www.pngitem.com/middle/iRxoxRb_transparent-laser-sprite-laser-beam-sprite-png-png/
* imgLaserExplosion - https://www.pngegg.com/en/png-zwpky
* imgMissileExplosion - https://www.kindpng.com/imgv/bhJww_explosion-png-image-transparent-background-explosion-png-png/ 
* 
* Embedded link to reflection video:
* https://kaf.une.edu.au/media/COSC101%20Assignment%203/1_fi4gy4rq 
* 
*  Sound library used for various ingame sound effects. To install in 
* Processing follow below instructions:
* From Processing go to
* → Sketch
* → Import Library
* → Add Library
* → search for “sound” and select “Sound | Provides a simple way to work with audio”
* → and click ↓ Install.
****************************************************/

import processing.sound.*;
import processing.core.PApplet;
import processing.data.JSONArray;
import processing.data.JSONObject;

Level level;
GameState game;
Menu menu;
ArrayList<Level> levels = new ArrayList<Level>();
int previousScore = 0;
int previousHighScore = 0;
SoundFile success;
PApplet p = this;
Background background;
PImage imgCity, imgFlames, imgBattery, imgMissile, imgBackground, imgLaser, imgLaserExplosion, imgMissileExplosion;
SoundFile laserFire, missileHit;
String highScoreFilePath = "highscore.txt";



/*
  setup();
  Sets up the initial configuration of the sketch.
  Loads images, sound files, initializes game objects, and starts the audio thread.
*/
void setup() {
  size(1000, 500);
  background(0);
  imgCity = loadImage("city.png");
  imgFlames = loadImage("flames.png");
  imgBattery = loadImage("battery.png");
  imgMissile = loadImage("missile.png");
  imgBackground = loadImage("background.jpg");
  imgLaser = loadImage("laser.png");
  imgLaserExplosion = loadImage("laserExplosion.png");
  imgMissileExplosion = loadImage("missileExplosion.png");
  // Set up sounds files for lasers and missiles
  laserFire = new SoundFile(p, "./data/laserFire.wav");
  missileHit = new SoundFile(p, "./data/missileHit.wav");
  // Remove cursor as it's replaced in GameState
  noCursor();

  // Initialise levels arraylist
  createLevels();
  level = levels.get(0);
  background = new Background();
  // Initialise game with first level
   game = new GameState(
        this,
        level,
        previousScore,
        level.highScore
    );

  // Start game in paused state to show the menu
  game.setPaused(true);
  // Initialise start menu
  menu = new Menu(game);
  game.setup();

  // Load in success sound and set volume to 50%
  success = new SoundFile(this, "./data/success.wav");
  success.amp(0.5);

  // Create a new thread to load the audio file asynchronously
  Thread audioThread = new Thread(
    new AudioLoader(p, "./data/soundtrack.mp3", 0.3, "loop")
  );
  audioThread.start();
}

/*
    createLevels() fetches an array of level information from the levels.json file
    and populates the levels arrayList with a Level class for each object
*/
void createLevels() {
    try {
        // Read the levels.json file
    BufferedReader reader = createReader("levels.json");
    JSONArray jsonArray = new JSONArray(reader);

    for (int i = 0; i < jsonArray.size(); i++) {
        JSONObject jsonObject = jsonArray.getJSONObject(i);

        int levelNumber = jsonObject.getInt("levelNumber");
        int numLasers = jsonObject.getInt("numLasers");
        int numMissiles = jsonObject.getInt("numMissiles");
        int highScore = jsonObject.getInt("highScore");

        // Initialise a new level class with fetched values
        Level level = new Level(levelNumber, numLasers, numMissiles, highScore);
        levels.add(level);
    }

    reader.close();
    } catch (IOException e) {
        e.printStackTrace();
    }

}


/*
  updateHighScore();
  Updates the high score in the levels.json file with updated level data.
*/
void updateHighScore() {
  // Write the updated levels to levels.json file
    JSONArray updatedJsonArray = new JSONArray();

    for (Level level : levels) {
        JSONObject jsonObject = new JSONObject();
        jsonObject.setInt("levelNumber", level.levelNumber);
        jsonObject.setInt("numLasers", level.numLasers);
        jsonObject.setInt("numMissiles", level.numMissiles);
        jsonObject.setInt("highScore", level.highScore);

        updatedJsonArray.append(jsonObject);
    }

    PrintWriter writer = createWriter("levels.json");
    writer.print(updatedJsonArray);
    writer.flush();
    writer.close();
}

/*
  nextLevel();
  Advances the game to the next level if available, or displays the completion menu if all levels are completed.
  Plays a mission success sound effect and updates the game state accordingly.
*/
void nextLevel() {
  // Plays mission success sound effect
  success.play();

  // Grab the current level number used for fetching next level
  int currentLevel = level.levelNumber;

  // Check if another level exists
  if (levels.size() > currentLevel) {
    // Fetch the next level object
    level = levels.get(currentLevel);
    // Store the score for the current game, for displaying on the success screen
    previousScore = game.score;
    previousHighScore = game.highScore;
    // Update GameState
    game = new GameState(
      this,
      level,
      previousScore,
      previousHighScore
    );
    game.setup();

    // Initialise new Menu with new GameState
    menu = new Menu(game);

    // Set screen style
    menu.setCurrentScreen(ScreenType.NEXT_LEVEL);
  } else {
    // If no more levels, set Paused state and display complete menu
    game.setPaused(true);
    menu.setCurrentScreen(ScreenType.COMPLETED);
  }
}


/*
  nextLevel();
  Draws the game or the menu screen depending on the game state.
  Handles the logic for transitioning between screens and resetting the game.
*/
void draw() {
  if (game.destroyedMissiles >= game.maxMissiles && !game.paused && game.missiles.size() < 1) {
    int currentScore = game.getScore();
    int highScore = game.highScore;
    if (currentScore > highScore) {
        level.highScore = currentScore;
        updateHighScore();
    }
    nextLevel();
  }

  if (!game.paused) {
    noCursor();
    background.draw();
    game.update();
    game.draw();
    updateHighScore(); // Check and update high score during the game
  } else {
    menu.draw();
  }

  if (menu.currentScreen == ScreenType.COMPLETED) {
    resetGame();
  }

  if (menu.restarting) {
    menu = new Menu(game);
  }
}

/*
  resetGame();
  Resets the game after completion by reinitialising the game with the first level
*/
void resetGame() {
  level = levels.get(0);
  // Store the score for the current game, for displaying on the success screen
  previousScore = game.score;
  previousHighScore = game.highScore;
  // Update GameState
  game = new GameState(
    this,
    level,
    previousScore,
    previousHighScore
  );
  game.setup();
}

/*
  mousePressed();
  Handles mouse click events differently depending on game pause state
*/
void mousePressed() {
  if (!game.paused) {
    game.mouseClicked();
  } else {
    menu.mouseClicked();
  }
}

/*
  keyPressed();
  Allows game to be paused if not currently paused, else key press does nothing
*/
void keyPressed() {
  // Prevent paused screen functionality between levels
  if (game.paused && menu.currentScreen != ScreenType.PAUSED) return;
  game.keyPressed();
}
