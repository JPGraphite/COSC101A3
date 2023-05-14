import processing.sound.*;

Level level;
GameState game;
Menu menu;
ArrayList<Level> levels = new ArrayList<Level>();
int previousScore = 0;
SoundFile success;
PApplet p = this;

void setup() {
    size(500, 500);
    noCursor();
    frameRate(30);
    background(0);
    createLevels();
    level = levels.get(0);

    game = new GameState(
        this,
        level.getLevelNumber(),
        level.getNumCities(),
        level.getNumBatteries(),
        level.getNumMissles(),
        previousScore
    );
    game.setPaused(true);
    menu = new Menu(game);
    game.setup();
    success = new SoundFile(this, "./data/success.wav");
    success.amp(0.5);


    // Create a new thread to load the audio file asynchronously
    Thread audioThread = new Thread(new AudioLoader(p, "./data/soundtrack.mp3"));
    audioThread.start();
}

void createLevels() {

    try {
        BufferedReader reader = createReader("levels.txt");
        String line = null;

        while ((line = reader.readLine()) != null) {
            String[] values = line.split(",");
            if (values.length == 4) {
                int levelNumber = Integer.parseInt(values[0].trim());
                int numCities = Integer.parseInt(values[1].trim());
                int numBatteries = Integer.parseInt(values[2].trim());
                int numMissiles = Integer.parseInt(values[3].trim());

                Level level = new Level(levelNumber, numCities, numBatteries, numMissiles);
                levels.add(level);
            }
        }

        reader.close();
    } catch (IOException e) {
        e.printStackTrace();
    }

}

void nextLevel() {
    success.play();
    int currentLevel = level.getLevelNumber();

    if (levels.size() > currentLevel) {
        level = levels.get(currentLevel);
        previousScore = game.getScore();
        game = new GameState(
            this,
            level.getLevelNumber(),
            level.getNumCities(),
            level.getNumBatteries(),
            level.getNumMissles(),
            previousScore
        );
        game.setup();
        menu = new Menu(game);
        menu.setCurrentScreen(ScreenType.NEXT_LEVEL);
    } else {
        game.setPaused(true);
        menu.setCurrentScreen(ScreenType.COMPLETED);
    }

}




void draw() {

    if (game.getDestroyedMissileCount() >= game.getMaxMissiles() && !game.isPaused()) {
        nextLevel();
    }

    if (!game.isPaused()) {
        background(255);
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