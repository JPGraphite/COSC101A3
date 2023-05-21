/*
    Class: Level

    Represents a level in the game.

    Properties:
        - levelNumber: Number of the level (int)
        - numBatteries: Number of batteries in the level (int)
        - numMissiles: Number of missiles in the level (int)
        - highScore: High score achieved in the level (int)

*/


class Level {
    int levelNumber;
    int numBatteries;
    int numMissiles;
    int highScore;

    Level(int levelNumber,  int numBatteries, int numMissiles, int highScore) {
        this.levelNumber = levelNumber;
        this.numBatteries = numBatteries;
        this.numMissiles = numMissiles;
        this.highScore = highScore;
    }


}