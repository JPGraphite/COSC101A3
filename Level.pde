class Level {
    int levelNumber;
    int numCities;
    int numBatteries;
    

    Level(int levelNumber, int numCities, int numBatteries) {
        this.levelNumber = levelNumber;
        this.numCities = numCities;
        this.numBatteries = numBatteries;
        
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

    
}