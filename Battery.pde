import java.util.ArrayList;
import java.util.Iterator;

/* battery image found at https://www.pngwing.com/en/free-png-tovsr/download */
/* laser image found at https://www.pngitem.com/middle/iRxoxRb_transparent-laser-sprite-laser-beam-sprite-png-png/ */

class ArtilleryBattery {
    float x; // X position of battery
    float y; // Y position of battery
    ArrayList < Laser > lasers; // List of lasers fired by the battery
    int remainingLasers;

    ArtilleryBattery(float x, float y, int laserCount) {
        // Initialize battery at the given x and y position
        this.x = x;
        this.y = y;
        this.remainingLasers = laserCount;
        // Initialize list of lasers
        lasers = new ArrayList < Laser > ();
    }

    void drawTarget() {
        // Draw a target at the location of the mouse
        noFill();
        strokeWeight(1);
        if( remainingLasers > 0) {
            stroke(0);
        } else {

            stroke(255, 0, 0);
            line(mouseX - 10, mouseY -10, mouseX +10, mouseY +10);
            line(mouseX + 10, mouseY - 10, mouseX -10, mouseY +10);
        }

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
            if (laser.exploded) {
                iterator.remove();
            }
        }
    }

    void display() {
        // Calculate the angle between battery position and mouse position
        float angle = atan2(mouseY - this.y, mouseX - this.x);

        pushMatrix();
        translate(this.x, this.y);
        rotate(angle + PI); // Rotate based on the calculated angle to point towards target

        imageMode(CENTER);
        image(imgBattery, 0, 0, 50, 50); // Draw the image at (0, 0) relative to the translated position

        popMatrix();

        this.drawTarget();

        for (Laser laser : lasers) {
            laser.display();
        }
    }


}