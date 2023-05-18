
/* Sound library used for various ingame sound effects. To install in Processing follow below instructions;
From Processing go to
→ Sketch
→ Import Library
→ Add Library
→ search for “sound” and select “Sound | Provides a simple way to work with audio”
→ and click ↓ Install.
*/
import processing.sound.*;


Level level;
GameState game;
Menu menu;
ArrayList<Level> levels = new ArrayList<Level>();
int previousScore = 0;
SoundFile success;
PApplet p = this;
Background background;
PImage imgCity, imgFlames, imgBattery, imgMissile, imgBackground;


void setup() {
    size(1000, 500);
    background(0);
    imgCity = loadImage("city.png");
    imgFlames = loadImage("flames.png");
    imgBattery = loadImage("battery.png");
    imgMissile = loadImage("missile.png");
    imgBackground = loadImage("background.jpg");

    // Remove cursor as it's replaced in GameState
    noCursor();
    frameRate(30);


    // Initialise levels arraylist
    createLevels();
    level = levels.get(0);
    background = new Background();
    // Initialise game with first level
    game = new GameState(
        this,
        level.getLevelNumber(),
        level.getNumCities(),
        level.getNumBatteries(),
        level.getNumMissles(),
        previousScore
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
    createLevels() fetches an array of level information from the levels.txt file
    and populates the levels arrayList with a Level class for each line
    level structure in the levels file is as below;
        levelNumber,numCities,numBatteries,numMissiles
*/
void createLevels() {
    try {
        // Read the levels.txt file
        BufferedReader reader = createReader("levels.txt");
        String line = null;

        while ((line = reader.readLine()) != null) {
            String[] values = line.split(",");
            if (values.length == 4) {
                int levelNumber = Integer.parseInt(values[0].trim());
                int numCities = Integer.parseInt(values[1].trim());
                int numBatteries = Integer.parseInt(values[2].trim());
                int numMissiles = Integer.parseInt(values[3].trim());

                // Initialise a new level class with fetched values
                Level level = new Level(levelNumber, numCities, numBatteries, numMissiles);
                levels.add(level);
            }
        }

        reader.close();
    } catch (IOException e) {
        e.printStackTrace();
    }

}


/*
    nextLevel() handles level complete events
    The function plays a success sound effect and displays the start screen for the next level.
    The function also initialises a new GameState object for the next level
*/
void nextLevel() {
    // Plays mission success sound effect
    success.play();

    // Grab the current level number used for fetching next level
    int currentLevel = level.getLevelNumber();

    // Check if another level exists
    if (levels.size() > currentLevel) {
        // Fetch the next level object
        level = levels.get(currentLevel);
        // Store the score for the current game, for displaying on the success screen
        previousScore = game.getScore();
        // Update GameState
        game = new GameState(
            this,
            level.getLevelNumber(),
            level.getNumCities(),
            level.getNumBatteries(),
            level.getNumMissles(),
            previousScore
        );
        game.setup();

        // Initialise new Menu with new GameState
        menu = new Menu(game);

        // Set screen stype
        menu.setCurrentScreen(ScreenType.NEXT_LEVEL);
    } else {
        // If no more levels, set Paused state and display complete menu
        game.setPaused(true);
        menu.setCurrentScreen(ScreenType.COMPLETED);
    }

}




void draw() {

    if (game.getDestroyedMissileCount() >= game.getMaxMissiles() && !game.isPaused()) {
        nextLevel();
    }

    if (!game.isPaused()) {
        background.draw();
        game.update();
        game.draw();
    } else {
        menu.draw();
    }

    if (menu.getCurrentScreen() == ScreenType.COMPLETED) {
        resetGame();
    }

    if (menu.getRestarting()) {
        menu = new Menu(game);
    }
}

void resetGame() {
    previousScore = game.getScore();
    level = levels.get(0);
    game = new GameState(
        this,
        level.getLevelNumber(),
        level.getNumCities(),
        level.getNumBatteries(),
        level.getNumMissles(),
        previousScore
    );
    game.setup();
}

void mousePressed() {
    if (!game.isPaused()) {
        game.mouseClicked();
    } else {
        menu.mouseClicked();
    }

}

void keyPressed() {
    // Prevent paused screen functionality between levels
    if(game.isPaused() && menu.getCurrentScreen() != ScreenType.PAUSED) return;

    game.keyPressed();
}