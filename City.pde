/* city image located at https://www.clipartkey.com/downpng/JbbTh_skyscraper-clipart-transparent-city-clipart-transparent/ */
/* flames image located at https://www.clipartkey.com/downpng/xwowJ_flame-fire-flames-clipart-bottom-border-transparent-free/ */

class City {
    float x, y;
    float cityWidth, cityHeight;
    boolean alive = true;
    PImage imgCity;
    PImage imgFlames;

    City(float x, float y) {
        this.x = x;
        this.y = y;
        this.cityWidth = 60;
        this.cityHeight = 40;
        imgCity = loadImage("city.png");
        imgFlames = loadImage("flames.png");
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

            imageMode(CENTER);
            image(imgCity, x, y + cityHeight / 2 - 10, cityWidth, cityHeight);



        } else {
            imageMode(CENTER);
            image(imgFlames, x, y + cityHeight / 2 - 10, cityWidth, cityHeight);
        }
    }
}