/*
    Class: Missile

    Represents a missile object in the game.

    Properties:
        - pos: Position of the missile
        - vel: Velocity of the missile
        - missileHeight: Height of the missile
        - missileWidth: Width of the missile
        - angle: Angle of the missile
        - velocity: Velocity vector of the missile
        - exploding: Indicates if the missile is currently exploding
        - explosionDuration: Duration of the explosion in frames
        - explosionTimer: Timer for tracking the explosion duration
        - explosionRadius: Radius of the explosion circle
        - explosionMaxRadius: Maximum radius of the explosion circle
        - explodeFinished: Indicates if the explosion animation has finished

    Methods:
        - Missile(): Constructor for creating a new missile object
        - update(): Updates the position of the missile
        - getAngle(): Generates a random angle for the missile trajectory
        - getCoords(): Calculates the coordinates of the missile's corners after rotation
        - explode(float explodePointX, float explodePointY): Triggers the explosion of the missile at the given point
        - display(): Displays the missile on the screen
*/


class Missile {
    PVector pos; // Position of missile
    PVector vel; // Velocity of missile
    int missileHeight; // Height of the missile
    int missileWidth; // Width of the missile
    float angle; // Angle of the missile
    PVector velocity; // Velocity vector of the missile
    boolean exploding = false; // Indicates if the missile is currently exploding
    int explosionDuration; // Duration of the explosion in frames
    int explosionTimer; // Timer for tracking explosion duration
    float explosionRadius; // Radius of the explosion circle
    float explosionMaxRadius; // Maximum radius of the explosion circle
    boolean explodeFinished = false; // Indicates if the explosion animation has finished

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
        missileHeight = 50; // Height of the missile
        missileWidth = 15; // Width of the missile

        imgMissile.resize(missileWidth, missileHeight);
        explosionDuration = 60; // 60 frames (assuming 60 frames per second)
        explosionTimer = 0; // Timer for tracking the explosion duration
        explosionRadius = 0; // Radius of the explosion circle
        explosionMaxRadius = 30; // Maximum radius of the explosion circle
    }

    void update() {
        if (exploding) return;
        // Update position of missile based on velocity
        pos.add(velocity);
    }

    /*
        getAngle();
        Calculates and returns the angle between a randomly generated vector and the x-axis.
        This is used to create random angles for spawned missiles
    */
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

    /*
        getCoords() is used to find the 4 corners of the missile after it's rotated
        This is used for collision detection
    */
    PVector[] getCoords() {
        // get current missile rotation
        float rotation = velocity.heading() + PI / 2;
        // Get half missile height and width, used to determine distances from center
        float halfMissileHeight = missileHeight / 2;
        float halfMissileWidth = missileWidth / 2;

        // Initial x and y coords used as base for rotation
        float initialX = pos.x;
        float initialY = pos.y;
        // Get cos and sin of current rotation
        float cosOfRotation = cos(rotation);
        float sinOfRotation = sin(rotation);

        // Calculate distances we need to move from our current x and y coordinates
        float xToMove = -halfMissileWidth * cosOfRotation - halfMissileHeight * sinOfRotation;
        float yToMove = -halfMissileWidth * sinOfRotation + halfMissileHeight * cosOfRotation;
        float xToMove2 = halfMissileWidth * cosOfRotation - halfMissileHeight * sinOfRotation;
        float yToMove2 = halfMissileWidth * sinOfRotation + halfMissileHeight * cosOfRotation;

        // Calculate new postions based off of the current position and the distance we need to move
        PVector topLeft = new PVector(initialX + xToMove, initialY + yToMove);
        PVector topRight = new PVector(initialX + xToMove2, initialY + yToMove2);
        PVector bottomLeft = new PVector(initialX - xToMove, initialY - yToMove);
        PVector bottomRight = new PVector(initialX - xToMove2, initialY - yToMove2);

        // Add points to array and return
        PVector[] points = {
            topLeft,
            topRight,
            bottomRight,
            bottomLeft
        };
        return points;
    }


    /*
        explode(float explodePointX, float explodePointY);
        Triggers the explosion of the missile at the specified point.
    */
    void explode(float explodePointX, float explodePointY) {
        exploding = true;
        missileHit.play();
        pos.x = explodePointX;
        pos.y = explodePointY;
    }


    /*
        display();
        Displays the missile on the screen. If the missile is exploding, it shows the explosion animation. Otherwise, it shows the missile image.
    */
    void display() {

        if (exploding) {
            float currentRadius = explosionRadius;
            imageMode(CENTER);
            if (explosionRadius < explosionMaxRadius) {
                explosionRadius++;
                image(imgMissileExplosion, pos.x, pos.y, currentRadius * 2, currentRadius * 2);
            } else {
                explodeFinished = true;
            }
        } else {
            pushMatrix();
            translate(pos.x, pos.y);
            rotate(velocity.heading() + PI / 2);

            imageMode(CORNER);
            image(imgMissile, -missileWidth / 2, -missileHeight / 2); // Adjust image positioning based on size
            popMatrix();
        }
    }
}