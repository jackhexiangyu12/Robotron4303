public class QuadTree {

    // Instantiate quad tree variables
    BoundingBox boundary;
    int capacity;
    ArrayList<Point> points;
    boolean divided;
    QuadTree nw, ne, sw, se;

    // Constructor initialises all class variables
    QuadTree(BoundingBox boundary, int capacity) {
        this.boundary = boundary;
        this.capacity = capacity;
        this.points = new ArrayList<Point>();
        this.divided = false;
    }

    // Draw the quad tree
    void draw() {
        stroke(255, 255, 255);
        noFill();
        rect(boundary.position.x, boundary.position.y, boundary.width, boundary.height);
        if (divided) {
            nw.draw();
            ne.draw();
            sw.draw();
            se.draw();
        }
        for (Point point : points) {
            point.draw();
        }
        noStroke();
    }

    // Get all points within a boundary from the quad tree
    ArrayList<Point> query(BoundingBox querySpace, ArrayList<Point> found) {
        if (found == null) {
            found = new ArrayList<Point>();
        }
        if (!boundary.intersects(querySpace)) {
            return found;
        } else {
            for (Point point : points) {
                if (querySpace.contains(point)) {
                    found.add(point);
                }
            }
            if (divided) {
                nw.query(querySpace, found);
                ne.query(querySpace, found);
                sw.query(querySpace, found);
                se.query(querySpace, found);
            }
            return found;
        }
    }

    // Divide a quad tree quadrant
    void subdivide() {
        BoundingBox northWest = new BoundingBox(boundary.position, boundary.width/2, boundary.height/2);
        BoundingBox northEast = new BoundingBox(new PVector(boundary.position.x + boundary.width/2, boundary.position.y), boundary.width/2, boundary.height/2);
        BoundingBox southWest = new BoundingBox(new PVector(boundary.position.x, boundary.position.y + boundary.height/2), boundary.width/2, boundary.height/2);
        BoundingBox southEast = new BoundingBox(new PVector(boundary.position.x + boundary.width/2, boundary.position.y + boundary.height/2), boundary.width/2, boundary.height/2);
        nw = new QuadTree(northWest, capacity);
        ne = new QuadTree(northEast, capacity);
        sw = new QuadTree(southWest, capacity);
        se = new QuadTree(southEast, capacity);
        divided = true;
    }

    // Insert a point into the quad tree
    void insert(Point point) {
        if (!boundary.contains(point)) {
            return;
        }
        if (points.size() < capacity) {
            points.add(point);
        } else {
            if (!divided) {
                subdivide();
            }
            nw.insert(point);
            ne.insert(point);
            sw.insert(point);
            se.insert(point);
        }
    }
}