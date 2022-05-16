public class AirStrike {

    // Instantiate air strike variables
    int size;
    PVector position;
    int numBombs;
    int bombTimer;
    int maxBombTimer;
    PVector[] bombPositions;
    float[] bombSizes;
    float[] currentBombSizes;
    boolean exploding;
    boolean used;

    // Constructor initialises all class variables
    AirStrike(int size, int numBombs, int maxBombTimer) {
        this.size = size;
        this.position = new PVector(0, 0);
        this.numBombs = numBombs;
        this.bombTimer = 0;
        this.maxBombTimer = maxBombTimer;
        this.bombPositions = new PVector[numBombs];
        this.bombSizes = new float[numBombs];
        this.currentBombSizes = new float[numBombs];
        this.exploding = false;
        this.used = false;

        // Randomly pick bomb positions and randomly select bomb sizes
        for (int i = 0; i < numBombs; i++) {
            bombPositions[i] = new PVector(random(0, size) - random(0, size), random(0, size) - random(0, size));
            bombSizes[i] = random(size / 2, size * 2);
        }
    }

    // Draw the air strike bombs
    void draw() {
        if (used || !exploding) {
            return;
        }
        bombTimer++;
        if (bombTimer > maxBombTimer) {
            bombTimer = 0;
            exploding = false;
            used = true;
        }
        pushMatrix();
        translate(position.x, position.y);
        for (int i = 0; i < numBombs; i++) {
            fill(255, 0, 0);
            if (bombTimer < maxBombTimer/2) {
                currentBombSizes[i] = bombSizes[i] * bombTimer / (maxBombTimer / 2);
                ellipse(bombPositions[i].x, bombPositions[i].y, currentBombSizes[i], currentBombSizes[i]);
            } else {
                currentBombSizes[i] = bombSizes[i] * (maxBombTimer - bombTimer) / (maxBombTimer / 2);
                ellipse(bombPositions[i].x, bombPositions[i].y, currentBombSizes[i], currentBombSizes[i]);
            }
        }
        popMatrix();
    }

    // Drop an air strike
    void drop(int posX, int posY) {
        exploding = true;
        position = new PVector(posX, posY);
    }

    // Reset the air strike variables
    void reset() {
        bombTimer = 0;
        for (int i = 0; i < numBombs; i++) {
            bombPositions[i] = new PVector(random(0, size * 2) - random(0, size * 2), random(0, size * 2) - random(0, size * 2));
            bombSizes[i] = random(size / 2, size * 2);
        }
        exploding = false;
        used = false;
    }
}