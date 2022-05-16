public class Human {

    // Instatiate the size, position, and velocity of the human
    int size;
    PVector position;
    PVector velocity;

    // Instantiate the alive flag and human age
    boolean alive;
    int age;

    // Instantiate the game size variables
    int gameWidth;
    int gameHeight;

    // Instantiate blood splat variables
    PVector bloodPositionOne;
    PVector bloodPositionTwo;
    PVector bloodPositionThree;
    PVector bloodPositionFour;
    float bloodSizeOne;
    float bloodSizeTwo;
    float bloodSizeThree;
    float bloodSizeFour;

    // Constructor initialises all class variables
    Human(int size, PVector initialPosition, PVector velocity, int gameWidth, int gameHeight) {
        this.size = size;
        this.position = initialPosition;
        this.velocity = velocity;
        this.alive = true;
        this.age = 0;

        this.gameWidth = gameWidth;
        this.gameHeight = gameHeight;

        this.bloodPositionOne = new PVector(random(0, size * 2) - random(0, size * 2), random(0, size * 2) - random(0, size * 2));
        this.bloodPositionTwo = new PVector(random(0, size * 2) - random(0, size * 2), random(0, size * 2) - random(0, size * 2));
        this.bloodPositionThree = new PVector(random(0, size * 2) - random(0, size * 2), random(0, size * 2) - random(0, size * 2));
        this.bloodPositionFour = new PVector(random(0, size * 2) - random(0, size * 2), random(0, size * 2) - random(0, size * 2));
        this.bloodSizeOne = random(size / 2, size * 2);
        this.bloodSizeTwo = random(size / 2, size * 2);
        this.bloodSizeThree = random(size / 2, size * 2);
        this.bloodSizeFour = random(size / 2, size * 2);
    }

    // Draw the human in the right position with arms using a sine wave or draw blood
    void draw() {
        if (alive) {
            pushMatrix();
            translate(position.x, position.y);
            rotate(velocity.heading() + PI / 2);
            stroke(0);
            if (size >= 20) {
                strokeWeight(4);
            } else if (size >= 10) {
                strokeWeight(3);
            } else if (size >= 5) {
                strokeWeight(2);
            } else {
                strokeWeight(1);
            }
            // Maths function to draw swinging arms
            line(-(size/2)+1, 0, -(size/2), 2*(size/3)*sin(2*(PI/100)*age%100));
            line((size/2)-1, 0, (size/2), -2*(size/3)*sin(2*(PI/100)*age%100));
            noStroke();
            fill(254, 218, 167);
            ellipse(0, 0, size, size);
            popMatrix();
        } else {
            fill(255, 0, 0);
            ellipse(position.copy().x + bloodPositionOne.x, position.copy().y + bloodPositionOne.y, bloodSizeOne, bloodSizeOne);
            ellipse(position.copy().x + bloodPositionTwo.x, position.copy().y + bloodPositionTwo.y, bloodSizeTwo, bloodSizeTwo);
            ellipse(position.copy().x + bloodPositionThree.x, position.copy().y + bloodPositionThree.y, bloodSizeThree, bloodSizeThree);
            ellipse(position.copy().x + bloodPositionFour.x, position.copy().y + bloodPositionFour.y, bloodSizeFour, bloodSizeFour);
        }
    }

    // Update the velocity and position of the human
    void integrate() {
        if ((position.x <= 0) || (position.x >= gameWidth)) {
            velocity.x *= -1;
        }
        if ((position.y <= 0) || (position.y >= gameHeight)) {
            velocity.y *= -1;
        }
        if (alive) {
            position.add(velocity);
            age++;
        }
    }

    // Kill the human
    void kill() {
        alive = false;
    }
}