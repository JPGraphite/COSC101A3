/*
    Class: Level

    Represents a level in the game.

    Properties:
        - levelNumber: Number of the level (int)
        - numLasers: Number of Lasers in the level (int)
        - numMissiles: Number of missiles in the level (int)
        - highScore: High score achieved in the level (int)

*/


class Level {
    int levelNumber; // Number of the level
    int numLasers; // Number of Lasers in the level
    int numMissiles; // Number of missiles in the level
    int highScore; // High score achieved in the level

    Level(int levelNumber,  int numLasers, int numMissiles, int highScore) {
        this.levelNumber = levelNumber;
        this.numLasers = numLasers;
        this.numMissiles = numMissiles;
        this.highScore = highScore;
    }


}