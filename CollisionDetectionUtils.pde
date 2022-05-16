public class CollisionDetectionUtils {

    // Constructor initialises an instance of the CollisionDetectionUtils class
    CollisionDetectionUtils() {

    }

    // Collision detection between two rotated rectangles using Separated Axis Theorem
    boolean rectCollisionDetection(PVector rectOnePosition, int rectOneWidth, int rectOneHeight, float rectOneOrientation,
            PVector rectTwoPosition, int rectTwoWidth, int rectTwoHeight, float rectTwoOrientation) {
        
        // Get the four corners of the first rectangle
        PVector rectOneTopLeft = new PVector(rectOnePosition.x + ((rectOneWidth/2) * cos(rectOneOrientation)) + ((rectOneHeight/2) * sin(rectOneOrientation)), rectOnePosition.y + ((rectOneWidth/2) * sin(rectOneOrientation)) - ((rectOneHeight/2) * cos(rectOneOrientation)));
        PVector rectOneTopRight = new PVector(rectOnePosition.x + ((rectOneWidth/2) * cos(rectOneOrientation)) - ((rectOneHeight/2) * sin(rectOneOrientation)), rectOnePosition.y + ((rectOneWidth/2) * sin(rectOneOrientation)) + ((rectOneHeight/2) * cos(rectOneOrientation)));
        PVector rectOneBottomLeft = new PVector(rectOnePosition.x - ((rectOneWidth/2) * cos(rectOneOrientation)) + ((rectOneHeight/2) * sin(rectOneOrientation)), rectOnePosition.y - ((rectOneWidth/2) * sin(rectOneOrientation)) - ((rectOneHeight/2) * cos(rectOneOrientation)));
        PVector rectOneBottomRight = new PVector(rectOnePosition.x - ((rectOneWidth/2) * cos(rectOneOrientation)) - ((rectOneHeight/2) * sin(rectOneOrientation)), rectOnePosition.y - ((rectOneWidth/2) * sin(rectOneOrientation)) + ((rectOneHeight/2) * cos(rectOneOrientation)));
        // fill(255, 0, 255);  // Pink
        // ellipse(rectOneTopLeft.x, rectOneTopLeft.y, 10, 10);
        // fill(255, 255, 0);  // Yellow
        // ellipse(rectOneTopRight.x, rectOneTopRight.y, 10, 10);
        // fill(0, 255, 255);  // Cyan
        // ellipse(rectOneBottomLeft.x, rectOneBottomLeft.y, 10, 10);
        // fill(0, 0, 255);    // Blue
        // ellipse(rectOneBottomRight.x, rectOneBottomRight.y, 10, 10);

        // Get the four corners of the second rectangle
        PVector rectTwoTopLeft = new PVector(rectTwoPosition.x + ((rectTwoWidth/2) * cos(rectTwoOrientation)) + ((rectTwoHeight/2) * sin(rectTwoOrientation)), rectTwoPosition.y + ((rectTwoWidth/2) * sin(rectTwoOrientation)) - ((rectTwoHeight/2) * cos(rectTwoOrientation)));
        PVector rectTwoTopRight = new PVector(rectTwoPosition.x + ((rectTwoWidth/2) * cos(rectTwoOrientation)) - ((rectTwoHeight/2) * sin(rectTwoOrientation)), rectTwoPosition.y + ((rectTwoWidth/2) * sin(rectTwoOrientation)) + ((rectTwoHeight/2) * cos(rectTwoOrientation)));
        PVector rectTwoBottomLeft = new PVector(rectTwoPosition.x - ((rectTwoWidth/2) * cos(rectTwoOrientation)) + ((rectTwoHeight/2) * sin(rectTwoOrientation)), rectTwoPosition.y - ((rectTwoWidth/2) * sin(rectTwoOrientation)) - ((rectTwoHeight/2) * cos(rectTwoOrientation)));
        PVector rectTwoBottomRight = new PVector(rectTwoPosition.x - ((rectTwoWidth/2) * cos(rectTwoOrientation)) - ((rectTwoHeight/2) * sin(rectTwoOrientation)), rectTwoPosition.y - ((rectTwoWidth/2) * sin(rectTwoOrientation)) + ((rectTwoHeight/2) * cos(rectTwoOrientation)));
        // fill(255, 0, 255);  // Pink
        // ellipse(rectTwoTopLeft.x, rectTwoTopLeft.y, 10, 10);
        // fill(255, 255, 0);  // Yellow
        // ellipse(rectTwoTopRight.x, rectTwoTopRight.y, 10, 10);
        // fill(0, 255, 255);  // Cyan
        // ellipse(rectTwoBottomLeft.x, rectTwoBottomLeft.y, 10, 10);
        // fill(0, 0, 255);    // Blue
        // ellipse(rectTwoBottomRight.x, rectTwoBottomRight.y, 10, 10);

        // Calculate the four axes
        PVector rectOneAxisX = new PVector(rectOneTopRight.x - rectOneTopLeft.x, rectOneTopRight.y - rectOneTopLeft.y);
        PVector rectOneAxisY = new PVector(rectOneTopRight.x - rectOneBottomRight.x, rectOneTopRight.y - rectOneBottomRight.y);
        PVector rectTwoAxisX = new PVector(rectTwoTopRight.x - rectTwoTopLeft.x, rectTwoTopRight.y - rectTwoTopLeft.y);
        PVector rectTwoAxisY = new PVector(rectTwoTopRight.x - rectTwoBottomRight.x, rectTwoTopRight.y - rectTwoBottomRight.y);

        // Normalise the axes
        rectOneAxisX.normalize();
        rectOneAxisY.normalize();
        rectTwoAxisX.normalize();
        rectTwoAxisY.normalize();

        // Project all four corners of each rectangle onto rectOneAxisX
        float rectOneTopLeftProjectionRectOneAxisXx = ((rectOneTopLeft.x * rectOneAxisX.x) + (rectOneTopLeft.y * rectOneAxisX.y)) / (pow(rectOneAxisX.x, 2) + pow(rectOneAxisX.y, 2)) * rectOneAxisX.x;
        float rectOneTopLeftProjectionRectOneAxisXy = ((rectOneTopLeft.x * rectOneAxisX.x) + (rectOneTopLeft.y * rectOneAxisX.y)) / (pow(rectOneAxisX.x, 2) + pow(rectOneAxisX.y, 2)) * rectOneAxisX.y;
        PVector rectOneTopLeftProjectionRectOneAxisX = new PVector(rectOneTopLeftProjectionRectOneAxisXx, rectOneTopLeftProjectionRectOneAxisXy);
        float rectOneTopRightProjectionRectOneAxisXx = ((rectOneTopRight.x * rectOneAxisX.x) + (rectOneTopRight.y * rectOneAxisX.y)) / (pow(rectOneAxisX.x, 2) + pow(rectOneAxisX.y, 2)) * rectOneAxisX.x;
        float rectOneTopRightProjectionRectOneAxisXy = ((rectOneTopRight.x * rectOneAxisX.x) + (rectOneTopRight.y * rectOneAxisX.y)) / (pow(rectOneAxisX.x, 2) + pow(rectOneAxisX.y, 2)) * rectOneAxisX.y;
        PVector rectOneTopRightProjectionRectOneAxisX = new PVector(rectOneTopRightProjectionRectOneAxisXx, rectOneTopRightProjectionRectOneAxisXy);
        float rectOneBottomLeftProjectionRectOneAxisXx = ((rectOneBottomLeft.x * rectOneAxisX.x) + (rectOneBottomLeft.y * rectOneAxisX.y)) / (pow(rectOneAxisX.x, 2) + pow(rectOneAxisX.y, 2)) * rectOneAxisX.x;
        float rectOneBottomLeftProjectionRectOneAxisXy = ((rectOneBottomLeft.x * rectOneAxisX.x) + (rectOneBottomLeft.y * rectOneAxisX.y)) / (pow(rectOneAxisX.x, 2) + pow(rectOneAxisX.y, 2)) * rectOneAxisX.y;
        PVector rectOneBottomLeftProjectionRectOneAxisX = new PVector(rectOneBottomLeftProjectionRectOneAxisXx, rectOneBottomLeftProjectionRectOneAxisXy);
        float rectOneBottomRightProjectionRectOneAxisXx = ((rectOneBottomRight.x * rectOneAxisX.x) + (rectOneBottomRight.y * rectOneAxisX.y)) / (pow(rectOneAxisX.x, 2) + pow(rectOneAxisX.y, 2)) * rectOneAxisX.x;
        float rectOneBottomRightProjectionRectOneAxisXy = ((rectOneBottomRight.x * rectOneAxisX.x) + (rectOneBottomRight.y * rectOneAxisX.y)) / (pow(rectOneAxisX.x, 2) + pow(rectOneAxisX.y, 2)) * rectOneAxisX.y;
        PVector rectOneBottomRightProjectionRectOneAxisX = new PVector(rectOneBottomRightProjectionRectOneAxisXx, rectOneBottomRightProjectionRectOneAxisXy);

        float rectTwoTopLeftProjectionRectOneAxisXx = ((rectTwoTopLeft.x * rectOneAxisX.x) + (rectTwoTopLeft.y * rectOneAxisX.y)) / (pow(rectOneAxisX.x, 2) + pow(rectOneAxisX.y, 2)) * rectOneAxisX.x;
        float rectTwoTopLeftProjectionRectOneAxisXy = ((rectTwoTopLeft.x * rectOneAxisX.x) + (rectTwoTopLeft.y * rectOneAxisX.y)) / (pow(rectOneAxisX.x, 2) + pow(rectOneAxisX.y, 2)) * rectOneAxisX.y;
        PVector rectTwoTopLeftProjectionRectOneAxisX = new PVector(rectTwoTopLeftProjectionRectOneAxisXx, rectTwoTopLeftProjectionRectOneAxisXy);
        float rectTwoTopRightProjectionRectOneAxisXx = ((rectTwoTopRight.x * rectOneAxisX.x) + (rectTwoTopRight.y * rectOneAxisX.y)) / (pow(rectOneAxisX.x, 2) + pow(rectOneAxisX.y, 2)) * rectOneAxisX.x;
        float rectTwoTopRightProjectionRectOneAxisXy = ((rectTwoTopRight.x * rectOneAxisX.x) + (rectTwoTopRight.y * rectOneAxisX.y)) / (pow(rectOneAxisX.x, 2) + pow(rectOneAxisX.y, 2)) * rectOneAxisX.y;
        PVector rectTwoTopRightProjectionRectOneAxisX = new PVector(rectTwoTopRightProjectionRectOneAxisXx, rectTwoTopRightProjectionRectOneAxisXy);
        float rectTwoBottomLeftProjectionRectOneAxisXx = ((rectTwoBottomLeft.x * rectOneAxisX.x) + (rectTwoBottomLeft.y * rectOneAxisX.y)) / (pow(rectOneAxisX.x, 2) + pow(rectOneAxisX.y, 2)) * rectOneAxisX.x;
        float rectTwoBottomLeftProjectionRectOneAxisXy = ((rectTwoBottomLeft.x * rectOneAxisX.x) + (rectTwoBottomLeft.y * rectOneAxisX.y)) / (pow(rectOneAxisX.x, 2) + pow(rectOneAxisX.y, 2)) * rectOneAxisX.y;
        PVector rectTwoBottomLeftProjectionRectOneAxisX = new PVector(rectTwoBottomLeftProjectionRectOneAxisXx, rectTwoBottomLeftProjectionRectOneAxisXy);
        float rectTwoBottomRightProjectionRectOneAxisXx = ((rectTwoBottomRight.x * rectOneAxisX.x) + (rectTwoBottomRight.y * rectOneAxisX.y)) / (pow(rectOneAxisX.x, 2) + pow(rectOneAxisX.y, 2)) * rectOneAxisX.x;
        float rectTwoBottomRightProjectionRectOneAxisXy = ((rectTwoBottomRight.x * rectOneAxisX.x) + (rectTwoBottomRight.y * rectOneAxisX.y)) / (pow(rectOneAxisX.x, 2) + pow(rectOneAxisX.y, 2)) * rectOneAxisX.y;
        PVector rectTwoBottomRightProjectionRectOneAxisX = new PVector(rectTwoBottomRightProjectionRectOneAxisXx, rectTwoBottomRightProjectionRectOneAxisXy);

        // Calculate the dot products between each projection and rectOneAxisY
        float rectOneTopLeftProjectionDotRectOneAxisX = rectOneTopLeftProjectionRectOneAxisX.dot(rectOneAxisX);
        float rectOneTopRightProjectionDotRectOneAxisX = rectOneTopRightProjectionRectOneAxisX.dot(rectOneAxisX);
        float rectOneBottomLeftProjectionDotRectOneAxisX = rectOneBottomLeftProjectionRectOneAxisX.dot(rectOneAxisX);
        float rectOneBottomRightProjectionDotRectOneAxisX = rectOneBottomRightProjectionRectOneAxisX.dot(rectOneAxisX);

        float rectTwoTopLeftProjectionDotRectOneAxisX = rectTwoTopLeftProjectionRectOneAxisX.dot(rectOneAxisX);
        float rectTwoTopRightProjectionDotRectOneAxisX = rectTwoTopRightProjectionRectOneAxisX.dot(rectOneAxisX);
        float rectTwoBottomLeftProjectionDotRectOneAxisX = rectTwoBottomLeftProjectionRectOneAxisX.dot(rectOneAxisX);
        float rectTwoBottomRightProjectionDotRectOneAxisX = rectTwoBottomRightProjectionRectOneAxisX.dot(rectOneAxisX);

        // Identify the maximum and minimum values of each of the comparators
        float rectOneMaxRectOneAxisX = getMax(rectOneTopLeftProjectionDotRectOneAxisX, rectOneTopRightProjectionDotRectOneAxisX, rectOneBottomLeftProjectionDotRectOneAxisX, rectOneBottomRightProjectionDotRectOneAxisX);
        float rectOneMinRectOneAxisX = getMin(rectOneTopLeftProjectionDotRectOneAxisX, rectOneTopRightProjectionDotRectOneAxisX, rectOneBottomLeftProjectionDotRectOneAxisX, rectOneBottomRightProjectionDotRectOneAxisX);
        float rectTwoMaxRectOneAxisX = getMax(rectTwoTopLeftProjectionDotRectOneAxisX, rectTwoTopRightProjectionDotRectOneAxisX, rectTwoBottomLeftProjectionDotRectOneAxisX, rectTwoBottomRightProjectionDotRectOneAxisX);
        float rectTwoMinRectOneAxisX = getMin(rectTwoTopLeftProjectionDotRectOneAxisX, rectTwoTopRightProjectionDotRectOneAxisX, rectTwoBottomLeftProjectionDotRectOneAxisX, rectTwoBottomRightProjectionDotRectOneAxisX);

        // If the two rectangles do not overlap on rectOneAxisX, return false
        if (!((rectTwoMinRectOneAxisX < rectOneMaxRectOneAxisX) && (rectTwoMaxRectOneAxisX > rectOneMinRectOneAxisX))) {
            return false;
        }

        // Project all four corners of each rectangle onto rectOneAxisY
        float rectOneTopLeftProjectionRectOneAxisYx = ((rectOneTopLeft.x * rectOneAxisY.x) + (rectOneTopLeft.y * rectOneAxisY.y)) / (pow(rectOneAxisY.x, 2) + pow(rectOneAxisY.y, 2)) * rectOneAxisY.x;
        float rectOneTopLeftProjectionRectOneAxisYy = ((rectOneTopLeft.x * rectOneAxisY.x) + (rectOneTopLeft.y * rectOneAxisY.y)) / (pow(rectOneAxisY.x, 2) + pow(rectOneAxisY.y, 2)) * rectOneAxisY.y;
        PVector rectOneTopLeftProjectionRectOneAxisY = new PVector(rectOneTopLeftProjectionRectOneAxisYx, rectOneTopLeftProjectionRectOneAxisYy);
        float rectOneTopRightProjectionRectOneAxisYx = ((rectOneTopRight.x * rectOneAxisY.x) + (rectOneTopRight.y * rectOneAxisY.y)) / (pow(rectOneAxisY.x, 2) + pow(rectOneAxisY.y, 2)) * rectOneAxisY.x;
        float rectOneTopRightProjectionRectOneAxisYy = ((rectOneTopRight.x * rectOneAxisY.x) + (rectOneTopRight.y * rectOneAxisY.y)) / (pow(rectOneAxisY.x, 2) + pow(rectOneAxisY.y, 2)) * rectOneAxisY.y;
        PVector rectOneTopRightProjectionRectOneAxisY = new PVector(rectOneTopRightProjectionRectOneAxisYx, rectOneTopRightProjectionRectOneAxisYy);
        float rectOneBottomLeftProjectionRectOneAxisYx = ((rectOneBottomLeft.x * rectOneAxisY.x) + (rectOneBottomLeft.y * rectOneAxisY.y)) / (pow(rectOneAxisY.x, 2) + pow(rectOneAxisY.y, 2)) * rectOneAxisY.x;
        float rectOneBottomLeftProjectionRectOneAxisYy = ((rectOneBottomLeft.x * rectOneAxisY.x) + (rectOneBottomLeft.y * rectOneAxisY.y)) / (pow(rectOneAxisY.x, 2) + pow(rectOneAxisY.y, 2)) * rectOneAxisY.y;
        PVector rectOneBottomLeftProjectionRectOneAxisY = new PVector(rectOneBottomLeftProjectionRectOneAxisYx, rectOneBottomLeftProjectionRectOneAxisYy);
        float rectOneBottomRightProjectionRectOneAxisYx = ((rectOneBottomRight.x * rectOneAxisY.x) + (rectOneBottomRight.y * rectOneAxisY.y)) / (pow(rectOneAxisY.x, 2) + pow(rectOneAxisY.y, 2)) * rectOneAxisY.x;
        float rectOneBottomRightProjectionRectOneAxisYy = ((rectOneBottomRight.x * rectOneAxisY.x) + (rectOneBottomRight.y * rectOneAxisY.y)) / (pow(rectOneAxisY.x, 2) + pow(rectOneAxisY.y, 2)) * rectOneAxisY.y;
        PVector rectOneBottomRightProjectionRectOneAxisY = new PVector(rectOneBottomRightProjectionRectOneAxisYx, rectOneBottomRightProjectionRectOneAxisYy);

        float rectTwoTopLeftProjectionRectOneAxisYx = ((rectTwoTopLeft.x * rectOneAxisY.x) + (rectTwoTopLeft.y * rectOneAxisY.y)) / (pow(rectOneAxisY.x, 2) + pow(rectOneAxisY.y, 2)) * rectOneAxisY.x;
        float rectTwoTopLeftProjectionRectOneAxisYy = ((rectTwoTopLeft.x * rectOneAxisY.x) + (rectTwoTopLeft.y * rectOneAxisY.y)) / (pow(rectOneAxisY.x, 2) + pow(rectOneAxisY.y, 2)) * rectOneAxisY.y;
        PVector rectTwoTopLeftProjectionRectOneAxisY = new PVector(rectTwoTopLeftProjectionRectOneAxisYx, rectTwoTopLeftProjectionRectOneAxisYy);
        float rectTwoTopRightProjectionRectOneAxisYx = ((rectTwoTopRight.x * rectOneAxisY.x) + (rectTwoTopRight.y * rectOneAxisY.y)) / (pow(rectOneAxisY.x, 2) + pow(rectOneAxisY.y, 2)) * rectOneAxisY.x;
        float rectTwoTopRightProjectionRectOneAxisYy = ((rectTwoTopRight.x * rectOneAxisY.x) + (rectTwoTopRight.y * rectOneAxisY.y)) / (pow(rectOneAxisY.x, 2) + pow(rectOneAxisY.y, 2)) * rectOneAxisY.y;
        PVector rectTwoTopRightProjectionRectOneAxisY = new PVector(rectTwoTopRightProjectionRectOneAxisYx, rectTwoTopRightProjectionRectOneAxisYy);
        float rectTwoBottomLeftProjectionRectOneAxisYx = ((rectTwoBottomLeft.x * rectOneAxisY.x) + (rectTwoBottomLeft.y * rectOneAxisY.y)) / (pow(rectOneAxisY.x, 2) + pow(rectOneAxisY.y, 2)) * rectOneAxisY.x;
        float rectTwoBottomLeftProjectionRectOneAxisYy = ((rectTwoBottomLeft.x * rectOneAxisY.x) + (rectTwoBottomLeft.y * rectOneAxisY.y)) / (pow(rectOneAxisY.x, 2) + pow(rectOneAxisY.y, 2)) * rectOneAxisY.y;
        PVector rectTwoBottomLeftProjectionRectOneAxisY = new PVector(rectTwoBottomLeftProjectionRectOneAxisYx, rectTwoBottomLeftProjectionRectOneAxisYy);
        float rectTwoBottomRightProjectionRectOneAxisYx = ((rectTwoBottomRight.x * rectOneAxisY.x) + (rectTwoBottomRight.y * rectOneAxisY.y)) / (pow(rectOneAxisY.x, 2) + pow(rectOneAxisY.y, 2)) * rectOneAxisY.x;
        float rectTwoBottomRightProjectionRectOneAxisYy = ((rectTwoBottomRight.x * rectOneAxisY.x) + (rectTwoBottomRight.y * rectOneAxisY.y)) / (pow(rectOneAxisY.x, 2) + pow(rectOneAxisY.y, 2)) * rectOneAxisY.y;
        PVector rectTwoBottomRightProjectionRectOneAxisY = new PVector(rectTwoBottomRightProjectionRectOneAxisYx, rectTwoBottomRightProjectionRectOneAxisYy);
        
        // Calculate the dot products between each projection and rectOneAxisY
        float rectOneTopLeftProjectionDotRectOneAxisY = rectOneTopLeftProjectionRectOneAxisY.dot(rectOneAxisY);
        float rectOneTopRightProjectionDotRectOneAxisY = rectOneTopRightProjectionRectOneAxisY.dot(rectOneAxisY);
        float rectOneBottomLeftProjectionDotRectOneAxisY = rectOneBottomLeftProjectionRectOneAxisY.dot(rectOneAxisY);
        float rectOneBottomRightProjectionDotRectOneAxisY = rectOneBottomRightProjectionRectOneAxisY.dot(rectOneAxisY);

        float rectTwoTopLeftProjectionDotRectOneAxisY = rectTwoTopLeftProjectionRectOneAxisY.dot(rectOneAxisY);
        float rectTwoTopRightProjectionDotRectOneAxisY = rectTwoTopRightProjectionRectOneAxisY.dot(rectOneAxisY);
        float rectTwoBottomLeftProjectionDotRectOneAxisY = rectTwoBottomLeftProjectionRectOneAxisY.dot(rectOneAxisY);
        float rectTwoBottomRightProjectionDotRectOneAxisY = rectTwoBottomRightProjectionRectOneAxisY.dot(rectOneAxisY);

        // Identify the maximum and minimum values of each of the comparators
        float rectOneMaxRectOneAxisY = getMax(rectOneTopLeftProjectionDotRectOneAxisY, rectOneTopRightProjectionDotRectOneAxisY, rectOneBottomLeftProjectionDotRectOneAxisY, rectOneBottomRightProjectionDotRectOneAxisY);
        float rectOneMinRectOneAxisY = getMin(rectOneTopLeftProjectionDotRectOneAxisY, rectOneTopRightProjectionDotRectOneAxisY, rectOneBottomLeftProjectionDotRectOneAxisY, rectOneBottomRightProjectionDotRectOneAxisY);
        float rectTwoMaxRectOneAxisY = getMax(rectTwoTopLeftProjectionDotRectOneAxisY, rectTwoTopRightProjectionDotRectOneAxisY, rectTwoBottomLeftProjectionDotRectOneAxisY, rectTwoBottomRightProjectionDotRectOneAxisY);
        float rectTwoMinRectOneAxisY = getMin(rectTwoTopLeftProjectionDotRectOneAxisY, rectTwoTopRightProjectionDotRectOneAxisY, rectTwoBottomLeftProjectionDotRectOneAxisY, rectTwoBottomRightProjectionDotRectOneAxisY);

        // If the two rectangles do not overlap on rectOneAxisY, return false
        if (!((rectTwoMinRectOneAxisY < rectOneMaxRectOneAxisY) && (rectTwoMaxRectOneAxisY > rectOneMinRectOneAxisY))) {
            return false;
        }

        // Project all four corners of each rectangle onto rectTwoAxisX
        float rectOneTopLeftProjectionRectTwoAxisXx = ((rectOneTopLeft.x * rectTwoAxisX.x) + (rectOneTopLeft.y * rectTwoAxisX.y)) / (pow(rectTwoAxisX.x, 2) + pow(rectTwoAxisX.y, 2)) * rectTwoAxisX.x;
        float rectOneTopLeftProjectionRectTwoAxisXy = ((rectOneTopLeft.x * rectTwoAxisX.x) + (rectOneTopLeft.y * rectTwoAxisX.y)) / (pow(rectTwoAxisX.x, 2) + pow(rectTwoAxisX.y, 2)) * rectTwoAxisX.y;
        PVector rectOneTopLeftProjectionRectTwoAxisX = new PVector(rectOneTopLeftProjectionRectTwoAxisXx, rectOneTopLeftProjectionRectTwoAxisXy);
        float rectOneTopRightProjectionRectTwoAxisXx = ((rectOneTopRight.x * rectTwoAxisX.x) + (rectOneTopRight.y * rectTwoAxisX.y)) / (pow(rectTwoAxisX.x, 2) + pow(rectTwoAxisX.y, 2)) * rectTwoAxisX.x;
        float rectOneTopRightProjectionRectTwoAxisXy = ((rectOneTopRight.x * rectTwoAxisX.x) + (rectOneTopRight.y * rectTwoAxisX.y)) / (pow(rectTwoAxisX.x, 2) + pow(rectTwoAxisX.y, 2)) * rectTwoAxisX.y;
        PVector rectOneTopRightProjectionRectTwoAxisX = new PVector(rectOneTopRightProjectionRectTwoAxisXx, rectOneTopRightProjectionRectTwoAxisXy);
        float rectOneBottomLeftProjectionRectTwoAxisXx = ((rectOneBottomLeft.x * rectTwoAxisX.x) + (rectOneBottomLeft.y * rectTwoAxisX.y)) / (pow(rectTwoAxisX.x, 2) + pow(rectTwoAxisX.y, 2)) * rectTwoAxisX.x;
        float rectOneBottomLeftProjectionRectTwoAxisXy = ((rectOneBottomLeft.x * rectTwoAxisX.x) + (rectOneBottomLeft.y * rectTwoAxisX.y)) / (pow(rectTwoAxisX.x, 2) + pow(rectTwoAxisX.y, 2)) * rectTwoAxisX.y;
        PVector rectOneBottomLeftProjectionRectTwoAxisX = new PVector(rectOneBottomLeftProjectionRectTwoAxisXx, rectOneBottomLeftProjectionRectTwoAxisXy);
        float rectOneBottomRightProjectionRectTwoAxisXx = ((rectOneBottomRight.x * rectTwoAxisX.x) + (rectOneBottomRight.y * rectTwoAxisX.y)) / (pow(rectTwoAxisX.x, 2) + pow(rectTwoAxisX.y, 2)) * rectTwoAxisX.x;
        float rectOneBottomRightProjectionRectTwoAxisXy = ((rectOneBottomRight.x * rectTwoAxisX.x) + (rectOneBottomRight.y * rectTwoAxisX.y)) / (pow(rectTwoAxisX.x, 2) + pow(rectTwoAxisX.y, 2)) * rectTwoAxisX.y;
        PVector rectOneBottomRightProjectionRectTwoAxisX = new PVector(rectOneBottomRightProjectionRectTwoAxisXx, rectOneBottomRightProjectionRectTwoAxisXy);

        float rectTwoTopLeftProjectionRectTwoAxisXx = ((rectTwoTopLeft.x * rectTwoAxisX.x) + (rectTwoTopLeft.y * rectTwoAxisX.y)) / (pow(rectTwoAxisX.x, 2) + pow(rectTwoAxisX.y, 2)) * rectTwoAxisX.x;
        float rectTwoTopLeftProjectionRectTwoAxisXy = ((rectTwoTopLeft.x * rectTwoAxisX.x) + (rectTwoTopLeft.y * rectTwoAxisX.y)) / (pow(rectTwoAxisX.x, 2) + pow(rectTwoAxisX.y, 2)) * rectTwoAxisX.y;
        PVector rectTwoTopLeftProjectionRectTwoAxisX = new PVector(rectTwoTopLeftProjectionRectTwoAxisXx, rectTwoTopLeftProjectionRectTwoAxisXy);
        float rectTwoTopRightProjectionRectTwoAxisXx = ((rectTwoTopRight.x * rectTwoAxisX.x) + (rectTwoTopRight.y * rectTwoAxisX.y)) / (pow(rectTwoAxisX.x, 2) + pow(rectTwoAxisX.y, 2)) * rectTwoAxisX.x;
        float rectTwoTopRightProjectionRectTwoAxisXy = ((rectTwoTopRight.x * rectTwoAxisX.x) + (rectTwoTopRight.y * rectTwoAxisX.y)) / (pow(rectTwoAxisX.x, 2) + pow(rectTwoAxisX.y, 2)) * rectTwoAxisX.y;
        PVector rectTwoTopRightProjectionRectTwoAxisX = new PVector(rectTwoTopRightProjectionRectTwoAxisXx, rectTwoTopRightProjectionRectTwoAxisXy);
        float rectTwoBottomLeftProjectionRectTwoAxisXx = ((rectTwoBottomLeft.x * rectTwoAxisX.x) + (rectTwoBottomLeft.y * rectTwoAxisX.y)) / (pow(rectTwoAxisX.x, 2) + pow(rectTwoAxisX.y, 2)) * rectTwoAxisX.x;
        float rectTwoBottomLeftProjectionRectTwoAxisXy = ((rectTwoBottomLeft.x * rectTwoAxisX.x) + (rectTwoBottomLeft.y * rectTwoAxisX.y)) / (pow(rectTwoAxisX.x, 2) + pow(rectTwoAxisX.y, 2)) * rectTwoAxisX.y;
        PVector rectTwoBottomLeftProjectionRectTwoAxisX = new PVector(rectTwoBottomLeftProjectionRectTwoAxisXx, rectTwoBottomLeftProjectionRectTwoAxisXy);
        float rectTwoBottomRightProjectionRectTwoAxisXx = ((rectTwoBottomRight.x * rectTwoAxisX.x) + (rectTwoBottomRight.y * rectTwoAxisX.y)) / (pow(rectTwoAxisX.x, 2) + pow(rectTwoAxisX.y, 2)) * rectTwoAxisX.x;
        float rectTwoBottomRightProjectionRectTwoAxisXy = ((rectTwoBottomRight.x * rectTwoAxisX.x) + (rectTwoBottomRight.y * rectTwoAxisX.y)) / (pow(rectTwoAxisX.x, 2) + pow(rectTwoAxisX.y, 2)) * rectTwoAxisX.y;
        PVector rectTwoBottomRightProjectionRectTwoAxisX = new PVector(rectTwoBottomRightProjectionRectTwoAxisXx, rectTwoBottomRightProjectionRectTwoAxisXy);

        // Calculate the dot products between each projection and rectTwoAxisX
        float rectOneTopLeftProjectionDotRectTwoAxisX = rectOneTopLeftProjectionRectTwoAxisX.dot(rectTwoAxisX);
        float rectOneTopRightProjectionDotRectTwoAxisX = rectOneTopRightProjectionRectTwoAxisX.dot(rectTwoAxisX);
        float rectOneBottomLeftProjectionDotRectTwoAxisX = rectOneBottomLeftProjectionRectTwoAxisX.dot(rectTwoAxisX);
        float rectOneBottomRightProjectionDotRectTwoAxisX = rectOneBottomRightProjectionRectTwoAxisX.dot(rectTwoAxisX);

        float rectTwoTopLeftProjectionDotRectTwoAxisX = rectTwoTopLeftProjectionRectTwoAxisX.dot(rectTwoAxisX);
        float rectTwoTopRightProjectionDotRectTwoAxisX = rectTwoTopRightProjectionRectTwoAxisX.dot(rectTwoAxisX);
        float rectTwoBottomLeftProjectionDotRectTwoAxisX = rectTwoBottomLeftProjectionRectTwoAxisX.dot(rectTwoAxisX);
        float rectTwoBottomRightProjectionDotRectTwoAxisX = rectTwoBottomRightProjectionRectTwoAxisX.dot(rectTwoAxisX);

        // Identify the maximum and minimum values of each of the comparators
        float rectOneMaxRectTwoAxisX = getMax(rectOneTopLeftProjectionDotRectTwoAxisX, rectOneTopRightProjectionDotRectTwoAxisX, rectOneBottomLeftProjectionDotRectTwoAxisX, rectOneBottomRightProjectionDotRectTwoAxisX);
        float rectOneMinRectTwoAxisX = getMin(rectOneTopLeftProjectionDotRectTwoAxisX, rectOneTopRightProjectionDotRectTwoAxisX, rectOneBottomLeftProjectionDotRectTwoAxisX, rectOneBottomRightProjectionDotRectTwoAxisX);
        float rectTwoMaxRectTwoAxisX = getMax(rectTwoTopLeftProjectionDotRectTwoAxisX, rectTwoTopRightProjectionDotRectTwoAxisX, rectTwoBottomLeftProjectionDotRectTwoAxisX, rectTwoBottomRightProjectionDotRectTwoAxisX);
        float rectTwoMinRectTwoAxisX = getMin(rectTwoTopLeftProjectionDotRectTwoAxisX, rectTwoTopRightProjectionDotRectTwoAxisX, rectTwoBottomLeftProjectionDotRectTwoAxisX, rectTwoBottomRightProjectionDotRectTwoAxisX);

        // If the two rectangles do not overlap on rectTwoAxisX, return false
        if (!((rectTwoMinRectTwoAxisX < rectOneMaxRectTwoAxisX) && (rectTwoMaxRectTwoAxisX > rectOneMinRectTwoAxisX))) {
            return false;
        }

        // Project all four corners of each rectangle onto rectTwoAxisY
        float rectOneTopLeftProjectionRectTwoAxisYx = ((rectOneTopLeft.x * rectTwoAxisY.x) + (rectOneTopLeft.y * rectTwoAxisY.y)) / (pow(rectTwoAxisY.x, 2) + pow(rectTwoAxisY.y, 2)) * rectTwoAxisY.x;
        float rectOneTopLeftProjectionRectTwoAxisYy = ((rectOneTopLeft.x * rectTwoAxisY.x) + (rectOneTopLeft.y * rectTwoAxisY.y)) / (pow(rectTwoAxisY.x, 2) + pow(rectTwoAxisY.y, 2)) * rectTwoAxisY.y;
        PVector rectOneTopLeftProjectionRectTwoAxisY = new PVector(rectOneTopLeftProjectionRectTwoAxisYx, rectOneTopLeftProjectionRectTwoAxisYy);
        float rectOneTopRightProjectionRectTwoAxisYx = ((rectOneTopRight.x * rectTwoAxisY.x) + (rectOneTopRight.y * rectTwoAxisY.y)) / (pow(rectTwoAxisY.x, 2) + pow(rectTwoAxisY.y, 2)) * rectTwoAxisY.x;
        float rectOneTopRightProjectionRectTwoAxisYy = ((rectOneTopRight.x * rectTwoAxisY.x) + (rectOneTopRight.y * rectTwoAxisY.y)) / (pow(rectTwoAxisY.x, 2) + pow(rectTwoAxisY.y, 2)) * rectTwoAxisY.y;
        PVector rectOneTopRightProjectionRectTwoAxisY = new PVector(rectOneTopRightProjectionRectTwoAxisYx, rectOneTopRightProjectionRectTwoAxisYy);
        float rectOneBottomLeftProjectionRectTwoAxisYx = ((rectOneBottomLeft.x * rectTwoAxisY.x) + (rectOneBottomLeft.y * rectTwoAxisY.y)) / (pow(rectTwoAxisY.x, 2) + pow(rectTwoAxisY.y, 2)) * rectTwoAxisY.x;
        float rectOneBottomLeftProjectionRectTwoAxisYy = ((rectOneBottomLeft.x * rectTwoAxisY.x) + (rectOneBottomLeft.y * rectTwoAxisY.y)) / (pow(rectTwoAxisY.x, 2) + pow(rectTwoAxisY.y, 2)) * rectTwoAxisY.y;
        PVector rectOneBottomLeftProjectionRectTwoAxisY = new PVector(rectOneBottomLeftProjectionRectTwoAxisYx, rectOneBottomLeftProjectionRectTwoAxisYy);
        float rectOneBottomRightProjectionRectTwoAxisYx = ((rectOneBottomRight.x * rectTwoAxisY.x) + (rectOneBottomRight.y * rectTwoAxisY.y)) / (pow(rectTwoAxisY.x, 2) + pow(rectTwoAxisY.y, 2)) * rectTwoAxisY.x;
        float rectOneBottomRightProjectionRectTwoAxisYy = ((rectOneBottomRight.x * rectTwoAxisY.x) + (rectOneBottomRight.y * rectTwoAxisY.y)) / (pow(rectTwoAxisY.x, 2) + pow(rectTwoAxisY.y, 2)) * rectTwoAxisY.y;
        PVector rectOneBottomRightProjectionRectTwoAxisY = new PVector(rectOneBottomRightProjectionRectTwoAxisYx, rectOneBottomRightProjectionRectTwoAxisYy);

        float rectTwoTopLeftProjectionRectTwoAxisYx = ((rectTwoTopLeft.x * rectTwoAxisY.x) + (rectTwoTopLeft.y * rectTwoAxisY.y)) / (pow(rectTwoAxisY.x, 2) + pow(rectTwoAxisY.y, 2)) * rectTwoAxisY.x;
        float rectTwoTopLeftProjectionRectTwoAxisYy = ((rectTwoTopLeft.x * rectTwoAxisY.x) + (rectTwoTopLeft.y * rectTwoAxisY.y)) / (pow(rectTwoAxisY.x, 2) + pow(rectTwoAxisY.y, 2)) * rectTwoAxisY.y;
        PVector rectTwoTopLeftProjectionRectTwoAxisY = new PVector(rectTwoTopLeftProjectionRectTwoAxisYx, rectTwoTopLeftProjectionRectTwoAxisYy);
        float rectTwoTopRightProjectionRectTwoAxisYx = ((rectTwoTopRight.x * rectTwoAxisY.x) + (rectTwoTopRight.y * rectTwoAxisY.y)) / (pow(rectTwoAxisY.x, 2) + pow(rectTwoAxisY.y, 2)) * rectTwoAxisY.x;
        float rectTwoTopRightProjectionRectTwoAxisYy = ((rectTwoTopRight.x * rectTwoAxisY.x) + (rectTwoTopRight.y * rectTwoAxisY.y)) / (pow(rectTwoAxisY.x, 2) + pow(rectTwoAxisY.y, 2)) * rectTwoAxisY.y;
        PVector rectTwoTopRightProjectionRectTwoAxisY = new PVector(rectTwoTopRightProjectionRectTwoAxisYx, rectTwoTopRightProjectionRectTwoAxisYy);
        float rectTwoBottomLeftProjectionRectTwoAxisYx = ((rectTwoBottomLeft.x * rectTwoAxisY.x) + (rectTwoBottomLeft.y * rectTwoAxisY.y)) / (pow(rectTwoAxisY.x, 2) + pow(rectTwoAxisY.y, 2)) * rectTwoAxisY.x;
        float rectTwoBottomLeftProjectionRectTwoAxisYy = ((rectTwoBottomLeft.x * rectTwoAxisY.x) + (rectTwoBottomLeft.y * rectTwoAxisY.y)) / (pow(rectTwoAxisY.x, 2) + pow(rectTwoAxisY.y, 2)) * rectTwoAxisY.y;
        PVector rectTwoBottomLeftProjectionRectTwoAxisY = new PVector(rectTwoBottomLeftProjectionRectTwoAxisYx, rectTwoBottomLeftProjectionRectTwoAxisYy);
        float rectTwoBottomRightProjectionRectTwoAxisYx = ((rectTwoBottomRight.x * rectTwoAxisY.x) + (rectTwoBottomRight.y * rectTwoAxisY.y)) / (pow(rectTwoAxisY.x, 2) + pow(rectTwoAxisY.y, 2)) * rectTwoAxisY.x;
        float rectTwoBottomRightProjectionRectTwoAxisYy = ((rectTwoBottomRight.x * rectTwoAxisY.x) + (rectTwoBottomRight.y * rectTwoAxisY.y)) / (pow(rectTwoAxisY.x, 2) + pow(rectTwoAxisY.y, 2)) * rectTwoAxisY.y;
        PVector rectTwoBottomRightProjectionRectTwoAxisY = new PVector(rectTwoBottomRightProjectionRectTwoAxisYx, rectTwoBottomRightProjectionRectTwoAxisYy);

        // Calculate the dot products between each projection and rectTwoAxisY
        float rectOneTopLeftProjectionDotRectTwoAxisY = rectOneTopLeftProjectionRectTwoAxisY.dot(rectTwoAxisY);
        float rectOneTopRightProjectionDotRectTwoAxisY = rectOneTopRightProjectionRectTwoAxisY.dot(rectTwoAxisY);
        float rectOneBottomLeftProjectionDotRectTwoAxisY = rectOneBottomLeftProjectionRectTwoAxisY.dot(rectTwoAxisY);
        float rectOneBottomRightProjectionDotRectTwoAxisY = rectOneBottomRightProjectionRectTwoAxisY.dot(rectTwoAxisY);

        float rectTwoTopLeftProjectionDotRectTwoAxisY = rectTwoTopLeftProjectionRectTwoAxisY.dot(rectTwoAxisY);
        float rectTwoTopRightProjectionDotRectTwoAxisY = rectTwoTopRightProjectionRectTwoAxisY.dot(rectTwoAxisY);
        float rectTwoBottomLeftProjectionDotRectTwoAxisY = rectTwoBottomLeftProjectionRectTwoAxisY.dot(rectTwoAxisY);
        float rectTwoBottomRightProjectionDotRectTwoAxisY = rectTwoBottomRightProjectionRectTwoAxisY.dot(rectTwoAxisY);

        // Identify the maximum and minimum values of each of the comparators
        float rectOneMaxRectTwoAxisY = getMax(rectOneTopLeftProjectionDotRectTwoAxisY, rectOneTopRightProjectionDotRectTwoAxisY, rectOneBottomLeftProjectionDotRectTwoAxisY, rectOneBottomRightProjectionDotRectTwoAxisY);
        float rectOneMinRectTwoAxisY = getMin(rectOneTopLeftProjectionDotRectTwoAxisY, rectOneTopRightProjectionDotRectTwoAxisY, rectOneBottomLeftProjectionDotRectTwoAxisY, rectOneBottomRightProjectionDotRectTwoAxisY);
        float rectTwoMaxRectTwoAxisY = getMax(rectTwoTopLeftProjectionDotRectTwoAxisY, rectTwoTopRightProjectionDotRectTwoAxisY, rectTwoBottomLeftProjectionDotRectTwoAxisY, rectTwoBottomRightProjectionDotRectTwoAxisY);
        float rectTwoMinRectTwoAxisY = getMin(rectTwoTopLeftProjectionDotRectTwoAxisY, rectTwoTopRightProjectionDotRectTwoAxisY, rectTwoBottomLeftProjectionDotRectTwoAxisY, rectTwoBottomRightProjectionDotRectTwoAxisY);

        // If the two rectangles do not overlap on rectTwoAxisY, return false
        if (!((rectTwoMinRectTwoAxisY < rectOneMaxRectTwoAxisY) && (rectTwoMaxRectTwoAxisY > rectOneMinRectTwoAxisY))) {
            return false;
        }

        return true;

    }

    // Collision detection between a circle and a rotated rectangle
    boolean circleRectCollisionDetection(PVector circleCentre, float circleSize, PVector rectCentre, int rectWidth, int rectHeight, float rectOrientation) {
        float radius = circleSize / 2;
        rectOrientation = -rectOrientation;
            
        // Rotate the circle about the rectangle centre
        float newCircleCentreX = cos(rectOrientation) * (circleCentre.x - rectCentre.x) - sin(rectOrientation) * (circleCentre.y - rectCentre.y) + rectCentre.x;
        float newCircleCentreY = sin(rectOrientation) * (circleCentre.x - rectCentre.x) + cos(rectOrientation) * (circleCentre.y - rectCentre.y) + rectCentre.y;

        // Find the closest point from the unrotated circle and the rectangle
        float closestX;
        if (newCircleCentreX < rectCentre.x-(rectWidth/2)) {
            closestX = rectCentre.x-(rectWidth/2);
        } else if (newCircleCentreX > rectCentre.x+(rectWidth/2)) {
            closestX = rectCentre.x+(rectWidth/2);
        } else {
            closestX = newCircleCentreX;
        }

        float closestY;
        if (newCircleCentreY < rectCentre.y-(rectHeight/2)) {
            closestY = rectCentre.y-(rectHeight/2);
        } else if (newCircleCentreY > rectCentre.y+(rectHeight/2)) {
            closestY = rectCentre.y+(rectHeight/2);
        } else {
            closestY = newCircleCentreY;
        }

        // If the closest point is within the circle, return true
        if (sqrt(pow(newCircleCentreX - closestX, 2) + pow(newCircleCentreY - closestY, 2)) < radius) {
            return true;
        } else {
            return false;
        }
    }

    // FIX FOR RECTMODE(CENTER) - Unused so not fixed
    boolean pointRectCollision(PVector pointPosition, PVector position, int width, int height) {
        if ((pointPosition.x > position.x+width) || (pointPosition.x < position.x) || (pointPosition.y > position.y+height) || (pointPosition.y < position.y)) {
            return false;
        } else {
            return true;
        }
    }

    // Get the maximum value of four floats
    float getMax(float one, float two, float three, float four) {
        float max = one;
        if (two > max) {
            max = two;
        }
        if (three > max) {
            max = three;
        }
        if (four > max) {
            max = four;
        }
        return max;
    }

    // Get the minimum value of four floats
    float getMin(float one, float two, float three, float four) {
        float min = one;
        if (two < min) {
            min = two;
        }
        if (three < min) {
            min = three;
        }
        if (four < min) {
            min = four;
        }
        return min;
    }

}