import java.util.ArrayList;
import java.util.Iterator;

/* image found at https://www.pngwing.com/en/free-png-tovsr/download */

class ArtilleryBattery {
    float x; // X position of battery
    float y; // Y position of battery
    ArrayList < Laser > lasers; // List of lasers fired by the battery
    int remainingLasers;
    PImage imgBattery;

    ArtilleryBattery(float x, float y, int laserCount) {
        // Initialize battery at the given x and y position
        this.x = x;
        this.y = y;
        this.remainingLasers = laserCount;
        // Initialize list of lasers
        lasers = new ArrayList < Laser > ();
        imgBattery = loadImage("battery.png");
    }

    void drawTarget() {
        // Draw a target at the location of the mouse
        noFill();
        strokeWeight(1);
        stroke(0);
        point(mouseX, mouseY);
        ellipse(mouseX, mouseY, 20, 20);
        line(mouseX - 15, mouseY, mouseX - 5, mouseY);
        line(mouseX + 5, mouseY, mouseX + 15, mouseY);
        line(mouseX, mouseY - 5, mouseX, mouseY - 15);
        line(mouseX, mouseY + 5, mouseX, mouseY + 15);
    }

    void fire() {
        if (remainingLasers <= 0 ) return;
        remainingLasers--;
        float angle = atan2(mouseY - y, mouseX - x);
        float targetX = mouseX;
        float targetY = mouseY;
        // Create a new laser and add it to the list
        lasers.add(new Laser(x, y, targetX, targetY, angle));
    }

    void update() {
        // Update position of battery or other properties
        Iterator < Laser > iterator = lasers.iterator();
        while (iterator.hasNext()) {
            Laser laser = iterator.next();
            laser.update();
            if (laser.isExploded()) {
                iterator.remove();
            }
        }
    }

    void display() {
    pushMatrix();
    translate(this.x, this.y);
    rotate(PI / 2); // Rotate by 90 degrees (PI/2 radians)

    imageMode(CENTER);
    image(imgBattery, 0, 0, 40, 40); // Draw the image at (0, 0) relative to the translated position

    popMatrix();

    this.drawTarget();

    for (Laser laser : lasers) {
        laser.display();
    }
}

}