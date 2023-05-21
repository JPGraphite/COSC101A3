import java.util.ArrayList;
import java.util.Iterator;

/*

    Class: ArtilleryBattery

    Represents an artillery battery in the game.


    Properties:
        - x: X position of the battery (float)
        - y: Y position of the battery (float)
        - lasers: List of lasers fired by the battery (ArrayList<Laser>)
        - remainingLasers: Number of remaining lasers that can be fired (int)

    Methods:
        - ArtilleryBattery(x, y, laserCount): Constructor for the ArtilleryBattery class
        - drawTarget(): Draws a target at the location of the mouse
        - fire(): Fires a laser from the battery towards the mouse position
        - update(): Updates the position of the battery and the lasers
        - display(): Displays the artillery battery and the lasers

*/

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


    /*
        drawTarget();
        Draws a target at the location of the mouse.
        If there are remaining lasers, the target is displayed in black.
        If there are no remaining lasers, the target is displayed in red with crosshairs.
    */
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


    /**
        fire();
        Fires a laser from the artillery battery towards the current mouse position.
        If there are no remaining lasers, the function returns early.
        Decrements the remainingLasers count.
    */
    void fire() {
        if (remainingLasers <= 0 ) return;
        remainingLasers--;
        float angle = atan2(mouseY - y, mouseX - x);
        float targetX = mouseX;
        float targetY = mouseY;
        // Create a new laser and add it to the list
        lasers.add(new Laser(x, y, targetX, targetY, angle));
    }


    /**
        update();
        Iterates through the list of lasers and updates each laser.
        If a laser has exploded, it is removed from the list.
    */
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

    /*
        Displays the artillery battery, target, and lasers.
        Calculates the angle between the battery position and the mouse position to rortate the battery.
        Draws the battery image relative to the translated position.
        Displays each laser in the lasers list.
    */
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