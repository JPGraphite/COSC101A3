class Menu {
    GameState game;
    int buttonStandardColour = 255;
    int buttonHoverColour = 122;
    int currentButtonColour = 255;
    int buttonWidth = 120;
    int buttonHeight = 40;
    int buttonX = width/2;
    int buttonY = height/2 + 50;
    int score;
    int level;
    ScreenType currentScreen = ScreenType.STARTING;

    Menu(GameState game) {
      this.game = game;
    }

    void draw() {

        switch (currentScreen) {
            case STARTING:
                drawStartingScreen();
                break;

            case PAUSED:
                drawPausedScreen();
                break;

            case NEXT_LEVEL:
                drawNextLevelScreen();
                break;

            default:
                // Code for handling unknown or unsupported screen types
                println("Unknown screen type");
                break;
        }

    }

    void setCurrentScreen(ScreenType type) {
        currentScreen = type;
    }

    ScreenType getCurrentScreen() {
        return currentScreen;
    }


    void drawNextLevelScreen() {
        drawStartingScreen();

        // Draw additional text
        fill(255);
        textSize(20);
        text("Score: " + game.getPreviousScore(), width/2, height/2 - 50);
    }


    void drawStartingScreen() {
        checkButtonHover();
        textAlign(CENTER, CENTER);
        textSize(32);

        background(0);
        cursor();

        // Draw additional text
        fill(255);
        textSize(20);
        text("Level: " + game.getLevelNumber(), width/2, height/2 - 90);
        drawButton("Start");
    }

    void drawPausedScreen() {
        checkButtonHover();
        textAlign(CENTER, CENTER);
        textSize(32);

        background(0);
        cursor();


        // Draw additional text
        fill(255);
        textSize(20);
        text("Level: " + game.getLevelNumber(), width/2, height/2 - 90);
        text("Score: " + game.getScore(), width/2, height/2 - 50);

        // Draw "Paused" heading in white
        fill(255);
        text("Game paused", width/2, 50);
        drawButton("Resume");


    }

    void checkButtonHover() {
        boolean overButton = isMouseOverButton();

        if (overButton) {
            currentButtonColour = buttonHoverColour;
            cursor(HAND);
        } else {
            currentButtonColour = buttonStandardColour;
            cursor(ARROW);
        }
    }

    void mouseClicked() {
        boolean overButton = isMouseOverButton();
        if (overButton) {
            game.setPaused(false);
            currentScreen = ScreenType.PAUSED;
        }
    }

    boolean isMouseOverButton() {
        if (mouseX >= width/2 - 60 && mouseX <= width/2 + 60 &&
            mouseY >= height/2 + 30 && mouseY <= height/2 + 70) {
            return true;
        } else {
            return false;
        }
    }


    void drawButton(String text) {
    // Draw button with black background and white outline
        fill(0);
        stroke(currentButtonColour);
        rectMode(CENTER);
        rect(buttonX, buttonY, buttonWidth, buttonHeight);

        // Draw text in white
        fill(currentButtonColour);
        text(text, buttonX, buttonY - 5);
    }

}