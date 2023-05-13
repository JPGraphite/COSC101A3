class City {
    float x, y;
    float width, height;

    City(float x, float y) {
        this.x = x;
        this.y = y;
        this.width = 80;
        this.height = 40;
    }

    void update() {
        // Update logic for the city
    }

    void draw() {
        fill(0, 100, 200);
        stroke(0, 100, 200);
        rectMode(CENTER);
        rect(x, y, width, height);
    }
}