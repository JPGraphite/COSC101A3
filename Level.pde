class Level {
    int levelNumber;
    int numBatteries;
    int numMissiles;

    Level(int levelNumber,  int numBatteries, int numMissiles) {
        this.levelNumber = levelNumber;
        this.numBatteries = numBatteries;
        this.numMissiles = numMissiles;

    }

    int getLevelNumber() {
        return this.levelNumber;
    }



    int getNumBatteries() {
        return this.numBatteries;
    }

    int getNumMissles() {
        return this.numMissiles;
    }


}