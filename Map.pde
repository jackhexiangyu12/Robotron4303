public class Map {
    
    // Instantiate game size variables
    int gameWidth;
    int gameHeight;

    // Intstantiate map variables
    int resolution;
    int cols;
    int rows;
    int[][] field;
    int[][] states;

    // Instantiate map objects
    ArrayList<PVector> grassPoints;
    int numDecorations;
    Decoration[] decorations;
    int decorationSize;
    int decorationOffset;
    PVector[] decorationPositions;
   
    // Constructor initialises all class variables
    public Map(int gameWidth, int gameHeight, int resolution, int numDecorations, int decorationSize, int decorationOffset) {
        this.gameWidth = gameWidth;
        this.gameHeight = gameHeight;

        this.resolution = resolution;
        this.cols = gameWidth / resolution;
        this.rows = gameHeight / resolution;
        this.field = new int[cols+1][rows+1];
        this.states = new int[cols][rows];

        this.grassPoints = new ArrayList<PVector>();
        this.numDecorations = numDecorations;
        this.decorations = new Decoration[numDecorations];
        this.decorationSize = decorationSize;
        this.decorationOffset = decorationOffset;
        this.decorationPositions = new PVector[numDecorations];
    }

    // Draw the map
    void draw() {
        // View map collision detection boundaries
        // for (int i = 0; i <= gameWidth; i++) {
        //     for (int j = 0; j <= gameHeight; j++) {
        //         strokeWeight(1);
        //         if (closestPoint(new PVector(i, j)) == 0) {
        //             stroke(0);
        //         } else {
        //             stroke(255);
        //         }
        //         point(i, j);
        //         noStroke();
        //     }
        // }
        // Draw the map following a marching squares algorithm
        for (int i = 0; i < cols; i++) {
            for (int j = 0; j < rows; j++) {
                float x = i * resolution;
                float y = j * resolution;
                PVector a = new PVector(x + resolution/2, y);
                PVector b = new PVector(x + resolution, y + resolution/2);
                PVector c = new PVector(x + resolution/2, y + resolution);
                PVector d = new PVector(x, y + resolution/2);
                int state = states[i][j];
                PVector nw = new PVector(x, y);
                PVector ne = new PVector(x + resolution, y);
                PVector sw = new PVector(x, y + resolution);
                PVector se = new PVector(x + resolution, y + resolution);
                switch (state) {
                    case 1:
                        drawTriangle(sw, c, d, 80, 75, 75);
                        drawLine(c, d);
                        break;
                    case 2:
                        drawTriangle(se, b, c, 80, 75, 75);
                        drawLine(b, c);
                        break;
                    case 3:
                        drawRect(d, se, 80, 75, 75);
                        drawLine(b, d);
                        break;
                    case 4:
                        drawTriangle(ne, a, b, 80, 75, 75);
                        drawLine(a, b);
                        break;
                    case 5:
                        drawRect(nw, se, 80, 75, 75);
                        drawTriangle(nw, a, d, 0, 152, 0);
                        drawTriangle(se, b, c, 0, 152, 0);
                        drawLine(a, d);
                        drawLine(b, c);
                        break;
                    case 6:
                        drawRect(a, se, 80, 75, 75);
                        drawLine(a, c);
                        break;
                    case 7:
                        drawRect(nw, se, 80, 75, 75);
                        drawTriangle(nw, a, d, 0, 152, 0);
                        drawLine(a, d);
                        break;
                    case 8:
                        drawTriangle(nw, a, d, 80, 75, 75);
                        drawLine(a, d);
                        break;
                    case 9:
                        drawRect(nw, c, 80, 75, 75);
                        drawLine(a, c);
                        break;
                    case 10:
                        drawRect(nw, se, 80, 75, 75);
                        drawTriangle(ne, a, b, 0, 152, 0);
                        drawTriangle(sw, c, d, 0, 152, 0);
                        drawLine(a, b);
                        drawLine(c, d);
                        break;
                    case 11:
                        drawRect(nw, se, 80, 75, 75);
                        drawTriangle(ne, a, b, 0, 152, 0);
                        drawLine(a, b);
                        break;
                    case 12:
                        drawRect(nw, b, 80, 75, 75);
                        drawLine(b, d);
                        break;
                    case 13:
                        drawRect(nw, se, 80, 75, 75);
                        drawTriangle(se, b, c, 0, 152, 0);
                        drawLine(b, c);
                        break;
                    case 14:
                        drawRect(nw, se, 80, 75, 75);
                        drawTriangle(sw, c, d, 0, 152, 0);
                        drawLine(c, d);
                        break;
                    case 15:
                        drawRect(nw, se, 80, 75, 75);
                        break;
                }
            }
        }
        // Draw grid of boolean points
        // for (int i = 0; i <= cols; i++) {
        //     for (int j = 0; j <= rows; j++) {
        //         if (field[i][j] == 1) {
        //             fill(255, 255, 255);
        //         } else {
        //             fill(0, 0, 0);
        //         }
        //         ellipse(i * resolution, j * resolution, resolution/3, resolution/3);
        //     }
        // }
        drawEdges();
        drawDecorations();
    }

    // Generate the map following a marching squares protocol
    void generate() {
        for (int i = 0; i <= cols; i++) {
            for (int j = 0; j <= rows; j++) {
                field[i][j] = Math.round(random(1));
                if ((field[i][j] == 0) && (i > 0) && (j > 0) && (i < cols) && (j < rows)) {
                    grassPoints.add(new PVector(i * resolution, j * resolution));
                }
            }
        }

        // For each square, convert the state of it's four corners from binary to decimal
        for (int i = 0; i < cols; i++) {
            for (int j = 0; j < rows; j++) {
                states[i][j] = getState(field[i][j], field[i+1][j], field[i+1][j+1], field[i][j+1]);
            }
        }
        
        // Place decorations in valid positions throughout the map
        for (int i = 0; i < numDecorations; i++) {
            int decorationType = (int) random(5);
            if (decorationType >= 3) {
                decorationType = 1;
            }
            PVector decorationPosition = getRandom(grassPoints);
            decorations[i] = new Decoration(decorationSize, decorationPosition, decorationType, decorationOffset);
            boolean valid = true;
            for (int j = 0; j < i; j++) {
                if (decorations[i].intersects(decorations[j])) {
                    valid = false;
                }
            }
            while (!valid) {
                decorationPosition = getRandom(grassPoints);
                decorations[i] = new Decoration(decorationSize, decorationPosition, decorationType, decorationOffset);
                valid = true;
                for (int j = 0; j < i; j++) {
                    if (decorations[i].intersects(decorations[j])) {
                        valid = false;
                    }
                }
            }
        }
    }

    // Convert binary to decimal
    int getState(int a, int b, int c, int d) {
        return a*8 + b*4 + c*2 + d;
    }

    // Draw a triangle
    void drawTriangle(PVector a, PVector b, PVector c, int red, int green, int blue) {
        fill(red, green, blue);
        noStroke();
        triangle(a.x, a.y, b.x, b.y, c.x, c.y);
    }

    // Draw a rectangle
    void drawRect(PVector nw, PVector se, int red, int green, int blue) {
        fill(red, green, blue);
        noStroke();
        rect(nw.x, nw.y, se.x - nw.x, se.y - nw.y);
    }

    // Draw a line
    void drawLine(PVector a, PVector b) {
        stroke(255, 255, 255);
        strokeWeight(1);
        line(a.x, a.y, b.x, b.y);
        noStroke();
    }

    // Draw the edges of the map
    void drawEdges() {
        stroke(255, 255, 255);
        strokeWeight(3);
        line(0, 0, gameWidth, 0);
        line(0, 0, 0, gameHeight);
        line(gameWidth, 0, gameWidth, gameHeight);
        line(0, gameHeight, gameWidth, gameHeight);
        noStroke();
    }

    // Draw the decorations
    void drawDecorations() {
        for (Decoration decoration : decorations) {
            decoration.draw();
        }
    }

    // Calculate the closest boolean point to a position on the map
    int closestPoint(PVector point) {
        int x = round(point.x / resolution);
        int y = round(point.y / resolution);
        return field[x][y];
    }

    // Get a random element from an array list of PVectors
    PVector getRandom(ArrayList<PVector> array) {
        int randomIndex = (int) random(array.size());
        return array.get(randomIndex);
    }   
}