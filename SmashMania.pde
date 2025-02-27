import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

// Import the minim library for sound effects
import ddf.minim.*;

// Set the size of the window and databar
final int GAME_WIDTH = 800;
final int GAME_HEIGHT = 800;
final int DATABAR_HEIGHT = 50;
import processing.sound.*; //<>//
import java.util.ArrayList;

String path;

Boss boss;
int count, invisibleCount, forceCount, invincibleCount, score, level, deadCount, lives, clickReadyCount, livesRestored;
int gruntNum, hulkNum, humanNum, brainNum, obstacleNum, invisNum, invincibleNum, forceFieldNum;
boolean forceField, gameOver, clickReady;
PFont font, fontLarge;
SoundFile background, shoot, robotdie, spawn, nextlevel, humansave, start, endscreen, prog, powerup, die, bossLoop, humandie;

// Set player car parameters
int PLAYER_CAR_WIDTH = 30;
int PLAYER_CAR_HEIGHT = 15;
float PLAYER_CAR_BRAKING_POWER = 0.4f;
float PLAYER_CAR_MAX_SPEED = 3f;
float PLAYER_CAR_MAX_ACCELERATION = 0.2f;
float PLAYER_CAR_MAX_STEERING = PI / 64;
float PLAYER_CAR_FRICTION = 0.975f;
float PLAYER_CAR_FRICTION_MULTIPLIER = 0.02f;
int PLAYER_CAR_MAX_LIVES = 3;
int PLAYER_CAR_SAFE_ZONE = 150;

// Set police car parameters
int POLICE_CAR_WIDTH = 30;
int POLICE_CAR_HEIGHT = 15;
float POLICE_CAR_MAX_SPEED = 1f;
float POLICE_CAR_MAX_ACCELERATION = 0.1f;
float POLICE_CAR_VISION_RADIUS = 2 * POLICE_CAR_WIDTH;

// Set human parameters
int HUMAN_SIZE = 10;
float HUMAN_MAX_SPEED = 0.25f;
int HUMAN_SAFE_ZONE = 50;

// Set intial wave parameters
int INITIAL_HUMAN_COUNT = 10;
int INITIAL_POLICE_CAR_COUNT = 3;
float INITIAL_POLICE_CAR_MAX_SPEED = 1f;

// Set grass multipliers
float GRASS_MAX_SPEED_MULTIPLIER = 0.5f;
float GRASS_FRICTION_MULTIPLIER = 0.98f;

// Set item shop prices
int AMBULANCE_COST = 10000;
int SPORTS_CAR_COST = 12500;
int F1_CAR_COST = 15000;
int OFFROAD_TYRES_COST = 5000;
int BOOST_COST = 5000;
int PULSE_COST = 5000;
int AIR_STRIKE_COST = 5000;

// Set power up parameters
int MAX_BOOST_TIMER = 30;
int BOOST_COOLDOWN = 5*60;
int PULSE_SIZE = 100;
int MAX_PULSE_TIMER = 75;
int PULSE_COOLDOWN = 30*60;
int AIR_STRIKE_SIZE = 50;
int AIR_STRIKE_NUM_BOMBS = 5;
int AIR_STRIKE_MAX_BOMB_TIMER = 100;

// Set wave difficulty parameters
int HUMAN_COUNT_INCREMENT = 1;
int POLICE_CAR_WAVE_INCREMENT = 3;
float POLICE_CAR_SPEED_INCREMENT = 0.1f;

// Set map parameters
int MAP_RESOLUTION = 80;
int NUM_DECORATIONS = 10;
int DECORATION_SIZE = 1;
int DECORATION_OFFSET = 10;

// Instantiate number of humans and police cars
int numHumans;
int numPoliceCars;

// Instantiate the player car, police cars array list, and humans array lists
PlayerCar playerCar;
ArrayList<PoliceCar> policeCars;
ArrayList<Human> humans;
ArrayList<Human> homepageHumans;

// Instantiate sound effects objects
Minim minim;
AudioPlayer crashOne, crashTwo, wilhelm, minecraft, roblox, cashSpent, boost, pulse, explosion, waveComplete, gameOver, music;

// Instantiate car unlocks
boolean ambulanceUnlocked;
boolean sportsCarUnlocked;
boolean f1CarUnlocked;

// Instantiate power up icons
PImage offroadTyre;
PImage boostIcon;
PImage pulseIcon;
PImage airStrikes;

// Instantiate power up unlocks
boolean offroadTyresUnlocked;
boolean boostUnlocked;
boolean pulseUnlocked;
boolean airStrikeUnlocked;
AirStrike airStrike;

// Instantiate map and game state
Map map;
GameStates GameStates;

// Instantiate game variables
int wave;
int cash;
int cashEarned;
int highscore;
int highestWave;
boolean highestWaveAchieved;

// Instantiate stats variables
int totalGamesPlayed;
int totalWavesCleared;
int totalCashEarned;
int totalCashSpent;
int totalHumansKilled;
int totalPoliceCarsEliminated;

// Instantiate collision detection utils and quad tree objects
CollisionDetectionUtils utils = new CollisionDetectionUtils();
QuadTree quadTree;
BoundingBox root;
int quadTreeCapacity;
ArrayList<Point> mapQuadTreePoints;
boolean showQuadTree;

// Instantiate wave variables
boolean waveStarted;
int waveStartCountdown;
int humansKilled;

// Instantiate dev tools and mute toggles
boolean devToolsOn;
boolean muted;

// Set window size
void settings() {
    size(GAME_WIDTH, GAME_HEIGHT+DATABAR_HEIGHT);
}

// Initialise all game variables
void setup() {
    frameRate(50);
    clickReadyCount = 0;
    grunts = new ArrayList<Grunt>();
    bullets = new ArrayList<Bullet>();
    humans = new ArrayList<Human>();
    hulks = new ArrayList<Hulk>();
    brains = new ArrayList<Brain>();
    progs = new ArrayList<Prog>();
    obstacles = new ArrayList<Obstacle>();
    powerups = new ArrayList<PowerUp>();
    boss = null;
    map = new Map(true);
    clickReady = false;
    gruntNum = 5;
    hulkNum = 3;
    humanNum = 3;
    lives = 3;
    brainNum = 0;
    obstacleNum = 6;
    forceFieldNum = 1;
    invisNum = 0;
    invincibleNum = 0;
    setupSound();
    spawn(gruntNum, humanNum, hulkNum, brainNum, obstacleNum, invincibleNum, forceFieldNum, invisNum);
    count = 0;
    level = 1;
    score = 0;
    livesRestored = 0;
    gameOver = false;
    // Set framerate
    frameRate(60);

    // Initialise quad tree
    root = new BoundingBox(new PVector(0, 0), width, height);
    quadTreeCapacity = 4;
    quadTree = new QuadTree(root, quadTreeCapacity);
    showQuadTree = false;

    // Initialise map
    map = new Map(GAME_WIDTH, GAME_HEIGHT, MAP_RESOLUTION, NUM_DECORATIONS, DECORATION_SIZE, DECORATION_OFFSET);
    map.generate();

    // Initialise game state
    GameStates = new GameStates();

    // Initialise dev tools and mute toggle
    devToolsOn = false;
    muted = false;

    // Initialise wave, cash, and highscore
    wave = 1;
    cash = 0;
    cashEarned = 0;
    highscore = 0;
    highestWave = 1;
    highestWaveAchieved = false;

    // Initialise stats
    totalGamesPlayed = 0;
    totalWavesCleared = 0;
    totalCashEarned = 0;
    totalCashSpent = 0;
    totalHumansKilled = 0;
    totalPoliceCarsEliminated = 0;

    // Initialise wave start countdown and humans killed
    waveStarted = false;
    waveStartCountdown = (60 * 3)-20;
    humansKilled = 0;

    // Initialise number of humans and police cars
    numHumans = INITIAL_HUMAN_COUNT;
    numPoliceCars = INITIAL_POLICE_CAR_COUNT;

    // Initialise sprites
    offroadTyre = loadImage("./Sprites/OffRoadTyre.png");
    boostIcon = loadImage("./Sprites/Boost.png");
    pulseIcon = loadImage("./Sprites/Pulse.png");
    airStrikes = loadImage("./Sprites/AirStrike.png");

    // Initialise sounds
    minim = new Minim(this);
    crashOne = minim.loadFile("./Sounds/CrashOne.wav");
    crashTwo = minim.loadFile("./Sounds/CrashTwo.wav");
    wilhelm = minim.loadFile("./Sounds/WilhelmScream.wav");
    minecraft = minim.loadFile("./Sounds/MinecraftOof.wav");
    roblox = minim.loadFile("./Sounds/RobloxOof.wav");
    cashSpent = minim.loadFile("./Sounds/CashSpent.wav");
    boost = minim.loadFile("./Sounds/Boost.wav");
    pulse = minim.loadFile("./Sounds/Pulse.wav");
    explosion = minim.loadFile("./Sounds/Explosion.wav");
    waveComplete = minim.loadFile("./Sounds/WaveComplete.wav");
    gameOver = minim.loadFile("./Sounds/GameOver.wav");
    music = minim.loadFile("./Sounds/Music.wav");
    music.loop();
    
    // Initialise unlocks
    ambulanceUnlocked = false;
    sportsCarUnlocked = false;
    f1CarUnlocked = false;
    offroadTyresUnlocked = false;
    boostUnlocked = false;
    pulseUnlocked = false;
    airStrikeUnlocked = false;
    airStrike = new AirStrike(AIR_STRIKE_SIZE, AIR_STRIKE_NUM_BOMBS, AIR_STRIKE_MAX_BOMB_TIMER);

    // Initialise player car
    PVector initialPlayerCarPosition = new PVector(random(50, GAME_WIDTH-50), random(50, GAME_HEIGHT-50));
    PVector nwCorner = new PVector(0, 0);
    PVector neCorner = new PVector(GAME_WIDTH, 0);
    PVector swCorner = new PVector(0, GAME_HEIGHT);
    PVector seCorner = new PVector(GAME_WIDTH, GAME_HEIGHT);
    // Start player car facing away from nearest corner
    PVector nearestCornerToPlayerCar = new PVector(GAME_WIDTH/2, GAME_HEIGHT/2);
    float nearestCornerToPlayerCarDistance = Float.MAX_VALUE;
    if (initialPlayerCarPosition.copy().sub(nwCorner).mag() < nearestCornerToPlayerCarDistance) {
        nearestCornerToPlayerCar = nwCorner;
        nearestCornerToPlayerCarDistance = initialPlayerCarPosition.copy().sub(nwCorner).mag();
    }
    if (initialPlayerCarPosition.copy().sub(neCorner).mag() < nearestCornerToPlayerCarDistance) {
        nearestCornerToPlayerCar = neCorner;
        nearestCornerToPlayerCarDistance = initialPlayerCarPosition.copy().sub(neCorner).mag();
    }
    if (initialPlayerCarPosition.copy().sub(swCorner).mag() < nearestCornerToPlayerCarDistance) {
        nearestCornerToPlayerCar = swCorner;
        nearestCornerToPlayerCarDistance = initialPlayerCarPosition.copy().sub(swCorner).mag();
    }
    if (initialPlayerCarPosition.copy().sub(seCorner).mag() < nearestCornerToPlayerCarDistance) {
        nearestCornerToPlayerCar = seCorner;
        nearestCornerToPlayerCarDistance = initialPlayerCarPosition.copy().sub(seCorner).mag();
    }
    PVector directionToNearestCornerFromPlayerCar = initialPlayerCarPosition.copy().sub(nearestCornerToPlayerCar);
    float initialPlayerCarOrientation = directionToNearestCornerFromPlayerCar.heading();
    playerCar = new PlayerCar(PLAYER_CAR_WIDTH, PLAYER_CAR_HEIGHT, initialPlayerCarPosition, initialPlayerCarOrientation, PLAYER_CAR_BRAKING_POWER, PLAYER_CAR_MAX_SPEED, PLAYER_CAR_MAX_ACCELERATION, PLAYER_CAR_MAX_STEERING, PLAYER_CAR_FRICTION, PLAYER_CAR_FRICTION_MULTIPLIER, GAME_WIDTH, GAME_HEIGHT, PLAYER_CAR_MAX_LIVES, MAX_BOOST_TIMER, MAX_PULSE_TIMER, BOOST_COOLDOWN, PULSE_SIZE, PULSE_COOLDOWN);

    // Initialise police cars
    policeCars = new ArrayList<PoliceCar>();
    // Do not allow police cars to spawn right next to player car or another police car
    for (int i = 0; i < numPoliceCars; i++) {
        PVector initialPoliceCarPosition = new PVector(random(50, GAME_WIDTH-50), random(50, GAME_HEIGHT-50));
        PVector closestPoliceCar = new PVector(0, 0);
        float closestPoliceCarDistance = Float.MAX_VALUE;
        for (PoliceCar policeCar : policeCars) {
            float distance = initialPoliceCarPosition.copy().sub(policeCar.position).mag();
            if ((distance != 0.0) && (distance < closestPoliceCarDistance)) {
                closestPoliceCar = policeCar.position.copy();
                closestPoliceCarDistance = distance;
            }
        }
        while ((initialPoliceCarPosition.copy().sub(initialPlayerCarPosition).mag() < PLAYER_CAR_SAFE_ZONE) || (initialPoliceCarPosition.copy().sub(closestPoliceCar).mag() < POLICE_CAR_VISION_RADIUS)) {
            initialPoliceCarPosition = new PVector(random(50, GAME_WIDTH-50), random(50, GAME_HEIGHT-50));
            for (PoliceCar policeCar : policeCars) {
                float distance = initialPoliceCarPosition.copy().sub(policeCar.position).mag();
                if ((distance != 0.0) && (distance < closestPoliceCarDistance)) {
                    closestPoliceCar = policeCar.position.copy();
                    closestPoliceCarDistance = distance;
                }
            }
        }
        float initialPoliceCarOrientation = initialPlayerCarPosition.copy().sub(initialPoliceCarPosition).heading();
        PoliceCar newPoliceCar = new PoliceCar(POLICE_CAR_WIDTH, POLICE_CAR_HEIGHT, i, initialPoliceCarPosition, initialPoliceCarOrientation, POLICE_CAR_MAX_SPEED, POLICE_CAR_MAX_ACCELERATION, playerCar, GAME_WIDTH, GAME_HEIGHT);
        policeCars.add(newPoliceCar);
    }

    // Initialise humans
    humans = new ArrayList<Human>();
    // Do not allow humans to spawn right next to a police car or another human
    for (int i = 0; i < numHumans; i++) {
        PVector initialHumanPosition = new PVector(random(50, GAME_WIDTH-50), random(50, GAME_HEIGHT-50));
        PVector closestPoliceCar = new PVector(0, 0);
        float closestPoliceCarDistance = Float.MAX_VALUE;
        for (PoliceCar policeCar : policeCars) {
            float distance = initialHumanPosition.copy().sub(policeCar.position).mag();
            if (distance < closestPoliceCarDistance) {
                closestPoliceCar = policeCar.position.copy();
                closestPoliceCarDistance = distance;
            }
        }
        PVector closestOtherHuman = new PVector(0, 0);
        float closestOtherHumanDistance = Float.MAX_VALUE;
        for (Human human : humans) {
            float distance = initialHumanPosition.copy().sub(human.position).mag();
            if ((distance != 0.0) && (distance < closestOtherHumanDistance)) {
                closestOtherHuman = human.position.copy();
                closestOtherHumanDistance = distance;
            }
        }
        while ((initialHumanPosition.copy().sub(initialPlayerCarPosition).mag() < HUMAN_SAFE_ZONE) || (initialHumanPosition.copy().sub(closestPoliceCar).mag() < HUMAN_SAFE_ZONE) || (initialHumanPosition.copy().sub(closestOtherHuman).mag() < HUMAN_SAFE_ZONE) || (initialHumanPosition.copy().sub(closestOtherHuman).mag() < HUMAN_SAFE_ZONE)) {
            initialHumanPosition = new PVector(random(50, GAME_WIDTH-50), random(50, GAME_HEIGHT-50));
            for (PoliceCar policeCar : policeCars) {
                float distance = initialHumanPosition.copy().sub(policeCar.position).mag();
                if (distance < closestPoliceCarDistance) {
                    closestPoliceCar = policeCar.position.copy();
                    closestPoliceCarDistance = distance;
                }
            }
            for (Human human : humans) {
                float distance = initialHumanPosition.copy().sub(human.position).mag();
                if ((distance != 0.0) && (distance < closestOtherHumanDistance)) {
                    closestOtherHuman = human.position.copy();
                    closestOtherHumanDistance = distance;
                }
            }
        }
        Human newHuman = new Human(HUMAN_SIZE, initialHumanPosition, new PVector(random(-HUMAN_MAX_SPEED, HUMAN_MAX_SPEED), random(-HUMAN_MAX_SPEED, HUMAN_MAX_SPEED)), GAME_WIDTH, GAME_HEIGHT);
        humans.add(newHuman);
    }

    // Initialise homepage humans
    homepageHumans = new ArrayList<Human>();
    for (int i = 0; i < 10; i++) {
        PVector initialHumanPosition = new PVector(random(50, GAME_WIDTH-50), random(50, GAME_HEIGHT-50));
        homepageHumans.add(new Human(2*HUMAN_SIZE, initialHumanPosition, new PVector(random(-HUMAN_MAX_SPEED, HUMAN_MAX_SPEED), random(-HUMAN_MAX_SPEED, HUMAN_MAX_SPEED)), GAME_WIDTH, GAME_HEIGHT));
    }
}

// Switch to draw the correct game state
void draw() {
    textAlign(CENTER, CENTER);
    switch (GameStates.phase) {
        case 0: // Homepage
            drawHomepage();
            drawCrosshairs();
            break;
        case 1: // Guide
            drawGuide();
            if (devToolsOn) {
                drawDevTools();
            }
            drawCrosshairs();
            break;
        case 2: // CarSelect
            drawCarSelect();
            if (devToolsOn) {
                drawDevTools();
            }
            drawCrosshairs();
            break;
        case 3: // ItemShop
            drawItemShop();
            if (devToolsOn) {
                drawDevTools();
            }
            drawCrosshairs();
            break;
        case 4: // PreWave
            drawPreWave();
            if (devToolsOn) {
                drawDevTools();
            }
            drawCrosshairs();
            break;
        case 5: // Wave
            drawWave();
            if (devToolsOn) {
                drawDevTools();
            }
            drawCrosshairs();
            break;
        case 6: // PostWave
            drawPostWave();
            if (devToolsOn) {
                drawDevTools();
            }
            drawCrosshairs();
            break;
        case 7: // Paused
            drawPaused();
            if (devToolsOn) {
                drawDevTools();
            }
            drawCrosshairs();
            break;
        case 8: // GameOver
            drawGameOver();
            drawCrosshairs();
            break;
        case 9: // ItemGuide
            drawItemGuide();
            if (devToolsOn) {
                drawDevTools();
            }
            drawCrosshairs();
            break;
        case 10: // Stats
            drawStats();
            if (devToolsOn) {
                drawDevTools();
            }
            drawCrosshairs();
            break;
    }
}

// Draw the home page
void drawHomepage() {
    background(255, 255, 255);
     //map.draw();
    //for (Human human : homepageHumans) {
    //    human.draw();
    //    human.integrate();
    //}
    textSize(60);
    fill(0, 0, 0);
    text("Welcome to Robotron4303!", GAME_WIDTH/2, GAME_HEIGHT/3);
    if (highscore != 0) {
        textSize(30);
        text("High Score: £" + highscore, GAME_WIDTH/2, GAME_HEIGHT/2);
    }
    if (highestWave > 1) {
        textSize(30);
        text("Highest Wave: " + highestWave, GAME_WIDTH/2, GAME_HEIGHT/2 + 50);
    }
    rect(0, GAME_HEIGHT, GAME_WIDTH, DATABAR_HEIGHT);
    rect(0, 0, 3*DATABAR_HEIGHT, DATABAR_HEIGHT);
    rect(GAME_WIDTH-(3*DATABAR_HEIGHT), 0, 3*DATABAR_HEIGHT, DATABAR_HEIGHT);
    rect((GAME_WIDTH/2)-(1.5*DATABAR_HEIGHT), 0, 3*DATABAR_HEIGHT, DATABAR_HEIGHT);
    fill(255, 255, 255);
    textSize(25);
    stroke(255, 255, 255);
    strokeWeight(1);
    line(0, GAME_HEIGHT, GAME_WIDTH, GAME_HEIGHT);
    line(GAME_WIDTH/3, GAME_HEIGHT, GAME_WIDTH/3, GAME_HEIGHT + DATABAR_HEIGHT);
    line(2*GAME_WIDTH/3, GAME_HEIGHT, 2*GAME_WIDTH/3, GAME_HEIGHT + DATABAR_HEIGHT);
    line(0, DATABAR_HEIGHT, 3*DATABAR_HEIGHT, DATABAR_HEIGHT);
    line(3*DATABAR_HEIGHT, 0, 3*DATABAR_HEIGHT, DATABAR_HEIGHT);
    line(GAME_WIDTH-(3*DATABAR_HEIGHT), 0, GAME_WIDTH-(3*DATABAR_HEIGHT), DATABAR_HEIGHT);
    line(GAME_WIDTH, DATABAR_HEIGHT, GAME_WIDTH-(3*DATABAR_HEIGHT), DATABAR_HEIGHT);

    line((GAME_WIDTH/2)-(1.5*DATABAR_HEIGHT), 0, (GAME_WIDTH/2)-(1.5*DATABAR_HEIGHT), DATABAR_HEIGHT);
    line((GAME_WIDTH/2)+(1.5*DATABAR_HEIGHT), 0, (GAME_WIDTH/2)+(1.5*DATABAR_HEIGHT), DATABAR_HEIGHT);
    line((GAME_WIDTH/2)-(1.5*DATABAR_HEIGHT), DATABAR_HEIGHT, (GAME_WIDTH/2)+(1.5*DATABAR_HEIGHT), DATABAR_HEIGHT);
    noStroke();
    text("Start", GAME_WIDTH/6, GAME_HEIGHT + 2*(DATABAR_HEIGHT/5));
    text("Guide", GAME_WIDTH/2, GAME_HEIGHT + 2*(DATABAR_HEIGHT/5));
    text("Car Select", 5*GAME_WIDTH/6, GAME_HEIGHT + 2*(DATABAR_HEIGHT/5));
    text("Stats", 1.5*DATABAR_HEIGHT, 2*DATABAR_HEIGHT/5);
    if (devToolsOn) {
        text("Dev Tools On", GAME_WIDTH-(1.5*DATABAR_HEIGHT), 2*DATABAR_HEIGHT/5);
    } else {
        text("Dev Tools Off", GAME_WIDTH-(1.5*DATABAR_HEIGHT), 2*DATABAR_HEIGHT/5);
    }
    if (muted) {
        text("Sound Off", GAME_WIDTH/2, 2*DATABAR_HEIGHT/5);
    } else {
        text("Sound On", GAME_WIDTH/2, 2*DATABAR_HEIGHT/5);
    }
}

// Draw the guide page
void drawGuide() {
    background(0, 152, 0);
    // map.draw();
    for (Human human : homepageHumans) {
        human.draw();
        human.integrate();
    }
    textSize(50);
    fill(0, 0, 0);
    text("Guide", GAME_WIDTH/2, GAME_HEIGHT/5);
    textSize(25);
    text("Use the W, A, S, D keys to drive.", GAME_WIDTH/2, GAME_HEIGHT/2 - 70);
    text("Earn cash by running over the walking civilians.", GAME_WIDTH/2, GAME_HEIGHT/2 - 10);
    text("Avoid getting hit by the police cars.", GAME_WIDTH/2, GAME_HEIGHT/2 + 50);
    text("Run over all humans in wave to continue.", GAME_WIDTH/2, GAME_HEIGHT/2 + 110);
    text("Press SPACE to boost.", GAME_WIDTH/2, GAME_HEIGHT/2 + 170);
    text("Press Q during a wave to pause.", GAME_WIDTH/2, GAME_HEIGHT/2 + 230);
    rect(0, GAME_HEIGHT, GAME_WIDTH, DATABAR_HEIGHT);
    stroke(255, 255, 255);
    strokeWeight(1);
    line(0, GAME_HEIGHT, GAME_WIDTH, GAME_HEIGHT);
    noStroke();
    fill(255, 255, 255);
    text("Back", GAME_WIDTH/2, GAME_HEIGHT + 2*(DATABAR_HEIGHT/5));
}

// Draw the car selection page
void drawCarSelect() {
    background(0, 152, 0);
    // map.draw();
    for (Human human : homepageHumans) {
        human.draw();
        human.integrate();
    }
    textSize(50);
    fill(0, 0, 0);
    text("Car Select", GAME_WIDTH/2, GAME_HEIGHT/5);
    rectMode(CENTER);

    rect(GAME_WIDTH/2, GAME_HEIGHT/2, 2.5*PLAYER_CAR_WIDTH, 2.5*PLAYER_CAR_WIDTH);
    fill(0, 152, 0);
    rect(GAME_WIDTH/2, GAME_HEIGHT/2, 2.25*PLAYER_CAR_WIDTH, 2.25*PLAYER_CAR_WIDTH);
    playerCar.drawAt(GAME_WIDTH/2, GAME_HEIGHT/2, 2*PLAYER_CAR_WIDTH, 2*PLAYER_CAR_HEIGHT);

    fill(0, 0, 0);
    rect(GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2.5*PLAYER_CAR_WIDTH, 2.5*PLAYER_CAR_WIDTH);
    fill(0, 152, 0);
    rect(GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2.25*PLAYER_CAR_WIDTH, 2.25*PLAYER_CAR_WIDTH);
    image(playerCar.minivan, GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2*PLAYER_CAR_WIDTH, 2*PLAYER_CAR_HEIGHT);

    fill(0, 0, 0);
    rect(2*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2.5*PLAYER_CAR_WIDTH, 2.5*PLAYER_CAR_WIDTH);
    fill(0, 152, 0);
    rect(2*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2.25*PLAYER_CAR_WIDTH, 2.25*PLAYER_CAR_WIDTH);
    image(playerCar.ambulanceTwo, 2*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2*PLAYER_CAR_WIDTH, 2*PLAYER_CAR_HEIGHT);
    if (!ambulanceUnlocked) {
        drawLock(2*GAME_WIDTH/5, 5+4*GAME_HEIGHT/5, PLAYER_CAR_WIDTH);
    }

    fill(0, 0, 0);
    rect(3*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2.5*PLAYER_CAR_WIDTH, 2.5*PLAYER_CAR_WIDTH);
    fill(0, 152, 0);
    rect(3*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2.25*PLAYER_CAR_WIDTH, 2.25*PLAYER_CAR_WIDTH);
    image(playerCar.sports, 3*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2*PLAYER_CAR_WIDTH, 2*PLAYER_CAR_HEIGHT);
    if (!sportsCarUnlocked) {
        drawLock(3*GAME_WIDTH/5, 5+4*GAME_HEIGHT/5, PLAYER_CAR_WIDTH);
    }

    fill(0, 0, 0);
    rect(4*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2.5*PLAYER_CAR_WIDTH, 2.5*PLAYER_CAR_WIDTH);
    fill(0, 152, 0);
    rect(4*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2.25*PLAYER_CAR_WIDTH, 2.25*PLAYER_CAR_WIDTH);
    image(playerCar.f1, 4*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2*PLAYER_CAR_WIDTH, 2*PLAYER_CAR_HEIGHT);
    if (!f1CarUnlocked) {
        drawLock(4*GAME_WIDTH/5, 5+4*GAME_HEIGHT/5, PLAYER_CAR_WIDTH);
    }

    rectMode(CORNER);
    fill(0, 0, 0);
    rect(0, GAME_HEIGHT, GAME_WIDTH, DATABAR_HEIGHT);
    stroke(255, 255, 255);
    strokeWeight(1);
    line(0, GAME_HEIGHT, GAME_WIDTH, GAME_HEIGHT);
    noStroke();
    textSize(25);
    fill(255, 255, 255);
    text("Back", GAME_WIDTH/2, GAME_HEIGHT + 2*(DATABAR_HEIGHT/5));
}

// Draw the item shop
void drawItemShop() {
    background(0, 152, 0);
    // map.draw();
    for (Human human : homepageHumans) {
        human.draw();
        human.integrate();
    }
    textSize(50);
    fill(0, 0, 0);
    text("Item Shop", GAME_WIDTH/2, GAME_HEIGHT/5);
    rectMode(CENTER);
    imageMode(CENTER);
    textSize(25);

    fill(0, 0, 0);
    rect(GAME_WIDTH/4, GAME_HEIGHT/2, 2.5*PLAYER_CAR_WIDTH, 2.5*PLAYER_CAR_WIDTH);
    fill(0, 152, 0);
    rect(GAME_WIDTH/4, GAME_HEIGHT/2, 2.25*PLAYER_CAR_WIDTH, 2.25*PLAYER_CAR_WIDTH);
    image(playerCar.ambulanceTwo, GAME_WIDTH/4, GAME_HEIGHT/2, 2*PLAYER_CAR_WIDTH, 2*PLAYER_CAR_HEIGHT);
    fill(0, 0, 0);
    if (!ambulanceUnlocked) {
        drawLock(GAME_WIDTH/4, 5+GAME_HEIGHT/2, PLAYER_CAR_WIDTH);
        text("£" + formatNumber(AMBULANCE_COST), GAME_WIDTH/4, GAME_HEIGHT/2 + 2*PLAYER_CAR_WIDTH);
    }
    text("Ambulance", GAME_WIDTH/4, GAME_HEIGHT/2 - 2*PLAYER_CAR_WIDTH);

    fill(0, 0, 0);
    rect(2*GAME_WIDTH/4, GAME_HEIGHT/2, 2.5*PLAYER_CAR_WIDTH, 2.5*PLAYER_CAR_WIDTH);
    fill(0, 152, 0);
    rect(2*GAME_WIDTH/4, GAME_HEIGHT/2, 2.25*PLAYER_CAR_WIDTH, 2.25*PLAYER_CAR_WIDTH);
    image(playerCar.sports, 2*GAME_WIDTH/4, GAME_HEIGHT/2, 2*PLAYER_CAR_WIDTH, 2*PLAYER_CAR_HEIGHT);
    fill(0, 0, 0);
    if (!sportsCarUnlocked) {
        drawLock(2*GAME_WIDTH/4, 5+GAME_HEIGHT/2, PLAYER_CAR_WIDTH);
        text("£" + formatNumber(SPORTS_CAR_COST), 2*GAME_WIDTH/4, GAME_HEIGHT/2 + 2*PLAYER_CAR_WIDTH);
    }
    text("Sports Car", 2*GAME_WIDTH/4, GAME_HEIGHT/2 - 2*PLAYER_CAR_WIDTH);

    fill(0, 0, 0);
    rect(3*GAME_WIDTH/4, GAME_HEIGHT/2, 2.5*PLAYER_CAR_WIDTH, 2.5*PLAYER_CAR_WIDTH);
    fill(0, 152, 0);
    rect(3*GAME_WIDTH/4, GAME_HEIGHT/2, 2.25*PLAYER_CAR_WIDTH, 2.25*PLAYER_CAR_WIDTH);
    image(playerCar.f1, 3*GAME_WIDTH/4, GAME_HEIGHT/2, 2*PLAYER_CAR_WIDTH, 2*PLAYER_CAR_HEIGHT);
    fill(0, 0, 0);
    if (!f1CarUnlocked) {
        drawLock(3*GAME_WIDTH/4, 5+GAME_HEIGHT/2, PLAYER_CAR_WIDTH);
        text("£" + formatNumber(F1_CAR_COST), 3*GAME_WIDTH/4, GAME_HEIGHT/2 + 2*PLAYER_CAR_WIDTH);
    }
    text("F1 Car", 3*GAME_WIDTH/4, GAME_HEIGHT/2 - 2*PLAYER_CAR_WIDTH);

    fill(0, 0, 0);
    rect(GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2.5*PLAYER_CAR_WIDTH, 2.5*PLAYER_CAR_WIDTH);
    fill(0, 152, 0);
    rect(GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2.25*PLAYER_CAR_WIDTH, 2.25*PLAYER_CAR_WIDTH);
    image(offroadTyre, GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2*PLAYER_CAR_WIDTH, 2*PLAYER_CAR_WIDTH);
    fill(0, 0, 0);
    if (!offroadTyresUnlocked) {
        drawLock(GAME_WIDTH/5, 5+4*GAME_HEIGHT/5, PLAYER_CAR_WIDTH);
        text("£" + formatNumber(OFFROAD_TYRES_COST), GAME_WIDTH/5, 4*GAME_HEIGHT/5 + 2*PLAYER_CAR_WIDTH);
    }
    text("Offroad Tyres", GAME_WIDTH/5, 4*GAME_HEIGHT/5 - 2*PLAYER_CAR_WIDTH);

    fill(0, 0, 0);
    rect(2*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2.5*PLAYER_CAR_WIDTH, 2.5*PLAYER_CAR_WIDTH);
    fill(0, 152, 0);
    rect(2*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2.25*PLAYER_CAR_WIDTH, 2.25*PLAYER_CAR_WIDTH);
    image(boostIcon, 2*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2*PLAYER_CAR_WIDTH, 2*PLAYER_CAR_WIDTH);
    fill(0, 0, 0);
    if (!boostUnlocked) {
        drawLock(2*GAME_WIDTH/5, 5+4*GAME_HEIGHT/5, PLAYER_CAR_WIDTH);
        text("£" + formatNumber(BOOST_COST), 2*GAME_WIDTH/5, 4*GAME_HEIGHT/5 + 2*PLAYER_CAR_WIDTH);
    }
    text("Boost", 2*GAME_WIDTH/5, 4*GAME_HEIGHT/5 - 2*PLAYER_CAR_WIDTH);

    fill(0, 0, 0);
    rect(3*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2.5*PLAYER_CAR_WIDTH, 2.5*PLAYER_CAR_WIDTH);
    fill(0, 152, 0);
    rect(3*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2.25*PLAYER_CAR_WIDTH, 2.25*PLAYER_CAR_WIDTH);
    image(pulseIcon, 3*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2*PLAYER_CAR_WIDTH, 2*PLAYER_CAR_WIDTH);
    fill(0, 0, 0);
    if (!pulseUnlocked) {
        drawLock(3*GAME_WIDTH/5, 5+4*GAME_HEIGHT/5, PLAYER_CAR_WIDTH);
        text("£" + formatNumber(PULSE_COST), 3*GAME_WIDTH/5, 4*GAME_HEIGHT/5 + 2*PLAYER_CAR_WIDTH);
    }
    text("Pulse", 3*GAME_WIDTH/5, 4*GAME_HEIGHT/5 - 2*PLAYER_CAR_WIDTH);

    fill(0, 0, 0);
    rect(4*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2.5*PLAYER_CAR_WIDTH, 2.5*PLAYER_CAR_WIDTH);
    fill(0, 152, 0);
    rect(4*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2.25*PLAYER_CAR_WIDTH, 2.25*PLAYER_CAR_WIDTH);
    image(airStrikes, 4*GAME_WIDTH/5, 4*GAME_HEIGHT/5, 2*PLAYER_CAR_WIDTH, 2*PLAYER_CAR_WIDTH);
    fill(0, 0, 0);
    if (!airStrikeUnlocked) {
        drawLock(4*GAME_WIDTH/5, 5+4*GAME_HEIGHT/5, PLAYER_CAR_WIDTH);
        text("£" + formatNumber(AIR_STRIKE_COST), 4*GAME_WIDTH/5, 4*GAME_HEIGHT/5 + 2*PLAYER_CAR_WIDTH);
    }
    text("Air Strike", 4*GAME_WIDTH/5, 4*GAME_HEIGHT/5 - 2*PLAYER_CAR_WIDTH);
    
    rectMode(CORNER);
    fill(0, 0, 0);
    rect(0, GAME_HEIGHT, GAME_WIDTH, DATABAR_HEIGHT);
    stroke(255, 255, 255);
    strokeWeight(1);
    line(0, GAME_HEIGHT, GAME_WIDTH, GAME_HEIGHT);
    line(GAME_WIDTH/3, GAME_HEIGHT, GAME_WIDTH/3, GAME_HEIGHT + DATABAR_HEIGHT);
    line(2*GAME_WIDTH/3, GAME_HEIGHT, 2*GAME_WIDTH/3, GAME_HEIGHT + DATABAR_HEIGHT);
    noStroke();
    textSize(25);
    text("Cash: £" + cash, GAME_WIDTH/2, 1.5*GAME_HEIGHT/5);
    fill(255, 255, 255);
    text("Car Select", GAME_WIDTH/6, GAME_HEIGHT + 2*(DATABAR_HEIGHT/5));
    text("Item Guide", 3*GAME_WIDTH/6, GAME_HEIGHT + 2*(DATABAR_HEIGHT/5));
    text("Back", 5*GAME_WIDTH/6, GAME_HEIGHT + 2*(DATABAR_HEIGHT/5));
}

// Draw the prewave page
void drawPreWave() {
    background(0, 152, 0);
    // map.draw();
    for (Human human : homepageHumans) {
        human.draw();
        human.integrate();
    }
    textSize(50);
    fill(0, 0, 0);
    text("Wave " + wave, GAME_WIDTH/2, GAME_HEIGHT/5);
    textSize(25);
    text("Cash: £" + cash, GAME_WIDTH/2, GAME_HEIGHT/2);
    text("Lives left: " + playerCar.lives, GAME_WIDTH/2, GAME_HEIGHT/2 + 50);
    rect(0, GAME_HEIGHT, GAME_WIDTH, DATABAR_HEIGHT);
    stroke(255, 255, 255);
    strokeWeight(1);
    line(0, GAME_HEIGHT, GAME_WIDTH, GAME_HEIGHT);
    noStroke();
    fill(255, 255, 255);
    text("Start Wave", GAME_WIDTH/2, GAME_HEIGHT + 2*(DATABAR_HEIGHT/5));
}

// Draw the game
void drawWave() {
  //If not boss level, check level is over (all grunts dead)
  if (boss== null && grunts.size()==0) {
    if (background.isPlaying()) {
      background.pause();
      nextlevel.play();
    }
    delay(300);
    nextLevel();
  }
  //counters for powerups
  if (deadCount > 0) {
    deadCount--;
  }
  if (invisibleCount > 0) {
    invisibleCount--;
  }
  if (invincibleCount > 0) {
    invincibleCount--;
  }
  if (forceCount > 0) {
    forceCount--;
  }
  count = (count+1)%200;

  map.display();
  //If boss round, check boss next level conditions
  if (boss !=null) {
    if (!boss.display()) {
      addScore(1500);
      boss = null;
      nextlevel.play();
      delay(300);
      nextLevel();
    } else {
      boss.isHittingPlayer();
    }
  } 
  //Draw obstacles
  for (int i = 0; i < obstacles.size(); i++) {
    if (!obstacles.get(i).display()) {
      obstacles.remove(i);
      i--;
    } else {
      obstacles.get(i).isHittingPlayer();
    }
  }
  //Draw powerups
  for (int i = 0; i < powerups.size(); i++) {
    if (!powerups.get(i).display()) {
      powerups.remove(i);
      i--;
    }
  }
  //Check player collisions with obstacles and powerups
  playerColliding(player.getPosition());
  for (int i = 0; i < grunts.size(); i++) {
    if (!grunts.get(i).display()) {
      grunts.remove(i);
      i--;
    } else {
      grunts.get(i).isHittingPlayer();
    }
  }
  //Draw Hulks
  for (int i = 0; i < hulks.size(); i++) {
    if (!hulks.get(i).display()) {
      hulks.remove(i);
      i--;
    } else {
      hulks.get(i).isHittingPlayer();
    }
  }
  //Draw bullets
  for (int i = 0; i < bullets.size(); i++) {
    bullets.get(i).display();
    if (bulletColliding(bullets.get(i).getPosition(), bullets.get(i).playerSend)) {
      bullets.remove(i);
      i--;
    }
  }
  //Draw Humans and set their behaviour states
  for (int i = 0; i < humans.size(); i++) {
    if (humanColliding(humans.get(i))) {
      humans.get(i).die();
    }
    if (!humans.get(i).display()) {
      humans.remove(i);
      i--;
    } else {
      if (count ==100) {
        humans.get(i).checkProgress();
      }
      boolean running = false;
      if (PVector.dist(player.getPosition(), humans.get(i).getPosition()) < 100) {
        humans.get(i).seek(player.getPosition());
        running = true;
      } else {
        for (Hulk hulk : hulks) {
          if (PVector.dist(hulk.getPosition(), humans.get(i).getPosition()) < 60) {
            humans.get(i).flee(hulk.getPosition());
            running = true;
            break;
          }
        }
        for (Brain brain : brains) {
          if (PVector.dist(brain.getPosition(), humans.get(i).getPosition()) < 100) {
            humans.get(i).flee(brain.getPosition());
            running = true;
            break;
          }
        }
      }
      if (!running) {
        humans.get(i).wander();
      }
    }
  }
  //Draw brains and update their behaviour states
  for (int i = 0; i < brains.size(); i++) {
    if (!brains.get(i).display()) {
      brains.remove(i);
      i--;
    } else {
      brains.get(i).isHittingPlayer();
      float minDist = 1000;
      int minIndex = -1;
      boolean close = false;
      for (int j = 0; j < humans.size(); j++) {
        if (PVector.dist(humans.get(j).getPosition(), brains.get(i).getPosition()) < 150) {
          if (PVector.dist(humans.get(j).getPosition(), brains.get(i).getPosition()) < minDist) {
            minDist = PVector.dist(humans.get(j).getPosition(), brains.get(i).getPosition());
            minIndex = j;
            close = true;
          }
        }
      }
      if (close) {
        brains.get(i).setTarget(map.pointToCell(humans.get(minIndex).getPosition()));
      } else {
        brains.get(i).setTarget(null);
      }
    }
  }
  //Draw progs
  for (int i = 0; i < progs.size(); i++) {
    if (!progs.get(i).display()) {
      progs.remove(i);
      i--;
    } else {
      progs.get(i).isHittingPlayer();
    }
  }
  //Draw player
  player.display();
  //Draw text
  textFont(font);
  fill(20, 53, 163);
  text("Robotron: 4303", 19, 45);
  fill(246, 255, 0);
  text("score: " + Integer.toString(score), 19, 80);
  fill(36, 237, 89);
  text("level: " + Integer.toString(level), 19, 120);
  fill(227, 39, 51);
  text("lives: " + Integer.toString(lives), 19, 157);
  fill(255);
  //Draw boss text if boss level
  if (boss != null) {
    int rgb = (int) random(1, 7);
    if (rgb ==1) {
      fill(color(200, 0, (int)random(0, 256)));
    } else if (rgb == 2) {
      fill(color(200, (int)random(0, 256), 0));
    } else if (rgb == 3) {
      fill(color((int)random(0, 256), 0, 200));
    } else if (rgb == 4) {
      fill(color(0, (int)random(0, 256), 200));
    } else if (rgb == 5) {
      fill(color((int)random(0, 256), 200, 0));
    } else if (rgb == 6) {
      fill(color(0, 200, (int)random(0, 256)));
    }
    textFont(fontLarge);
    text("BOSS", 390, 150);
    fill(255);
  }
  //Draw game over screen if game over
  if (gameOver) {
    frameRate(120);
    lives = 0;
    int rgb = (int) random(1, 7);
    if (rgb ==1) {
      fill(color(200, 0, (int)random(0, 256)));
    } else if (rgb == 2) {
      fill(color(200, (int)random(0, 256), 0));
    } else if (rgb == 3) {
      fill(color((int)random(0, 256), 0, 200));
    } else if (rgb == 4) {
      fill(color(0, (int)random(0, 256), 200));
    } else if (rgb == 5) {
      fill(color((int)random(0, 256), 200, 0));
    } else if (rgb == 6) {
      fill(color(0, 200, (int)random(0, 256)));
    }
    textFont(fontLarge);
    text("GAME OVER", 280, 500);
    textFont(font);
    fill(246, 255, 0);
    text("score: " + Integer.toString(score), 360, 550);
    fill(36, 237, 89);
    text("level: " + Integer.toString(level), 385, 590);
    fill(252, 3, 207);
    text("Press any button to play again!", 70, 630);
    fill(255);
    if (clickReadyCount  == 0) {
      clickReady = true;
    } else {
      clickReadyCount--;
    }
  }
} 

// Draw the postwave page
void drawPostWave() {
    background(0, 152, 0);
    // map.draw();
    for (Human human : homepageHumans) {
        human.draw();
        human.integrate();
    }
    textSize(50);
    fill(0, 0, 0);
    text("Wave " + wave + " Complete!", GAME_WIDTH/2, GAME_HEIGHT/5);
    textSize(25);
    text("Cash: £" + cash, GAME_WIDTH/2, GAME_HEIGHT/2);
    text("Lives left: " + playerCar.lives, GAME_WIDTH/2, GAME_HEIGHT/2 + 50);
    rect(0, GAME_HEIGHT, GAME_WIDTH, DATABAR_HEIGHT);
    stroke(255, 255, 255);
    strokeWeight(1);
    line(0, GAME_HEIGHT, GAME_WIDTH, GAME_HEIGHT);
    line(GAME_WIDTH/2, GAME_HEIGHT, GAME_WIDTH/2, GAME_HEIGHT + DATABAR_HEIGHT);
    noStroke();
    fill(255, 255, 255);
    text("Next Wave", GAME_WIDTH/4, GAME_HEIGHT + 2*(DATABAR_HEIGHT/5));
    text("Item Shop", 3*GAME_WIDTH/4, GAME_HEIGHT + 2*(DATABAR_HEIGHT/5));
}

// Draw the paused screen
void drawPaused() {
    background(0, 152, 0);
    // map.draw();
    for (Human human : homepageHumans) {
        human.draw();
        human.integrate();
    }
    textSize(50);
    fill(0, 0, 0);
    text("Paused!", GAME_WIDTH/2, GAME_HEIGHT/5);
    textSize(25);
    text("Wave " + wave, GAME_WIDTH/2, GAME_HEIGHT/2);
    text("Cash: £" + cash, GAME_WIDTH/2, GAME_HEIGHT/2 + 50);
    text("Lives left: " + playerCar.lives, GAME_WIDTH/2, GAME_HEIGHT/2 + 100);
    rect(0, GAME_HEIGHT, GAME_WIDTH, DATABAR_HEIGHT);
    stroke(255, 255, 255);
    strokeWeight(1);
    line(0, GAME_HEIGHT, GAME_WIDTH, GAME_HEIGHT);
    noStroke();
    fill(255, 255, 255);
    text("Press 'Q' to unpause", GAME_WIDTH/2, GAME_HEIGHT + 2*(DATABAR_HEIGHT/5));
}

// Draw the game over screen
void drawGameOver() {
    background(0, 152, 0);
    // map.draw();
    for (Human human : homepageHumans) {
        human.draw();
        human.integrate();
    }
    textSize(50);
    fill(0, 0, 0);
    text("Game Over!", GAME_WIDTH/2, GAME_HEIGHT/5);
    textSize(25);
    text("Wave reached: " + wave, GAME_WIDTH/2, GAME_HEIGHT/2);
    text("Cash earned: £" + cashEarned, GAME_WIDTH/2, GAME_HEIGHT/2 + 50);
    if ((cashEarned >= highscore) && (cashEarned > 0)) {
        text("New high score!", GAME_WIDTH/2, GAME_HEIGHT/2 + 100);
        highscore = cashEarned;
    }
    if (highestWaveAchieved) {
        text("New highest wave!", GAME_WIDTH/2, GAME_HEIGHT/2 + 150);
    }
    rect(0, GAME_HEIGHT, GAME_WIDTH, DATABAR_HEIGHT);
    stroke(255, 255, 255);
    strokeWeight(1);
    line(0, GAME_HEIGHT, GAME_WIDTH, GAME_HEIGHT);
    noStroke();
    fill(255, 255, 255);
    text("Homepage", GAME_WIDTH/2, GAME_HEIGHT + 2*(DATABAR_HEIGHT/5));
}

// Draw the item guide page
void drawItemGuide() {
    background(0, 152, 0);
    // map.draw();
    for (Human human : homepageHumans) {
        human.draw();
        human.integrate();
    }
    textSize(50);
    fill(0, 0, 0);
    text("Item Guide", GAME_WIDTH/2, GAME_HEIGHT/5);
    textSize(25);
    textAlign(LEFT, CENTER);
    text("- The ambulance is slow but earns 1.5x cash.", GAME_WIDTH/12, GAME_HEIGHT/2 - 100);
    text("- The sports car is faster and has better grip.", GAME_WIDTH/12, GAME_HEIGHT/2 - 50);
    text("- The F1 car is fastest but has bad grass grip.", GAME_WIDTH/12, GAME_HEIGHT/2);
    text("- Offroad tyres gives road-level grip on the grass.", GAME_WIDTH/12, GAME_HEIGHT/2 + 50);
    text("- The boost propels the car forwards using SPACE.", GAME_WIDTH/12, GAME_HEIGHT/2 + 100);
    text("- The pulse eliminates proximate humans and police cars using 'E'.", GAME_WIDTH/12, GAME_HEIGHT/2 + 150);
    text("- The air strike drops a cluster of bombs around a clicked position.", GAME_WIDTH/12, GAME_HEIGHT/2 + 200);
    text("- Both the pulse and air strike earn £50 for killing a human", GAME_WIDTH/12, GAME_HEIGHT/2 + 250);
    text("  and £100 for destroying a police car.", GAME_WIDTH/12, GAME_HEIGHT/2 + 300);
    textAlign(CENTER, CENTER);
    rect(0, GAME_HEIGHT, GAME_WIDTH, DATABAR_HEIGHT);
    stroke(255, 255, 255);
    strokeWeight(1);
    line(0, GAME_HEIGHT, GAME_WIDTH, GAME_HEIGHT);
    noStroke();
    fill(255, 255, 255);
    text("Back", GAME_WIDTH/2, GAME_HEIGHT + 2*(DATABAR_HEIGHT/5));
}

// Draw the stats page
void drawStats() {
    background(0, 152, 0);
    // map.draw();
    for (Human human : homepageHumans) {
        human.draw();
        human.integrate();
    }
    textSize(50);
    fill(0, 0, 0);
    text("Stats", GAME_WIDTH/2, GAME_HEIGHT/5);
    textSize(25);
    text("Total games played: " + totalGamesPlayed, GAME_WIDTH/2, GAME_HEIGHT/2 - 70);
    text("Total waves cleared: " + totalWavesCleared, GAME_WIDTH/2, GAME_HEIGHT/2 - 10);
    text("Total cash earned: " + totalCashEarned, GAME_WIDTH/2, GAME_HEIGHT/2 + 50);
    text("Total humans killed: " + totalHumansKilled, GAME_WIDTH/2, GAME_HEIGHT/2 + 110);
    text("Total police cars eliminated: " + totalPoliceCarsEliminated, GAME_WIDTH/2, GAME_HEIGHT/2 + 170);
    rect(0, GAME_HEIGHT, GAME_WIDTH, DATABAR_HEIGHT);
    stroke(255, 255, 255);
    strokeWeight(1);
    line(0, GAME_HEIGHT, GAME_WIDTH, GAME_HEIGHT);
    noStroke();
    fill(255, 255, 255);
    text("Back", GAME_WIDTH/2, GAME_HEIGHT + 2*(DATABAR_HEIGHT/5));
}

// Draw a lock to show locked items
void drawLock(int posX, int posY, int size) {
    rectMode(CENTER);
    fill(0, 0, 0);
    ellipse(posX, posY - size/2, size, size);
    fill(0, 152, 0);
    ellipse(posX, posY - size/2, size/2, size/2);
    fill(0, 0, 0);
    rect(posX, posY, size, size);
}

// Draw cooldown bars for power ups
void drawCooldownBar(int posX, int posY, int _width, int _height, int cooldown, int maxCooldown, int red, int green, int blue) {
    rectMode(CENTER);
    fill(0, 0, 0);
    rect(posX, posY, _width, _height);
    fill(red, green, blue);
    rectMode(CORNER);
    rect(posX - (_width/2), posY - (_height/2), _width*cooldown/maxCooldown, _height);
}

// Draw crosshairs to enhance mouse position and aim air strike
void drawCrosshairs() {
    stroke(255, 255, 255);
    strokeWeight(1);
    line(mouseX-10, mouseY, mouseX+10, mouseY);
    line(mouseX, mouseY-10, mouseX, mouseY+10);
    noStroke();
}

// Draw a small red circle in the corner to show when dev tools are turned on
void drawDevTools() {
    fill(255, 0, 0);
    ellipse(GAME_WIDTH-DATABAR_HEIGHT/2, DATABAR_HEIGHT/2, DATABAR_HEIGHT/2, DATABAR_HEIGHT/2);
}

// Add cash
void addCash(int value) {
    cash += value;
    cashEarned += value;
    totalCashEarned += value;
}

// Add commas to a number in appropriate positions
String formatNumber(int num) {
    String numberString = Integer.toString(num);
    int length = numberString.length();
    int commaPos = length % 3;
    if (commaPos == 0) {
        commaPos = 3;
    }
    String formattedNumber = "";
    for (int i = 0; i < length; i++) {
        if (i == commaPos) {
            formattedNumber += ",";
            commaPos += 3;
        }
        formattedNumber += numberString.charAt(i);
    }
    return formattedNumber;
}

// Close sound channels
void stop() {
    music.close();
    crashOne.close();
    crashTwo.close();
    wilhelm.close();
    minecraft.close();
    roblox.close();
    cashSpent.close();
    boost.close();
    pulse.close();
    explosion.close();
    waveComplete.close();
    gameOver.close();
    minim.stop();
}

// Set wave variables and reset game elements for the next wave
void setupNextWave() {
    // Increment wave
    wave++;
    totalWavesCleared++;

    // Update highestWave
    if (wave > highestWave) {
        highestWave = wave;
        highestWaveAchieved = true;
    }

    // Update number of humans
    numHumans += HUMAN_COUNT_INCREMENT;

    // Update number of police cars
    if (wave % POLICE_CAR_WAVE_INCREMENT == 0) {
        numPoliceCars++;
    }

    // Update police car max speed
    if (wave < 20) { // To stop police cars from going too fast
        POLICE_CAR_MAX_SPEED += POLICE_CAR_SPEED_INCREMENT;
    }

    // Reset air strike
    airStrike.reset();

    // Reset wave start countdown
    waveStarted = false;
    waveStartCountdown = (60 * 3)-20;

    // Reset humans killed
    humansKilled = 0;

    // Generate new map
    map = new Map(GAME_WIDTH, GAME_HEIGHT, MAP_RESOLUTION, NUM_DECORATIONS, DECORATION_SIZE, DECORATION_OFFSET);
    map.generate();

    // Reset player car
    PVector initialPlayerCarPosition = new PVector(random(50, GAME_WIDTH-50), random(50, GAME_HEIGHT-50));
    PVector nwCorner = new PVector(0, 0);
    PVector neCorner = new PVector(GAME_WIDTH, 0);
    PVector swCorner = new PVector(0, GAME_HEIGHT);
    PVector seCorner = new PVector(GAME_WIDTH, GAME_HEIGHT);
    PVector nearestCornerToPlayerCar = new PVector(GAME_WIDTH/2, GAME_HEIGHT/2);
    float nearestCornerToPlayerCarDistance = Float.MAX_VALUE;
    if (initialPlayerCarPosition.copy().sub(nwCorner).mag() < nearestCornerToPlayerCarDistance) {
        nearestCornerToPlayerCar = nwCorner;
        nearestCornerToPlayerCarDistance = initialPlayerCarPosition.copy().sub(nwCorner).mag();
    }
    if (initialPlayerCarPosition.copy().sub(neCorner).mag() < nearestCornerToPlayerCarDistance) {
        nearestCornerToPlayerCar = neCorner;
        nearestCornerToPlayerCarDistance = initialPlayerCarPosition.copy().sub(neCorner).mag();
    }
    if (initialPlayerCarPosition.copy().sub(swCorner).mag() < nearestCornerToPlayerCarDistance) {
        nearestCornerToPlayerCar = swCorner;
        nearestCornerToPlayerCarDistance = initialPlayerCarPosition.copy().sub(swCorner).mag();
    }
    if (initialPlayerCarPosition.copy().sub(seCorner).mag() < nearestCornerToPlayerCarDistance) {
        nearestCornerToPlayerCar = seCorner;
        nearestCornerToPlayerCarDistance = initialPlayerCarPosition.copy().sub(seCorner).mag();
    }
    PVector directionToNearestCornerFromPlayerCar = initialPlayerCarPosition.copy().sub(nearestCornerToPlayerCar);
    float initialPlayerCarOrientation = directionToNearestCornerFromPlayerCar.heading();
    int playerLives = playerCar.lives;
    int playerCarType = playerCar.type;
    playerCar = new PlayerCar(PLAYER_CAR_WIDTH, PLAYER_CAR_HEIGHT, initialPlayerCarPosition, initialPlayerCarOrientation, PLAYER_CAR_BRAKING_POWER, PLAYER_CAR_MAX_SPEED, PLAYER_CAR_MAX_ACCELERATION, PLAYER_CAR_MAX_STEERING, PLAYER_CAR_FRICTION, PLAYER_CAR_FRICTION_MULTIPLIER, GAME_WIDTH, GAME_HEIGHT, PLAYER_CAR_MAX_LIVES, MAX_BOOST_TIMER, MAX_PULSE_TIMER, BOOST_COOLDOWN, PULSE_SIZE, PULSE_COOLDOWN);
    playerCar.setLives(playerLives);
    playerCar.setType(playerCarType);

    // Reset police cars
    policeCars = new ArrayList<PoliceCar>();
    for (int i = 0; i < numPoliceCars; i++) {
        PVector initialPoliceCarPosition = new PVector(random(50, GAME_WIDTH-50), random(50, GAME_HEIGHT-50));
        PVector closestPoliceCar = new PVector(0, 0);
        float closestPoliceCarDistance = Float.MAX_VALUE;
        for (PoliceCar policeCar : policeCars) {
            float distance = initialPoliceCarPosition.copy().sub(policeCar.position).mag();
            if ((distance != 0.0) && (distance < closestPoliceCarDistance)) {
                closestPoliceCar = policeCar.position.copy();
                closestPoliceCarDistance = distance;
            }
        }
        while ((initialPoliceCarPosition.copy().sub(initialPlayerCarPosition).mag() < PLAYER_CAR_SAFE_ZONE) || (initialPoliceCarPosition.copy().sub(closestPoliceCar).mag() < POLICE_CAR_VISION_RADIUS)) {
            initialPoliceCarPosition = new PVector(random(50, GAME_WIDTH-50), random(50, GAME_HEIGHT-50));
            for (PoliceCar policeCar : policeCars) {
                float distance = initialPoliceCarPosition.copy().sub(policeCar.position).mag();
                if ((distance != 0.0) && (distance < closestPoliceCarDistance)) {
                    closestPoliceCar = policeCar.position.copy();
                    closestPoliceCarDistance = distance;
                }
            }
        }
        float initialPoliceCarOrientation = random(0, PI) - random(-PI, 0);
        PoliceCar newPoliceCar = new PoliceCar(POLICE_CAR_WIDTH, POLICE_CAR_HEIGHT, i, initialPoliceCarPosition, initialPoliceCarOrientation, POLICE_CAR_MAX_SPEED, POLICE_CAR_MAX_ACCELERATION, playerCar, GAME_WIDTH, GAME_HEIGHT);
        policeCars.add(newPoliceCar);
    }

    // Reset humans
    humans = new ArrayList<Human>();
    for (int i = 0; i < numHumans; i++) {
        PVector initialHumanPosition = new PVector(random(50, GAME_WIDTH-50), random(50, GAME_HEIGHT-50));
        PVector closestPoliceCar = new PVector(0, 0);
        float closestPoliceCarDistance = Float.MAX_VALUE;
        for (PoliceCar policeCar : policeCars) {
            float distance = initialHumanPosition.copy().sub(policeCar.position).mag();
            if (distance < closestPoliceCarDistance) {
                closestPoliceCar = policeCar.position.copy();
                closestPoliceCarDistance = distance;
            }
        }
        PVector closestOtherHuman = new PVector(0, 0);
        float closestOtherHumanDistance = Float.MAX_VALUE;
        for (Human human : humans) {
            float distance = initialHumanPosition.copy().sub(human.position).mag();
            if ((distance != 0.0) && (distance < closestOtherHumanDistance)) {
                closestOtherHuman = human.position.copy();
                closestOtherHumanDistance = distance;
            }
        }
        while ((initialHumanPosition.copy().sub(initialPlayerCarPosition).mag() < HUMAN_SAFE_ZONE) || (initialHumanPosition.copy().sub(closestPoliceCar).mag() < HUMAN_SAFE_ZONE) || (initialHumanPosition.copy().sub(closestOtherHuman).mag() < HUMAN_SAFE_ZONE) || (initialHumanPosition.copy().sub(closestOtherHuman).mag() < HUMAN_SAFE_ZONE)) {
            initialHumanPosition = new PVector(random(50, GAME_WIDTH-50), random(50, GAME_HEIGHT-50));
            for (PoliceCar policeCar : policeCars) {
                float distance = initialHumanPosition.copy().sub(policeCar.position).mag();
                if (distance < closestPoliceCarDistance) {
                    closestPoliceCar = policeCar.position.copy();
                    closestPoliceCarDistance = distance;
                }
            }
            for (Human human : humans) {
                float distance = initialHumanPosition.copy().sub(human.position).mag();
                if ((distance != 0.0) && (distance < closestOtherHumanDistance)) {
                    closestOtherHuman = human.position.copy();
                    closestOtherHumanDistance = distance;
                }
            }
        }
        Human newHuman = new Human(HUMAN_SIZE, initialHumanPosition, new PVector(random(-HUMAN_MAX_SPEED, HUMAN_MAX_SPEED), random(-HUMAN_MAX_SPEED, HUMAN_MAX_SPEED)), GAME_WIDTH, GAME_HEIGHT);
        humans.add(newHuman);
    }
}

// Reset all game parameters apart from unlocks to allow player to play again after game over
void resetWaves() {
    // Reset wave parameters
    numHumans = INITIAL_HUMAN_COUNT;
    numPoliceCars = INITIAL_POLICE_CAR_COUNT;
    POLICE_CAR_MAX_SPEED = INITIAL_POLICE_CAR_MAX_SPEED;

    // Reset wave and cash
    wave = 1;
    cash = 0;
    cashEarned = 0;

    // Reset highest wave flag
    highestWaveAchieved = false;

    // Reset air strike
    airStrike.reset();

    // Reset wave start countdown
    waveStarted = false;
    waveStartCountdown = (60 * 3)-20;

    // Reset humans killed
    humansKilled = 0;

    // Reset map
    map = new Map(GAME_WIDTH, GAME_HEIGHT, MAP_RESOLUTION, NUM_DECORATIONS, DECORATION_SIZE, DECORATION_OFFSET);
    map.generate();

    // Reset player car
    PVector initialPlayerCarPosition = new PVector(random(50, GAME_WIDTH-50), random(50, GAME_HEIGHT-50));
    PVector nwCorner = new PVector(0, 0);
    PVector neCorner = new PVector(GAME_WIDTH, 0);
    PVector swCorner = new PVector(0, GAME_HEIGHT);
    PVector seCorner = new PVector(GAME_WIDTH, GAME_HEIGHT);
    PVector nearestCornerToPlayerCar = new PVector(GAME_WIDTH/2, GAME_HEIGHT/2);
    float nearestCornerToPlayerCarDistance = Float.MAX_VALUE;
    if (initialPlayerCarPosition.copy().sub(nwCorner).mag() < nearestCornerToPlayerCarDistance) {
        nearestCornerToPlayerCar = nwCorner;
        nearestCornerToPlayerCarDistance = initialPlayerCarPosition.copy().sub(nwCorner).mag();
    }
    if (initialPlayerCarPosition.copy().sub(neCorner).mag() < nearestCornerToPlayerCarDistance) {
        nearestCornerToPlayerCar = neCorner;
        nearestCornerToPlayerCarDistance = initialPlayerCarPosition.copy().sub(neCorner).mag();
    }
    if (initialPlayerCarPosition.copy().sub(swCorner).mag() < nearestCornerToPlayerCarDistance) {
        nearestCornerToPlayerCar = swCorner;
        nearestCornerToPlayerCarDistance = initialPlayerCarPosition.copy().sub(swCorner).mag();
    }
    if (initialPlayerCarPosition.copy().sub(seCorner).mag() < nearestCornerToPlayerCarDistance) {
        nearestCornerToPlayerCar = seCorner;
        nearestCornerToPlayerCarDistance = initialPlayerCarPosition.copy().sub(seCorner).mag();
    }
    PVector directionToNearestCornerFromPlayerCar = initialPlayerCarPosition.copy().sub(nearestCornerToPlayerCar);
    float initialPlayerCarOrientation = directionToNearestCornerFromPlayerCar.heading();
    int playerCarType = playerCar.type;
    playerCar = new PlayerCar(PLAYER_CAR_WIDTH, PLAYER_CAR_HEIGHT, initialPlayerCarPosition, initialPlayerCarOrientation, PLAYER_CAR_BRAKING_POWER, PLAYER_CAR_MAX_SPEED, PLAYER_CAR_MAX_ACCELERATION, PLAYER_CAR_MAX_STEERING, PLAYER_CAR_FRICTION, PLAYER_CAR_FRICTION_MULTIPLIER, GAME_WIDTH, GAME_HEIGHT, PLAYER_CAR_MAX_LIVES, MAX_BOOST_TIMER, MAX_PULSE_TIMER, BOOST_COOLDOWN, PULSE_SIZE, PULSE_COOLDOWN);
    playerCar.setType(playerCarType);

    // Reset police cars
    policeCars = new ArrayList<PoliceCar>();
    for (int i = 0; i < numPoliceCars; i++) {
        PVector initialPoliceCarPosition = new PVector(random(50, GAME_WIDTH-50), random(50, GAME_HEIGHT-50));
        PVector closestPoliceCar = new PVector(0, 0);
        float closestPoliceCarDistance = Float.MAX_VALUE;
        for (PoliceCar policeCar : policeCars) {
            float distance = initialPoliceCarPosition.copy().sub(policeCar.position).mag();
            if ((distance != 0.0) && (distance < closestPoliceCarDistance)) {
                closestPoliceCar = policeCar.position.copy();
                closestPoliceCarDistance = distance;
            }
        }
        while ((initialPoliceCarPosition.copy().sub(initialPlayerCarPosition).mag() < PLAYER_CAR_SAFE_ZONE) || (initialPoliceCarPosition.copy().sub(closestPoliceCar).mag() < POLICE_CAR_VISION_RADIUS)) {
            initialPoliceCarPosition = new PVector(random(50, GAME_WIDTH-50), random(50, GAME_HEIGHT-50));
            for (PoliceCar policeCar : policeCars) {
                float distance = initialPoliceCarPosition.copy().sub(policeCar.position).mag();
                if ((distance != 0.0) && (distance < closestPoliceCarDistance)) {
                    closestPoliceCar = policeCar.position.copy();
                    closestPoliceCarDistance = distance;
                }
            }
        }
        float initialPoliceCarOrientation = random(0, PI) - random(-PI, 0);
        PoliceCar newPoliceCar = new PoliceCar(POLICE_CAR_WIDTH, POLICE_CAR_HEIGHT, i, initialPoliceCarPosition, initialPoliceCarOrientation, POLICE_CAR_MAX_SPEED, POLICE_CAR_MAX_ACCELERATION, playerCar, GAME_WIDTH, GAME_HEIGHT);
        policeCars.add(newPoliceCar);
    }

    // Reset humans
    humans = new ArrayList<Human>();
    for (int i = 0; i < numHumans; i++) {
        PVector initialHumanPosition = new PVector(random(50, GAME_WIDTH-50), random(50, GAME_HEIGHT-50));
        PVector closestPoliceCar = new PVector(0, 0);
        float closestPoliceCarDistance = Float.MAX_VALUE;
        for (PoliceCar policeCar : policeCars) {
            float distance = initialHumanPosition.copy().sub(policeCar.position).mag();
            if (distance < closestPoliceCarDistance) {
                closestPoliceCar = policeCar.position.copy();
                closestPoliceCarDistance = distance;
            }
        }
        PVector closestOtherHuman = new PVector(0, 0);
        float closestOtherHumanDistance = Float.MAX_VALUE;
        for (Human human : humans) {
            float distance = initialHumanPosition.copy().sub(human.position).mag();
            if ((distance != 0.0) && (distance < closestOtherHumanDistance)) {
                closestOtherHuman = human.position.copy();
                closestOtherHumanDistance = distance;
            }
        }
        while ((initialHumanPosition.copy().sub(initialPlayerCarPosition).mag() < HUMAN_SAFE_ZONE) || (initialHumanPosition.copy().sub(closestPoliceCar).mag() < HUMAN_SAFE_ZONE) || (initialHumanPosition.copy().sub(closestOtherHuman).mag() < HUMAN_SAFE_ZONE) || (initialHumanPosition.copy().sub(closestOtherHuman).mag() < HUMAN_SAFE_ZONE)) {
            initialHumanPosition = new PVector(random(50, GAME_WIDTH-50), random(50, GAME_HEIGHT-50));
            for (PoliceCar policeCar : policeCars) {
                float distance = initialHumanPosition.copy().sub(policeCar.position).mag();
                if (distance < closestPoliceCarDistance) {
                    closestPoliceCar = policeCar.position.copy();
                    closestPoliceCarDistance = distance;
                }
            }
            for (Human human : humans) {
                float distance = initialHumanPosition.copy().sub(human.position).mag();
                if ((distance != 0.0) && (distance < closestOtherHumanDistance)) {
                    closestOtherHuman = human.position.copy();
                    closestOtherHumanDistance = distance;
                }
            }
        }
        Human newHuman = new Human(HUMAN_SIZE, initialHumanPosition, new PVector(random(-HUMAN_MAX_SPEED, HUMAN_MAX_SPEED), random(-HUMAN_MAX_SPEED, HUMAN_MAX_SPEED)), GAME_WIDTH, GAME_HEIGHT);
        humans.add(newHuman);
    }
}

// Handle keyboard inputs
void keyPressed() {
    if (key == 'w' || key == 'W') {
        playerCar.accelerate();
    } else if (key == 's' || key == 'S') {
        playerCar.brake();
    } else if (key == 'a' || key == 'A') {
        playerCar.steerLeft();
    } else if (key == 'd' || key == 'D') {
        playerCar.steerRight();
    } else if (key == ' ') {
        if (boostUnlocked) {
            if (!playerCar.boosting && !playerCar.boostUsed) {
                boost.rewind();
                if (!muted) {
                    boost.play();
                }
            }
            playerCar.boost();
        }
    } else if (key == 'e' || key == 'E') {
        if (pulseUnlocked) {
            if (!playerCar.pulsing && !playerCar.pulseUsed) {
                pulse.rewind();
                if (!muted) {
                    pulse.play();
                }
            }
            playerCar.pulse();
        }
    } else if (key == 'j' || key == 'J') {
        showQuadTree = !showQuadTree;
    } else if (key == 'q' || key == 'Q') {
        if (GameStates.phase == 5) {
            // Reset wave start countdown
            waveStarted = false;
            waveStartCountdown = (60 * 3)-20;
            GameStates.visitPaused();
        } else if (GameStates.phase == 7) {
            GameStates.visitWave();
        }
    }
    // Developer tools
    if (devToolsOn) {
        if (key == 'z' || key == 'Z') {
            GameStates.visitHomepage();
        } else if (key == 'x' || key == 'X') {
            GameStates.visitGuide();
        } else if (key == 'c' || key == 'C') {
            GameStates.visitCarSelect();
        } else if (key == 'v' || key == 'V') {
            GameStates.visitItemShop();
        } else if (key == 'b' || key == 'B') {
            GameStates.visitPreWave();
        } else if (key == 'n' || key == 'N') {
            GameStates.visitWave();
        } else if (key == 'm' || key == 'M') {
            GameStates.visitPostWave();
        } else if (key == ',' || key == '<') {
            GameStates.visitPaused();
        } else if (key == '.' || key == '>') {
            GameStates.visitEndgame();
        } else if (key == '/' || key == '?') {
            GameStates.visitItemGuide();
        } else if (keyCode == UP) {
            playerCar.setType(0);
        } else if (keyCode == LEFT) {
            playerCar.setType(1);
        } else if (keyCode == DOWN) {
            playerCar.setType(2);
        } else if (keyCode == RIGHT) {
            playerCar.setType(3);
        } else if (key == '1') {
            ambulanceUnlocked = true;
        } else if (key == '2') {
            sportsCarUnlocked = true;
        } else if (key == '3') {
            f1CarUnlocked = true;
        } else if (key == '4') {
            offroadTyresUnlocked = true;
        } else if (key == '5') {
            boostUnlocked = true;
        } else if (key == '6') {
            pulseUnlocked = true;
        } else if (key == '7') {
            airStrikeUnlocked = true;
        } else if (key == '0') {
            cash += 1000;
        } else if (key == '-') {
            playerCar.lives++;
        }
    }
}

// Handle key released keyboard inputs
void keyReleased() {
    if (key == 'w' || key == 'W') {
        playerCar.stopAccelerating();
    } else if (key == 's' || key == 'S') {
        playerCar.stopBraking();
    } else if (key == 'a' || key == 'A') {
        playerCar.stopSteeringLeft();
    } else if (key == 'd' || key == 'D') {
        playerCar.stopSteeringRight();
    }
}

// Handle mouse click inputs
void mousePressed() {
    if (GameStates.phase == 0) { // Homepage
        if (mouseY > GAME_HEIGHT) {
            if (mouseX < GAME_WIDTH/3) {
                totalGamesPlayed++;
                GameStates.visitPreWave();
            } else if (mouseX > 2*GAME_WIDTH/3) {
                GameStates.visitCarSelect();
            } else {
                GameStates.visitGuide();
            }
        } else if (mouseY < DATABAR_HEIGHT) {
            if (mouseX < 3*DATABAR_HEIGHT) {
                GameStates.visitStats();
            } else if (mouseX > GAME_WIDTH-(3*DATABAR_HEIGHT)) {
                devToolsOn = !devToolsOn;
            } else if (((GAME_WIDTH/2)-(1.5*DATABAR_HEIGHT) < mouseX) && (mouseX < (GAME_WIDTH/2)+(1.5*DATABAR_HEIGHT))) {
                if (muted) {
                    muted = false;
                    music.loop();
                } else {
                    muted = true;
                    music.pause();
                }
            }
        }
    } else if (GameStates.phase == 1) {  // Guide
        if (mouseY > GAME_HEIGHT) {
            GameStates.visitHomepage();
        }
    } else if (GameStates.phase == 2) {  // CarSelect
        if (mouseY > GAME_HEIGHT) {
            GameStates.previous();
        } else if ((mouseY > (4*GAME_HEIGHT/5 - 1.25*PLAYER_CAR_WIDTH)) && (mouseY < (4*GAME_HEIGHT/5 + 1.25*PLAYER_CAR_WIDTH))) {
            if ((mouseX > (GAME_WIDTH/5 - 1.25*PLAYER_CAR_WIDTH)) && (mouseX < (GAME_WIDTH/5 + 1.25*PLAYER_CAR_WIDTH))) {
                playerCar.setType(0);
            } else if ((mouseX > (2*GAME_WIDTH/5 - 1.25*PLAYER_CAR_WIDTH)) && (mouseX < (2*GAME_WIDTH/5 + 1.25*PLAYER_CAR_WIDTH))) {
                if (ambulanceUnlocked) {
                    playerCar.setType(1);
                }
            } else if ((mouseX > (3*GAME_WIDTH/5 - 1.25*PLAYER_CAR_WIDTH)) && (mouseX < (3*GAME_WIDTH/5 + 1.25*PLAYER_CAR_WIDTH))) {
                if (sportsCarUnlocked) {
                    playerCar.setType(2);
                }
            } else if ((mouseX > (4*GAME_WIDTH/5 - 1.25*PLAYER_CAR_WIDTH)) && (mouseX < (4*GAME_WIDTH/5 + 1.25*PLAYER_CAR_WIDTH))) {
                if (f1CarUnlocked) {
                    playerCar.setType(3);
                }
            }
        }
    } else if (GameStates.phase == 3) { // ItemShop
        if (mouseY > GAME_HEIGHT) {
            if (mouseX < GAME_WIDTH/3) {
                GameStates.visitCarSelect();
            } else if (mouseX > 2*GAME_WIDTH/3) {
                GameStates.visitPostWave();
            } else {
                GameStates.visitItemGuide();
            }
        } else if ((mouseY > GAME_HEIGHT/2 - 1.25*PLAYER_CAR_WIDTH) && (mouseY < GAME_HEIGHT/2 + 1.25*PLAYER_CAR_WIDTH)) {
            if ((mouseX > GAME_WIDTH/4 - 1.25*PLAYER_CAR_WIDTH) && (mouseX < GAME_WIDTH/4 + 1.25*PLAYER_CAR_WIDTH)) {
                // Ambulance
                if (!ambulanceUnlocked && cash >= AMBULANCE_COST) {
                    cash -= AMBULANCE_COST;
                    totalCashSpent += AMBULANCE_COST;
                    ambulanceUnlocked = true;
                    cashSpent.rewind();
                    if (!muted) {
                        cashSpent.play();
                    }
                }
            } else if ((mouseX > 2*GAME_WIDTH/4 - 1.25*PLAYER_CAR_WIDTH) && (mouseX < 2*GAME_WIDTH/4 + 1.25*PLAYER_CAR_WIDTH)) {
                // Sports car
                if (!sportsCarUnlocked && cash >= SPORTS_CAR_COST) {
                    cash -= SPORTS_CAR_COST;
                    totalCashSpent += SPORTS_CAR_COST;
                    sportsCarUnlocked = true;
                    cashSpent.rewind();
                    if (!muted) {
                        cashSpent.play();
                    }
                }
            } else if ((mouseX > 3*GAME_WIDTH/4 - 1.25*PLAYER_CAR_WIDTH) && (mouseX < 3*GAME_WIDTH/4 + 1.25*PLAYER_CAR_WIDTH)) {
                // F1 car
                if (!f1CarUnlocked && cash >= F1_CAR_COST) {
                    cash -= F1_CAR_COST;
                    totalCashSpent += F1_CAR_COST;
                    f1CarUnlocked = true;
                    cashSpent.rewind();
                    if (!muted) {
                        cashSpent.play();
                    }
                }
            }
        } else if ((mouseY > 4*GAME_HEIGHT/5 - 1.25*PLAYER_CAR_WIDTH) && (mouseY < 4*GAME_HEIGHT/5 + 1.25*PLAYER_CAR_WIDTH)) {
            if ((mouseX > GAME_WIDTH/5 - 1.25*PLAYER_CAR_WIDTH) && (mouseX < GAME_WIDTH/5 + 1.25*PLAYER_CAR_WIDTH)) {
                // Offroad tyres
                if (!offroadTyresUnlocked && cash >= OFFROAD_TYRES_COST) {
                    cash -= OFFROAD_TYRES_COST;
                    totalCashSpent += OFFROAD_TYRES_COST;
                    offroadTyresUnlocked = true;
                    cashSpent.rewind();
                    if (!muted) {
                        cashSpent.play();
                    }
                }
            } else if ((mouseX > 2*GAME_WIDTH/5 - 1.25*PLAYER_CAR_WIDTH) && (mouseX < 2*GAME_WIDTH/5 + 1.25*PLAYER_CAR_WIDTH)) {
                // Boost
                if (!boostUnlocked && cash >= BOOST_COST) {
                    cash -= BOOST_COST;
                    totalCashSpent += BOOST_COST;
                    boostUnlocked = true;
                    cashSpent.rewind();
                    if (!muted) {
                        cashSpent.play();
                    }
                }
            } else if ((mouseX > 3*GAME_WIDTH/5 - 1.25*PLAYER_CAR_WIDTH) && (mouseX < 3*GAME_WIDTH/5 + 1.25*PLAYER_CAR_WIDTH)) {
                // Pulse
                if (!pulseUnlocked && cash >= PULSE_COST) {
                    cash -= PULSE_COST;
                    totalCashSpent += PULSE_COST;
                    pulseUnlocked = true;
                    cashSpent.rewind();
                    if (!muted) {
                        cashSpent.play();
                    }
                }
            } else if ((mouseX > 4*GAME_WIDTH/5 - 1.25*PLAYER_CAR_WIDTH) && (mouseX < 4*GAME_WIDTH/5 + 1.25*PLAYER_CAR_WIDTH)) {
                // Air Strike
                if (!airStrikeUnlocked && cash >= AIR_STRIKE_COST) {
                    cash -= AIR_STRIKE_COST;
                    totalCashSpent += AIR_STRIKE_COST;
                    airStrikeUnlocked = true;
                    cashSpent.rewind();
                    if (!muted) {
                        cashSpent.play();
                    }
                }
            }
        }
    } else if (GameStates.phase == 4) { // PreWave
        if (mouseY > GAME_HEIGHT) {
            GameStates.visitWave();
        }
    } else if (GameStates.phase == 5) { // Wave
        if (!airStrike.used && !airStrike.exploding && airStrikeUnlocked && waveStarted) {
            airStrike.drop(mouseX, mouseY);
            explosion.rewind();
            if (!muted) {
                explosion.play();
            }
        }
    } else if (GameStates.phase == 6) { // PostWave
        if (mouseY > GAME_HEIGHT) {
            if (mouseX < GAME_WIDTH/2) {
                waveStarted = false;
                setupNextWave();
                GameStates.visitPreWave();
            } else {
                GameStates.visitItemShop();
            }
        }
    } else if (GameStates.phase == 8) { // GameOver
        if (mouseY > GAME_HEIGHT) {
            resetWaves();
            GameStates.visitHomepage();
        }
    } else if (GameStates.phase == 9) { // ItemGuide
        if (mouseY > GAME_HEIGHT) {
            GameStates.visitItemShop();
        }
    } else if (GameStates.phase == 10) {  // Stats
        if (mouseY > GAME_HEIGHT) {
            GameStates.visitHomepage();
        }
    }
}
