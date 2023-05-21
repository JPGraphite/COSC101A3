/*
    Class: City

    Represents a city in the game.

    Properties:
        - x: X-coordinate of the city (float)
        - y: Y-coordinate of the city (float)
        - cityWidth: Width of the city (float)
        - cityHeight: Height of the city (float)
        - alive: Indicates if the city is alive or destroyed (boolean)

    Methods:
        - City(x, y, cityWidth, cityHeight): Constructor for the City class
        - display(): Displays the city based on its alive state

*/

class City {
    // X and Y coordinates of the city
    float x, y;
    // Width and height of the city
    float cityWidth, cityHeight;
    // Indicates if the city is alive or destroyed (boolean)
    boolean alive = true;


    City(float x, float y, float cityWidth, float cityHeight) {
        // X and Y coordinates of the city
        this.x = x;
        this.y = y;
        // Width and height of the city
        this.cityWidth = cityWidth;
        this.cityHeight = cityHeight;

    }

    /*
        display();
        Displays the city on the screen.
        If the city is alive, it displays the image of the city.
        If the city is destroyed, it displays the image of flames.
    */
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