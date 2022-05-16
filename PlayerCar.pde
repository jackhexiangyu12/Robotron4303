public class PlayerCar {

    // Instantiate player car mechanics
    int width;
    int height;
    PVector position;
    float orientation;
    PVector velocity;
    PVector acceleration;
    float brakingPower;
    float maxSpeed;
    float maxAccel;
    float maxSteering;
    float friction;
    float frictionMultiplier;

    // Instantiate base player car values
    float baseMaxSpeed;
    float baseMaxAccel;
    float baseMaxSteering;
    float baseBrakingPower;
    float baseFriction;

    // Instantiate player car visuals
    int type; // 0 is minivan, 1 is ambulance, 2 is sports car, and 3 is f1 car
    PImage minivan;
    PImage ambulanceOne;
    PImage ambulanceTwo;
    PImage ambulanceThree;
    PImage sports;
    PImage f1;

    // Instantiate game size variables
    int gameWidth;
    int gameHeight;

    // Instantiate player car states
    boolean accelerating, braking, turningLeft, turningRight;
    int lives;

    // Instantiate player car power ups
    boolean boosting;
    int boostTimer;
    int maxBoostTimer;
    int boostCooldown;
    int boostCooldownTimer;
    boolean boostUsed;
    boolean pulsing;
    int pulseSize;
    int currentPulseSize;
    int pulseTimer;
    int maxPulseTimer;
    int pulseCooldown;
    int pulseCooldownTimer;
    boolean pulseUsed;

    // Constructor initialises all class variables
    PlayerCar(int width, int height, PVector position, float orientation, float brakingPower, float maxSpeed, float maxAccel, float maxSteering, float friction, float frictionMultiplier, int gameWidth, int gameHeight, int lives, int maxBoostTimer, int maxPulseTimer, int boostCooldown, int pulseSize, int pulseCooldown) {
        this.width = width;
        this.height = height;
        this.position = position;
        this.orientation = orientation;
        this.velocity = new PVector(0, 0);
        this.acceleration = new PVector(0, 0);
        this.brakingPower = brakingPower;
        this.maxSpeed = maxSpeed;
        this.maxAccel = maxAccel;
        this.maxSteering = maxSteering;
        this.friction = friction;
        this.frictionMultiplier = frictionMultiplier;

        this.baseMaxSpeed = maxSpeed;
        this.baseMaxAccel = maxAccel;
        this.baseMaxSteering = maxSteering;
        this.baseBrakingPower = brakingPower;
        this.baseFriction = friction;

        this.type = 0;
        this.minivan = loadImage("./Sprites/Minivan.png");
        this.ambulanceOne = loadImage("./Sprites/AmbulanceOne.png");
        this.ambulanceTwo = loadImage("./Sprites/AmbulanceTwo.png");
        this.ambulanceThree = loadImage("./Sprites/AmbulanceThree.png");
        this.sports = loadImage("./Sprites/SportsCar.png");
        this.f1 = loadImage("./Sprites/F1Car.png");

        this.gameWidth = gameWidth;
        this.gameHeight = gameHeight;

        this.accelerating = false;
        this.braking = false;
        this.turningLeft = false;
        this.turningRight = false;
        this.lives = lives;

        this.boosting = false;
        this.boostTimer = 0;
        this.maxBoostTimer = maxBoostTimer;
        this.boostCooldown = boostCooldown;
        this.boostCooldownTimer = 0;
        this.pulsing = false;
        this.pulseTimer = 0;
        this.maxPulseTimer = maxPulseTimer;
        this.pulseSize = pulseSize;
        this.currentPulseSize = 0;
        this.pulseCooldown = pulseCooldown;
        this.pulseCooldownTimer = 0;
    }

    // Draw the player car at the right position with the correct orientation
    void draw() {
        pushMatrix();
        translate(position.x, position.y);
        rotate(orientation);
        // Initial player car design
        // fill(0, 0, 0);
        // // fill(255, 0, 0);
        // ellipse(-width/2, -height/2, 5, 5);
        // // fill(0, 255, 0);
        // ellipse(-width/2, height/2, 5, 5);
        // // fill(0, 0, 255);
        // ellipse(width/2, -height/2, 5, 5);
        // // fill(255, 0, 255);
        // ellipse(width/2, height/2, 5, 5);
        // fill(255);
        // rectMode(CENTER);
        // rect(0, 0, width, height);
        // rectMode(CORNER);
        // fill(255, 0, 0);
        // triangle(-width/3, -height/3, -width/3, height/3, width/2, 0);
        // If pulsing, draw the pulse
        if (pulsing) {
            fill(0, 255, 255);
            if (pulseTimer < maxPulseTimer/2) {
                currentPulseSize = pulseSize * pulseTimer/(maxPulseTimer/2);
                ellipse(0, 0, currentPulseSize, currentPulseSize);
            } else {
                currentPulseSize = pulseSize * (maxPulseTimer - pulseTimer)/(maxPulseTimer/2);
                ellipse(0, 0, currentPulseSize, currentPulseSize);
            }
        }
        // Draw the correct player car sprite, if ambulance, animate it
        imageMode(CENTER);
        if (type == 0) {
            image(minivan, 0, 0, width, height);
        } else if (type == 1) {
            if (frameCount%90 < 30) {
                image(ambulanceOne, 0, 0, width, height);
            } else if (frameCount%90 < 60) {
                image(ambulanceTwo, 0, 0, width, height);
            } else {
                image(ambulanceThree, 0, 0, width, height);
            }
        } else if (type == 2) {
            image(sports, 0, 0, width, height);
        } else if (type == 3) {
            image(f1, 0, 0, width, height);
        }
        // Draw speed lines if boosting
        if (boosting) {
            stroke(255, 255, 0);
            strokeWeight(2);
            line(-(width/2) - 10, 0, -(width/2) - 30, 0);
            strokeWeight(1);
            line(-(width/2) - 10, -2*(height/5), -(width/2) - 20, -2*(height/5));
            line(-(width/2) - 10, 2*(height/5), -(width/2) - 20, 2*(height/5));
        }
        noStroke();
        popMatrix();
    }

    // Draws the player car at a specific position; used on car selection page
    void drawAt(int posX, int posY, int _width, int _height) {
        pushMatrix();
        translate(posX, posY);
        // fill(0, 0, 0);
        // ellipse(-width/2, -height/2, 5, 5);
        // ellipse(-width/2, height/2, 5, 5);
        // ellipse(width/2, -height/2, 5, 5);
        // ellipse(width/2, height/2, 5, 5);
        // fill(255);
        // rectMode(CENTER);
        // rect(0, 0, width, height);
        // rectMode(CORNER);
        // fill(255, 0, 0);
        // triangle(-width/3, -height/3, -width/3, height/3, width/2, 0);
        imageMode(CENTER);
        if (type == 0) {
            image(minivan, 0, 0, _width, _height);
        } else if (type == 1) {
            image(ambulanceTwo, 0, 0, _width, _height);
        } else if (type == 2) {
            image(sports, 0, 0, _width, _height);
        } else if (type == 3) {
            image(f1, 0, 0, _width, _height);
        }
        noStroke();
        popMatrix();
    }

    // Update the player car's position, velocity, acceleration, and orientation
    void integrate() {
        PVector newVelocity = PVector.add(velocity, acceleration);
        PVector newPosition = PVector.add(position, newVelocity);
        PVector newAcceleration = new PVector(0, 0);

        if (accelerating) {
            newAcceleration.add(PVector.fromAngle(orientation).mult(maxAccel));
        }
        if (braking) {
            newAcceleration = PVector.fromAngle(orientation).mult(-brakingPower * maxAccel);
        }
        if (turningLeft) {
            orientation -= maxSteering;
        }
        if (turningRight) {
            orientation += maxSteering;
        }
        if (orientation > PI) {
            orientation -= 2*PI;
        } else if (orientation < -PI) {
            orientation += 2*PI;
        }
        
        if (newVelocity.mag() > 0) {
            newVelocity.mult(getFriction());
            if (!boosting && (newVelocity.mag() > maxSpeed)) {
                newVelocity.normalize();
                newVelocity.mult(maxSpeed);
            } else if (newVelocity.mag() < 0.01) {
                newVelocity = new PVector(0, 0);
            }
        }

        velocity = newVelocity;
        acceleration = newAcceleration;

        // If boosting, boost the car forwards and increase boost timer
        if (boosting) {
            PVector boost = PVector.fromAngle(orientation).mult(maxAccel/2);
            acceleration.add(boost);
            velocity.add(acceleration);
            boostTimer++;
            if (boostTimer > maxBoostTimer) {
                boosting = false;
                boostTimer = 0;
            }
        }

        // If the boost has just been used, run cooldown timer
        if (boostUsed) {
            boostCooldownTimer++;
            if (boostCooldownTimer > boostCooldown) {
                boostUsed = false;
                boostCooldownTimer = 0;
            }
        }

        // If pulsing, increase pulse timer
        if (pulsing) {
            pulseTimer++;
            if (pulseTimer > maxPulseTimer) {
                pulseTimer = 0;
                pulsing = false;
            }
        }

        // If the pulse has just been used, run cooldown timer
        if (pulseUsed) {
            pulseCooldownTimer++;
            if (pulseCooldownTimer > pulseCooldown) {
                pulseUsed = false;
                pulseCooldownTimer = 0;
            }
        }

        // Only update the position if it wont put the car outside the screen
        if ((newPosition.x > 0) && (newPosition.x < gameWidth)) {
            position.x = newPosition.x;
        }
        if ((newPosition.y > 0) && (newPosition.y < gameHeight)) {
            position.y = newPosition.y;
        }
    }

    // Begin car boosting
    void boost() {
        if (!boosting && !boostUsed) {
            boosting = true;
            boostUsed = true;
        }
    }

    // Begin pulse
    void pulse() {
        if (!pulsing && !pulseUsed) {
            pulsing = true;
            pulseUsed = true;
        }
    }

    // Handle player car collision
    void collision() {
        lives--;
    }

    // Accelerate
    void accelerate() {
        accelerating = true;
    }

    // Stop accelerating
    void stopAccelerating() {
        accelerating = false;
    }

    // Brake
    void brake() {
        braking = true;
    }

    // Stop braking
    void stopBraking() {
        braking = false;
    }

    // Steer left
    void steerLeft() {
        turningLeft = true;
    }

    // Stop steering left
    void stopSteeringLeft() {
        turningLeft = false;
    }

    // Steer right
    void steerRight() {
        turningRight = true;
    }

    // Stop steering right
    void stopSteeringRight() {
        turningRight = false;
    }

    // Get the direction of momentum
    float getVelocityOrientation() {
        return velocity.heading();
    }

    // Calculate friction proportional to how close the car orientation is to perpendicular with the direction of momentum
    float getFriction() {
        float difference = Math.abs(orientation - getVelocityOrientation()) / PI;
        if (difference > 1) {
            difference -= 1;
        } else if (difference < -1) {
            difference += 1;
        }
        float ratio = 0.0;
        if (difference <= 0.5) {
            ratio = 2 * difference;
        } else {
            ratio = -2 * difference;
        }
        ratio = Math.abs(ratio);
        if (ratio > 1) {
            ratio = 1;
        }
        return (friction - (ratio * frictionMultiplier));
    }

    // Calculate the ratio of friction
    float getFrictionRatio() {
        float difference = Math.abs(orientation - getVelocityOrientation()) / PI;
        if (difference > 1) {
            difference -= 1;
        } else if (difference < -1) {
            difference += 1;
        }
        float ratio = 0.0;
        if (difference <= 0.5) {
            ratio = 2 * difference;
        } else {
            ratio = -2 * difference;
        }
        ratio = Math.abs(ratio);
        if (ratio > 1) {
            ratio = 1;
        }
        return ratio;
    }

    // Set new amount of lives
    void setLives(int newLives) {
        lives = newLives;
    }

    // Set car type and update stats
    void setType(int newType) {
        type = newType;
        updateCarStats();
    }

    // Update car performance stats
    void updateCarStats() {
        if (type == 0) {    // Minivan
            maxSpeed = baseMaxSpeed;
            maxAccel = baseMaxAccel;
            maxSteering = baseMaxSteering;
            brakingPower = baseBrakingPower;
            friction = baseFriction;
        } else if (type == 1) {     // Ambulance
            maxSpeed = 0.75f * baseMaxSpeed;
            maxAccel = 0.75f * baseMaxAccel;
            maxSteering = 0.75 * baseMaxSteering;
            brakingPower = 0.75f * baseBrakingPower;
            friction = baseFriction + 0.01f;
        } else if (type == 2) {     // Sports Car
            maxSpeed = 1.25f * baseMaxSpeed;
            maxAccel = 1.5f * baseMaxAccel;
            maxSteering = 1.25f * baseMaxSteering;
            brakingPower = 1.5f * baseBrakingPower;
            friction = baseFriction - 0.05f;
        } else if (type == 3) {     // F1 Car
            maxSpeed = 1.5f * baseMaxSpeed;
            maxAccel = 2f * baseMaxAccel;
            maxSteering = 1.5f * baseMaxSteering;
            brakingPower = 2f * baseBrakingPower;
            friction = baseFriction - 0.1f;
        }
    }
}