public class PoliceCar {

    // Instantiate police car mechanics
    int width;
    int height;
    int id;
    PVector position;
    float orientation;
    PVector velocity;
    PVector acceleration;
    float maxSpeed;
    float maxAccel;

    // Instantiate police car sprites
    PImage policeOne;
    PImage policeTwo;
    PImage policeThree;

    // Instantiate game size variables
    int gameWidth;
    int gameHeight;

    // Instantiate reference to playerCar
    PlayerCar playerCar;

    // Instantiate broken flag and animation offset
    boolean broken;
    float offset;

    // Constructor initialises all class variables
    PoliceCar(int width, int height, int id, PVector position, float orientation, float maxSpeed, float maxAccel, PlayerCar playerCar, int gameWidth, int gameHeight) {
        this.width = width;
        this.height = height;
        this.id = id;
        this.position = position;
        this.orientation = orientation;
        this.velocity = new PVector(0, 0);
        this.acceleration = new PVector(0, 0);
        this.maxSpeed = maxSpeed;
        this.maxAccel = maxAccel;

        this.policeOne = loadImage("./Sprites/PoliceCarOne.png");
        this.policeTwo = loadImage("./Sprites/PoliceCarTwo.png");
        this.policeThree = loadImage("./Sprites/PoliceCarThree.png");

        this.gameWidth = gameWidth;
        this.gameHeight = gameHeight;
        
        this.playerCar = playerCar;

        this.broken = false;
        this.offset = random(0, 90);
    }

    // Draw the police car at the right position with the correct orientation
    void draw() {
        pushMatrix();
        translate(position.x, position.y);
        rotate(orientation);
        rectMode(CENTER);
        imageMode(CENTER);
        if (broken) {
            fill(0, 0, 0);
            rect(0, 0, width, height);
        } else {
            if ((frameCount+offset)%90 < 30) {
                image(policeOne, 0, 0, width, height);
            } else if ((frameCount+offset)%90 < 60) {
                image(policeTwo, 0, 0, width, height);
            } else {
                image(policeThree, 0, 0, width, height);
            }
        }
        rectMode(CORNER);
        // Initial police car design
        // rect(0, 0, width, height);
        // fill(255, 0, 0);
        // triangle(-width/3, -height/3, -width/3, height/3, width/2, 0);
        // fill(255, 0, 0);
        // ellipse(-width/2, -height/2, 5, 5);
        // fill(0, 255, 0);
        // ellipse(-width/2, height/2, 5, 5);
        // fill(0, 0, 255);
        // ellipse(width/2, -height/2, 5, 5);
        // fill(255, 0, 255);
        // ellipse(width/2, height/2, 5, 5);
        // line(0, 0, width/2 + 20, 0);
        popMatrix();
    }

    // Update the police car's position, velocity, acceleration, and orientation if it is not broken
    void integrate() {
        if (!broken) {
            steeringPursue(playerCar.position, playerCar.velocity);
        }
    }

    // Attempt to intercept a target using steering algorithms from AI movement lectures
    void steeringPursue(PVector target, PVector targetSpeed) {
        PVector direction = new PVector(0, 0);
        direction.x = target.x - position.x;
        direction.y = target.y - position.y;

        float distance = direction.mag();
        float speed = velocity.mag();
        float prediction;
        if (speed != 0) {
            prediction = distance / speed;
        } else {
            prediction = distance;
        }

        PVector pursueTarget = targetSpeed.copy();
        pursueTarget.mult(prediction);
        pursueTarget.add(target);

        acceleration.x = pursueTarget.x - position.x;
        acceleration.y = pursueTarget.y - position.y;
        acceleration.normalize();
        acceleration.mult(maxAccel);

        velocity.add(acceleration);
        orientation = velocity.heading();
        if (velocity.mag() > maxSpeed) {
            velocity.normalize();
            velocity.mult(maxSpeed);
        }
        
        addVelocityToPosition(velocity);
    }

    // Kinematic movement algorithm to avoid humans and other police cars
    void kinematicFlee(PVector target) {
        PVector newVelocity = new PVector(0, 0);
        newVelocity.x = position.x - target.x;
        newVelocity.y = position.y - target.y;
        if (newVelocity.mag() > maxSpeed) {
            newVelocity.normalize();
            newVelocity.mult(maxSpeed/4);
        }
        addVelocityToPosition(newVelocity);
    }

    // Steering movement algorithm to avoid humans and other police cars
    void steeringFlee(PVector target) {
        PVector newAcceleration = new PVector(0, 0);
        newAcceleration.x = position.x - target.x;
        newAcceleration.y = position.y - target.y;
        if (newAcceleration.mag() > maxAccel) {
            newAcceleration.normalize();
            newAcceleration.mult(maxAccel);
        }
        PVector newVelocity = velocity.copy();
        newVelocity.add(newAcceleration);
        if (newVelocity.mag() > maxSpeed) {
            newVelocity.normalize();
            newVelocity.mult(maxSpeed);
        }
        addVelocityToPosition(newVelocity);
    }

    // Method to only add velocity to position when it is legal
    void addVelocityToPosition(PVector vel) {
        PVector newPosition = position.copy().add(vel);
        if ((newPosition.x > 0) && (newPosition.x < gameWidth)) {
            position.x = newPosition.x;
        }
        if ((newPosition.y > 0) && (newPosition.y < gameHeight)) {
            position.y = newPosition.y;
        }
    }

    // Set broken to true
    void collision() {
        broken = true;
    }

}