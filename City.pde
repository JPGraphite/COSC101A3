/* city image located at https://www.clipartkey.com/downpng/JbbTh_skyscraper-clipart-transparent-city-clipart-transparent/ */
/* flames image located at https://www.clipartkey.com/downpng/xwowJ_flame-fire-flames-clipart-bottom-border-transparent-free/ */

class City {
    float x, y;
    float cityWidth, cityHeight;
    boolean alive = true;

    City(float x, float y, float cityWidth, float cityHeight) {
        this.x = x;
        this.y = y;
        this.cityWidth = cityWidth;
        this.cityHeight = cityHeight;

    }

    void setAlive(boolean value) {
        alive = value;
    }
    void update() {
        // Update logic for the city
    }

    void display() {
        if (alive) {
            imageMode(CORNER);
            image(imgCity, x, y - cityHeight / 2, cityWidth, cityHeight);
        } else {
            imageMode(CORNER);
            image(imgFlames, x, y - cityHeight / 2, cityWidth, cityHeight);
        }
    }
}