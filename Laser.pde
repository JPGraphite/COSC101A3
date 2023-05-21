/* laser image found at https://www.pngitem.com/middle/iRxoxRb_transparent-laser-sprite-laser-beam-sprite-png-png/ */

class Laser {
    float x; // X position of laser
    float y; // Y position of laser
    float targetX; // X position of target
    float targetY; // Y position of target
    float angle; // Angle of laser in radians
    float speed; // Speed of laser
    float size; // Size of laser
    boolean exploded; // Flag to indicate if laser has exploded
    int targetSize; // Size of the target
    boolean reachedTarget; // Flag to indicate if laser has reached the target
    int explosionDuration; // Duration of the explosion in frames
    int explosionTimer; // Timer for tracking explosion duration
    float explosionRadius; // Radius of the explosion circle
    float explosionMaxRadius; // Maximum radius of the explosion circle

    Laser(float startX, float startY, float targetX, float targetY, float angle) {
        // Initialize laser at the given x and y position
        this.x = startX;
        this.y = startY;
        // Set angle of laser
        this.angle = angle;
        this.targetX = targetX;
        this.targetY = targetY;
        this.exploded = false;
        this.targetSize = 5;
        this.reachedTarget = false;
        this.explosionDuration = 60; // 60 frames (assuming 60 frames per second)
        this.explosionTimer = 0;
        this.explosionRadius = 0;
        this.explosionMaxRadius = 30;
        // Set speed and size of laser
        speed = 10;
        size = 10;
    }

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