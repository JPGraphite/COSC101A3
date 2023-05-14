import processing.sound.*;

Level level;
GameState game;
Menu menu;
ArrayList<Level> levels = new ArrayList<Level>();
int previousScore = 0;
SoundFile soundtrack, success;

void setup() {
    size(500, 500);
    noCursor();
    frameRate(30);
    background(0);
    textAlign(CENTER, CENTER);
    textSize(32);

    fill(255);
    text("Loading...", width/2, height/2);

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
    soundtrack = new SoundFile(this, "./data/soundtrack.mp3");
    success = new SoundFile(this, "./data/success.wav");
    success.amp(0.5);
    soundtrack.loop();
    soundtrack.amp(0.5);

}


void createLevels() {
    levels.add(new Level(1, 1, 1, 1));
    levels.add(new Level(2, 1, 1, 15));
    levels.add(new Level(3, 1, 1, 20));
}

void nextLevel() {
    success.play();
    int currentLevel = level.getLevelNumber();
    level = levels.get(currentLevel);
    previousScore = game.getScore();
    println(previousScore);
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
}


void draw() {


    if (game.getDestroyedMissileCount() >= game.getMaxMissiles()) {
        nextLevel();
    }

    if (!game.isPaused()) {
        background(255);
        game.update();
        game.draw();
    } else {
        menu.draw();
    }
}

void mouseClicked() {
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