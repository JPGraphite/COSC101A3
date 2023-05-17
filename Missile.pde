/* missile image located at https://www.clipartkey.com/downpng/Tohhoo_nuke-clipart-missile-launch-transparent-background-missile-png/ */

class Missile {
    PVector pos; // Position of missile
    PVector vel; // Velocity of missile
    float size; // Size of missile
    float angle; // Angle of missile
    PVector velocity;
    PImage imgMissile;
    boolean exploding = false;
    int explosionDuration; // Duration of the explosion in frames
    int explosionTimer; // Timer for tracking explosion duration
    float explosionRadius; // Radius of the explosion circle
    float explosionMaxRadius; // Maximum radius of the explosion circle
    boolean explodeFinished = false;

    Missile() {
        // Initial velocity set to 2 for in both x and y direction
        velocity = new PVector(2, 2);
        // Initialize missile at random x position at the top of the screen
        pos = new PVector(random(width), 0);
        // Set angle between -PI/4 and PI/4 to keep missile on screen
        angle = this.getAngle();
        velocity = PVector.fromAngle(angle);
        // Set speed and size of missile

        velocity.mult(5); // Set speed of missile
        size = 20;

        imgMissile = loadImage("missile.png");
        imgMissile.resize(20, 40);
        explosionDuration = 60; // 60 frames (assuming 60 frames per second)
        explosionTimer = 0;
        explosionRadius = 0;
        explosionMaxRadius = 20;
    }

    public float getX() {
        return pos.x;
    }

    public float getY() {
        return pos.y;
    }

    public float getSize() {
        return size;
    }

    void update() {
        if (exploding) return;
        // Update position of missile based on velocity
        pos.add(velocity);
    }

    float getAngle() {
        // Generate a random starting x position at the top of the screen
        float startX = pos.x;
        float startY = pos.y;

        // Generate a random ending x position at the bottom of the screen
        float endX = random(width);
        float endY = height;

        // Calculate the vector between the two points
        float dx = endX - startX;
        float dy = endY - startY;

        // Calculate the angle between the vector and the x-axis
        float calcAngle = atan2(dy, dx);
        return calcAngle;
    }

    void explode() {
        exploding = true;
    }


    void display() {
        if (exploding) {
            stroke(255, 0, 0);
            fill(255, 0, 0);
            strokeWeight(2);
            float currentRadius = explosionRadius;
            if (explosionRadius < explosionMaxRadius) {
                explosionRadius++;
                ellipse(pos.x, pos.y + size / 2, currentRadius * 2, currentRadius * 2);
            } else {
                println("Done");
                explodeFinished = true;
            }
        } else {
            pushMatrix();
            translate(pos.x, pos.y);
            rotate(velocity.heading() + PI / 2);
            image(imgMissile, -size / 2, -size / 2); // Adjust image positioning based on size
            popMatrix();
        }
    }
}