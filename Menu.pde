/*
    Class: Menu

    Represents the game menu and various screens.

    Properties:
        - game: Reference to the GameState object
        - buttonStandardColour: Color of the button in its standard state
        - buttonHoverColour: Color of the button when the mouse is hovering over it
        - currentButtonColour: Current color of the button
        - buttonWidth: Width of the button
        - buttonHeight: Height of the button
        - buttonX: X-coordinate of the button
        - buttonY: Y-coordinate of the button
        - loadingScore: Score used for the loading animation
        - score: Score obtained in the game
        - level: Level number
        - currentScreen: Current screen type
        - restarting: Indicates if the game is being restarted

    Methods:
        - draw(): Draws the current screen based on the currentScreen variable
        - setCurrentScreen(type: ScreenType): Sets the current screen type
        - drawCompletedScreen(): Draws the game completed screen
        - drawNextLevelScreen(): Draws the next level screen
        - drawStartingScreen(): Draws the starting screen
        - drawPausedScreen(): Draws the paused screen
        - checkButtonHover(): Checks if the mouse is hovering over the button and updates the button color and cursor accordingly
        - mouseClicked(): Handles the mouse click event and performs actions based on the current screen and button interaction
        - isMouseOverButton(): Checks if the mouse is over the button
        - drawButton(text: String): Draws the button with the specified text

    Dependencies:
        - GameState: The GameState class representing the game state
        - ScreenType: An enum representing different screen states
*/


class Menu {
    GameState game;

    // Button settings for triggering start, resume and restart
    int buttonStandardColour = 255; // Color of the button in its standard state
    int buttonHoverColour = 122; // Color of the button when the mouse is hovering over it
    int currentButtonColour = 255; // Current color of the button
    int buttonWidth = 120; // Width of the button
    int buttonHeight = 40; // Height of the button
    int buttonX = width / 2; // X-coordinate of the button
    int buttonY = height / 2 + 150; // Y-coordinate of the button
    int loadingScore = 0; // Score used for the loading animation

    // Score and level variables which will be pulled from GameState
    int score; // Score obtained in the game
    int level; // Level number

    // Screentype enum for determining which screen to display
    ScreenType currentScreen = ScreenType.STARTING; // Current screen type
    boolean restarting = false; // Indicates if the game is being restarted

    Menu(GameState game) {
        this.game = game;
    }

    /*
        draw();
        Draws the appropriate screen based on the currentScreen variable.
    */
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


    /*
        drawCompletedScreen();
        Draws the game completed screen with score and restart button
    */
    void drawCompletedScreen() {
        checkButtonHover();

        background(0);
        cursor();
        // Draw additional text
        fill(255);
        textAlign(CENTER, TOP);
        textSize(24);
        text("Game Completed", width / 2, 50);

        textAlign(CENTER, CENTER);
        textSize(20);
        text("Level: " + game.levelNumber, width / 2, height / 2 - 90);
        text("High Score: " + game.highScore, width / 2, height / 2 - 60);
        text("Score: " + game.score, width / 2, height / 2 - 30);

        drawButton("Restart");
    }


    /*
        drawNextLevelScreen();
        Draws the next level screen, incorporating the base starting screen setup for button and score display
    */
    void drawNextLevelScreen() {

        if (loadingScore + 15 < game.previousScore) {
            loadingScore += 15;
        } else {
            loadingScore = game.previousScore;
        }
        drawStartingScreen();
        fill(255);
        text("Next level:", width / 2, height / 2 - 30);
        textSize(24);
        text("Level " + (game.levelNumber - 1) + " Completed!", width / 2, height / 2 - 210);
        textSize(20);
        text("Your Score: " + loadingScore, width / 2, height / 2 - 180);
        text("High Score: " + game.previousHighScore, width / 2, height / 2 - 150);


    }

    /*
        drawStartingScreen();
        Draws the initial starting screen, handling button hover events and displaying score and level info
    */
    void drawStartingScreen() {
        checkButtonHover();

        background(0);
        cursor();

        // Draw additional text
        textAlign(CENTER, CENTER);
        fill(255);
        textSize(20);
        text("Level: " + game.levelNumber, width / 2, height / 2 - 0);
        text("High Score: " + game.highScore, width / 2, height / 2 + 30);

        drawButton("Start");
    }

    /*
        drawPausedScreen();
        Draws the pause screen displaying current level information and score. Also initialised a resume game button
    */
    void drawPausedScreen() {
        checkButtonHover();
        textAlign(CENTER, CENTER);

        background(0);
        cursor();


        // Draw additional text
        fill(255);
        textSize(20);
        text("Level: " + game.levelNumber, width / 2, height / 2 - 90);
        text("High Score: " + game.highScore, width / 2, height / 2 - 60);
        text("Score: " + game.score, width / 2, height / 2 - 30);

        // Draw "Paused" heading in white
        fill(255);
        text("Game paused", width / 2, 50);
        drawButton("Resume");

    }

    /*
        checkButtonHover();
        Checks to see if the mouse is currently over a button, and switches the button colour and cursor display depending on the state
    */
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

    /*
        mouseClicked();
        Checks to see if the mouse is clicked over a button, and changes the game state depending on screen type
    */
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

    /*
        isMouseOverButton();
        Calculates if mouse position is over the rendered button
    */
    boolean isMouseOverButton() {
        if (mouseX >= buttonX - buttonWidth / 2 && mouseX <= buttonX + buttonWidth / 2 &&
            mouseY >= buttonY - buttonHeight / 2 && mouseY <= buttonY + buttonHeight / 2) {
            return true;
        } else {
            return false;
        }
    }

    /*
        drawButton();
        Universal draw function for rendering a central button in the Menu
    */
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