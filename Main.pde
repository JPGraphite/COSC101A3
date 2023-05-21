/* Sound library used for various ingame sound effects. To install in Processing follow below instructions;
From Processing go to
→ Sketch
→ Import Library
→ Add Library
→ search for “sound” and select “Sound | Provides a simple way to work with audio”
→ and click ↓ Install.
*/

import processing.sound.*;
import processing.core.PApplet;

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
  
  // Generate levels
  generateLevels();

  level = levels.get(0);
  background = new Background();
  // Initialise game with first level
  game = new GameState(
    this,
    level,
    previousScore,
    loadHighScore()
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

void generateLevels() {
  int numLevels = 5; // Number of levels to generate
  int initialBatteries = 5; // Number of lasers for first stage
  int initialMissiles = 1; // Number of missiles for first stage
  int batteryIncrement = 2; // Add two additional lasers each stage
  int missileIncrement = 3; // Add three additional missiles each stage

  for (int i = 0; i < numLevels; i++) {
    int levelNumber = i + 1;
    int numBatteries = initialBatteries + i * batteryIncrement;
    int numMissiles = initialMissiles + i * missileIncrement;

    int highScore = loadHighScore(); // Load the high score

    Level level = new Level(levelNumber, numBatteries, numMissiles, highScore);
    levels.add(level);
  }
}



void saveHighScore(int score) {
  String[] data = { str(score) };
  saveStrings(highScoreFilePath, data);
}

int loadHighScore() {
  String[] data = loadStrings(highScoreFilePath);
  if (data != null && data.length > 0) {
    return Integer.parseInt(data[0]);
  } else {
    return 0;
  }
}

void updateHighScore() {
  if (game.score > game.highScore) {
    game.highScore = game.score;
    saveHighScore(game.highScore);
  }
}

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

void draw() {
  if (game.destroyedMissiles >= game.maxMissiles && !game.paused) {
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

void mousePressed() {
  if (!game.paused) {
    game.mouseClicked();
  } else {
    menu.mouseClicked();
  }
}

void keyPressed() {
  // Prevent paused screen functionality between levels
  if (game.paused && menu.currentScreen != ScreenType.PAUSED) return;

  game.keyPressed();
}
