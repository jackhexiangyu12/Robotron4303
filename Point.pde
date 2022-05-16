public class Point {

    // Instantiate point variables
    PVector position;
    Object object;
    int index;

    // Constructor initialises all class variables
    Point(PVector position, Object object) {
        this.position = position;
        this.object = object;
    }

    // Draw a red circle where the point is
    void draw() {
        fill(255, 0, 0);
        stroke(255, 0, 0);
        ellipse(position.x, position.y, 5, 5);
    }

    // Add an index to the point if the object does not dereference nicely
    void addIndex(int index) {
        this.index = index;
    }
}