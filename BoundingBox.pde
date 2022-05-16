public class BoundingBox {

    // Instantiate bounding box variables
    PVector position;
    int width;
    int height;

    // Constructor initialises all class variables
    BoundingBox(PVector position, int width, int height) {
        this.position = position;
        this.width = width;
        this.height = height;
    }

    // Draw the boundaries
    void draw() {
        stroke(0, 255, 0);
        noFill();
        rect(position.x, position.y, width, height);
    }

    // Check if a point is within some boundary
    boolean contains(Point point) {
        if ((position.x <= point.position.x) && (point.position.x < position.x+width) && (position.y <= point.position.y) && (point.position.y < position.y+height)) {
            return true;
        } else {
            return false;
        }
    }

    // Check if two bounding boxes overlap
    boolean intersects(BoundingBox space) {
        if ((position.x > space.position.x+space.width) || (position.x+width < space.position.x) || (position.y > space.position.y+space.height) || (position.y+height < space.position.y)) {
            return false;
        } else {
            return true;
        }
    }
}