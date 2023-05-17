class City {
    float x, y;
    float cityWidth, cityHeight;
    boolean alive = true;

    City(float x, float y) {
        this.x = x;
        this.y = y;
        this.cityWidth = 60;
        this.cityHeight = 40;
    }


    public float getX() {
        return x;
    }

    public float getY() {
        return y;
    }

    public float getWidth() {
        return cityWidth;
    }

    public float getHeight() {
        return cityHeight;
    }


    public void setAlive(boolean value) {
        alive = value;
    }
    void update() {
        // Update logic for the city
    }

    void display() {
        if (alive) {
            fill(0, 100, 200);
            stroke(0, 100, 200);
            rectMode(CENTER);
            rect(x, y + cityHeight / 2 - 10, cityWidth, cityHeight);



        } else {
            fill(255, 0, 0);
            stroke(0, 100, 200);
            // Calculate the vertices of the triangle
            // Draw the triangle
            triangle(x - cityWidth / 2, y + cityHeight - 10, x + cityWidth / 2, y + cityHeight - 10, x, y);
        }
    }
}