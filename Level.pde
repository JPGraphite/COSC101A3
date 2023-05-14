class Level {
    int levelNumber;
    int numCities;
    int numBatteries;
    int numMissiles;

    Level(int levelNumber, int numCities, int numBatteries, int numMissiles) {
        this.levelNumber = levelNumber;
        this.numCities = numCities;
        this.numBatteries = numBatteries;
        this.numMissiles = numMissiles;

    }

    int getLevelNumber() {
        return this.levelNumber;
    }

    int getNumCities() {
        return this.numCities;
    }

    int getNumBatteries() {
        return this.numBatteries;
    }

    int getNumMissles() {
        return this.numMissiles;
    }


}