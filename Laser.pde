/*
    Class: Laser

    Represents a laser object in the game.

    Properties:
        - x: X position of laser (float)
        - y: Y position of laser (float)
        - targetX: X position of target (float)
        - targetY: Y position of target (float)
        - angle: Angle of laser in radians (float)
        - speed: Speed of laser (float)
        - size: Size of laser (float)
        - exploded: Flag to indicate if laser has exploded (boolean)
        - targetSize: Size of the target (int)
        - reachedTarget: Flag to indicate if laser has reached the target (boolean)
        - explosionDuration: Duration of the explosion in frames (int)
        - explosionTimer: Timer for tracking explosion duration (int)
        - explosionRadius: Radius of the explosion circle (float)
        - explosionMaxRadius: Maximum radius of the explosion circle (float)

    Methods:
        - Laser(float startX, float startY, float targetX, float targetY, float angle): Constructor for creating a new laser object
        - update(): Updates the position of the laser
        - display(): Displays the laser on the screen
*/


class Laser {
    float x; // X position of laser
    float y; // Y position of laser
    float targetX; // X position of target
    float targetY; // Y position of target
    float angle; // Angle of laser in radians
    float speed = 10; // Speed of laser
    float size = 10; // Size of laser
    boolean exploded; // Flag to indicate if laser has exploded
    int targetSize; // Size of the target
    boolean reachedTarget; // Flag to indicate if laser has reached the target
    int explosionDuration; // Duration of the explosion in frames
    int explosionTimer; // Timer for tracking explosion duration
    float explosionRadius; // Radius of the explosion circle
    float explosionMaxRadius; // Maximum radius of the explosion circle


    Laser(float startX, float startY, float targetX, float targetY, float angle) {
        // Initialize laser at the given x and y position
        this.x = startX; // X position of laser
        this.y = startY; // Y position of laser
        // Set angle of laser
        this.angle = angle; // Angle of laser in radians
        this.targetX = targetX; // X position of target
        this.targetY = targetY; // Y position of target
        this.exploded = false;
        this.targetSize = 5;
        this.reachedTarget = false;
        this.explosionDuration = 60; // Duration of the explosion in frames
        this.explosionTimer = 0; // Timer for tracking explosion duration
        this.explosionRadius = 0; // Radius of the explosion circle
        this.explosionMaxRadius = 30; // Maximum radius of the explosion circle
    }


    /*
        update();
        Updates the position and state of the laser.
        If the laser has not exploded:
        - Checks if the laser has reached the target. If so, sets the reachedTarget flag to true.
        - Updates the position of the laser based on its angle and speed.
        If the laser has reached the target:
        - Starts the explosion timer.
        - If the explosion timer exceeds the explosion duration, sets the exploded flag to true.
    */
    void update() {
        if (!exploded) {
            // Check if laser has reached the target
            if (dist(x, y, targetX, targetY) <= speed) {
                reachedTarget = true;
            }

            if (!reachedTarget) {
                // Update position of laser based on angle and speed
                x += cos(angle) * speed;
                y += sin(angle) * speed;
            } else {
                // Laserhas reached the target, start explosion timer
                explosionTimer++;
                if (explosionTimer >= explosionDuration) {
                    exploded = true;
                }
            }
        }
    }


    /*
        display();
        Displays the laser on the screen.
        If the laser has not exploded and has not reached the target:
        - Calculates the angle between the laser position and the target position.
        - Applies a transformation to translate and rotate the coordinate system to the laser position and angle.
        - Draws the laser as a rotated image at the center (0, 0).
        - Draws cross to represent target
        If the laser has exploded:
        - Draws the explosion by gradually increasing the explosion radius and displaying the explosion image.
    */
    void display() {
        if (!exploded && !reachedTarget) {
            // Calculate the angle between the laser position and the mouse position
            float targetAngle = atan2(targetY - y, targetX - x);

            pushMatrix(); // Save the current transformation matrix
            translate(x, y); // Translate to the laser position
            rotate(targetAngle + PI / 2); // Rotate by the target angle

            // Draw laser as a rotated image
            image(imgLaser, 0, 0, size, size * 2); // Draw the image at the center (0, 0)

            popMatrix(); // Restore the previous transformation matrix

            //image(imgLaser, x, y, lineX2, lineY2);
            line(targetX - targetSize, targetY - targetSize, targetX + targetSize, targetY + targetSize);
            line(targetX + targetSize, targetY - targetSize, targetX - targetSize, targetY + targetSize);
        } else {
            float currentRadius = explosionRadius;
            if (explosionRadius < explosionMaxRadius) {
                explosionRadius++;
                 fill(0, 0, 0);
                 stroke(100, 100, 0);
                 strokeWeight(2);

                ellipse(targetX , targetY, explosionMaxRadius, explosionMaxRadius);
                image(imgLaserExplosion, targetX, targetY, currentRadius * 2, currentRadius * 2);

            }
        }
    }
}