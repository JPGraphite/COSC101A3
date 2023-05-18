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
        this.explosionMaxRadius = 20;
        // Set speed and size of laser
        speed = 10;
        size = 3;
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
            // Draw laser as a small line
            stroke(255, 0, 0);
            strokeWeight(size);
            float lineLength = size * 4;
            float lineX2 = x + cos(angle) * lineLength;
            float lineY2 = y + sin(angle) * lineLength;
            line(x, y, lineX2, lineY2);
            line(targetX - targetSize, targetY - targetSize, targetX + targetSize, targetY + targetSize);
            line(targetX + targetSize, targetY - targetSize, targetX - targetSize, targetY + targetSize);
        } else {
            stroke(255, 0, 0);
            strokeWeight(2);
            float currentRadius = explosionRadius;
            if (explosionRadius < explosionMaxRadius) {
                explosionRadius++;
                ellipse(targetX, targetY, currentRadius * 2, currentRadius * 2);
            }
        }
    }
}