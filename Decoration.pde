public class Decoration {

    // Instantiate the decoration variables
    int size;
    int width;
    int height;
    PVector position;
    PVector offset;
    int type; // 0 = tree, 1 = flower, and 2 = grass
    PImage sprite;

    // Initialise tree sprites
    PImage treeOne = loadImage("./Sprites/Trees/treeOne.png");
    PImage treeTwo = loadImage("./Sprites/Trees/treeTwo.png");
    PImage treeThree = loadImage("./Sprites/Trees/treeThree.png");
    PImage treeFour = loadImage("./Sprites/Trees/treeFour.png");
    PImage treeFive = loadImage("./Sprites/Trees/treeFive.png");
    PImage treeSix = loadImage("./Sprites/Trees/treeSix.png");
    PImage treeSeven = loadImage("./Sprites/Trees/treeSeven.png");
    PImage[] trees = new PImage[] {treeOne, treeTwo, treeThree, treeFour, treeFive, treeSix, treeSeven};

    // Initialise flower sprites
    PImage flowerOne = loadImage("./Sprites/Flowers/flowerOne.png");
    PImage flowerTwo = loadImage("./Sprites/Flowers/flowerTwo.png");
    PImage flowerThree = loadImage("./Sprites/Flowers/flowerThree.png");
    PImage flowerFour = loadImage("./Sprites/Flowers/flowerFour.png");
    PImage flowerFive = loadImage("./Sprites/Flowers/flowerFive.png");
    PImage flowerSix = loadImage("./Sprites/Flowers/flowerSix.png");
    PImage flowerSeven = loadImage("./Sprites/Flowers/flowerSeven.png");
    PImage flowerEight = loadImage("./Sprites/Flowers/flowerEight.png");
    PImage flowerNine = loadImage("./Sprites/Flowers/flowerNine.png");
    PImage flowerTen = loadImage("./Sprites/Flowers/flowerTen.png");
    PImage flowerEleven = loadImage("./Sprites/Flowers/flowerEleven.png");
    PImage flowerTwelve = loadImage("./Sprites/Flowers/flowerTwelve.png");
    PImage[] flowers = new PImage[] {flowerOne, flowerTwo, flowerThree, flowerFour, flowerFive, flowerSix, flowerSeven, flowerEight, flowerNine, flowerTen, flowerEleven, flowerTwelve};

    // Initialise grass sprites
    PImage grassOne = loadImage("./Sprites/Grass/grassOne.png");
    PImage grassTwo = loadImage("./Sprites/Grass/grassTwo.png");
    PImage grassThree = loadImage("./Sprites/Grass/grassThree.png");
    PImage[] grass = new PImage[] {grassOne, grassTwo, grassThree};

    // Constructor initialises all class variables
    Decoration(int size, PVector position, int type, int offset) {
        this.size = size;
        this.offset = new PVector(random(0, offset) - random(0, offset), random(0, offset) - random(0, offset));
        this.position = position.copy().add(this.offset);
        this.type = type;
        if (type == 0) {
            this.width = size * 30;
            this.height = size * 40;
            sprite = getRandom(trees);
        } else if (type == 1) {
            this.width = size * 16;
            this.height = size * 24;
            sprite = getRandom(flowers);
        } else {
            this.width = size * 20;
            this.height = size * 20;
            sprite = getRandom(grass);
        }
    }

    // Draw the chosen sprite at the correct location
    void draw() {
        pushMatrix();
        translate(position.x, position.y);
        image(sprite, 0, 0, width, height);
        popMatrix();
    }

    // Get a random PImage from an array
    PImage getRandom(PImage[] array) {
        int randomIndex = (int) random(array.length);
        return array[randomIndex];
    }

    // Check if another decoration intersects with this
    boolean intersects(Decoration decoration) {
        if (this.position.x + this.width > decoration.position.x && this.position.x < decoration.position.x + decoration.width && this.position.y + this.height > decoration.position.y && this.position.y < decoration.position.y + decoration.height) {
            return true;
        } else {
            return false;
        }
    }
}