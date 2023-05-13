Level level;
GameState game;
 // testing
 
void setup() {
    size(500, 500);
    noCursor();
    frameRate(30);
    level = new Level(1, 1, 1);
    game = new GameState(
        level.getLevelNumber(),
        level.getNumCities(),
        level.getNumBatteries()
        
    );
    game.setup();
}

void draw() {
    background(255);
    game.update();
    game.draw();
}

void mouseClicked() {
    game.mouseClicked();
}

void keyPressed() {
    // missiles = append(missiles, new Missile());
}