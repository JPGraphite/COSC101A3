/*
    Menu class is used for displaying UI before and between games, as well as on pause
    It takes a GameState class as a parameter, as it is requires values from this such as the level number and score
*/


class Menu {
    GameState game;

    // Button settings for triggering start, resume and restart
    int buttonStandardColour = 255;
    int buttonHoverColour = 122;
    int currentButtonColour = 255;
    int buttonWidth = 120;
    int buttonHeight = 40;
    int buttonX = width/2;
    int buttonY = height/2 + 150;

    // Score and level variables which will be pulled from GameState
    int score;
    int level;

    // Screentype enum for determining which screen to display
    ScreenType currentScreen = ScreenType.STARTING;
    boolean restarting = false;

    Menu(GameState game) {
      this.game = game;
    }

    void draw() {
        // Switch Statement which triggers different screens dependant on currentScreen variable
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

            case COMPLETED:
                drawCompletedScreen();
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


    void drawCompletedScreen() {
        checkButtonHover();

        background(0);
        cursor();
        // Draw additional text
        fill(255);
        textAlign(CENTER, TOP);
        textSize(24);
        text("Game Completed", width/2, 50);

        textAlign(CENTER, CENTER);
        textSize(20);
        text("Level: " + game.levelNumber, width/2, height/2 - 90);
        text("High Score: " + game.highScore, width/2, height/2 - 60);
        text("Score: " + game.score, width/2, height/2 - 30);

        drawButton("Restart");
    }

    void drawNextLevelScreen() {


        drawStartingScreen();
        fill(255);
        text("Next level:", width/2, height/2 - 30);
        textSize(24);
        text("Level " + (game.levelNumber-1) + " Completed!", width/2, height/2 - 210);
        textSize(20);
        text("Your Score: " + game.previousScore, width/2, height/2 - 180);
        text("High Score: " + game.previousHighScore, width/2, height/2 - 150);


    }


    void drawStartingScreen() {
        checkButtonHover();

        background(0);
        cursor();

        // Draw additional text
        textAlign(CENTER, CENTER);
        fill(255);
        textSize(20);
        text("Level: " + game.levelNumber, width/2, height/2 - 0);
        text("High Score: " + game.highScore, width/2, height/2 +30);

        drawButton("Start");
    }

    void drawPausedScreen() {
        checkButtonHover();
        textAlign(CENTER, CENTER);

        background(0);
        cursor();


        // Draw additional text
        fill(255);
        textSize(20);
        text("Level: " + game.levelNumber, width/2, height/2 - 90);
        text("High Score: " + game.highScore, width/2, height/2 - 60);
        text("Score: " + game.score, width/2, height/2 - 30);

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
            if (currentScreen != ScreenType.COMPLETED) {
                currentScreen = ScreenType.PAUSED;
            } else {
                restarting = true;
                currentScreen = ScreenType.STARTING;
            }
        }
    }

    boolean isMouseOverButton() {
        if (mouseX >= buttonX - buttonWidth/2 && mouseX <= buttonX + buttonWidth/2 &&
            mouseY >= buttonY - buttonHeight/2 && mouseY <= buttonY + buttonHeight/2) {
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