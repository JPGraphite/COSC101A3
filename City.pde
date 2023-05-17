class City {
    float x, y;
    float cityWidth, cityHeight;

    City(float x, float y) {
        this.x = x;
        this.y = y;
        this.cityWidth = 60;
        this.cityHeight = 40;
    }



    void update() {
        // Update logic for the city
    }

    void display() {
        fill(0, 100, 200);
        stroke(0, 100, 200);
        rectMode(CENTER);
        rect(x, y + cityHeight /2 - 10, cityWidth, cityHeight);
    }
}
