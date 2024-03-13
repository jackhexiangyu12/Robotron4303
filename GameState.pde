public final class GameStates {
    
    // Instantiate the game state variables
    int phase; // 0 is Homepage, 1 is Guide, 2 is CarSelect, 3 is ItemShop, 4 is PreWave, 5 is Wave, 6 is PostWave, 7 is Paused, 8 is GameOver, 9 is ItemGuide, and 10 is Stats
    int lastPhase;

    // Constructor initialises all class variables
    GameStates() {
        this.phase = 0;
        this.lastPhase = 0;
    }

    // Update the current phase and last phase
    void transition(int newPhase) {
        lastPhase = phase;
        phase = newPhase;
    }

    // Transition to home page
    void visitHomepage() {
        transition(0);
    }

    // Transition to guide
    void visitGuide() {
        transition(1);
    }

    // Transition to car select
    void visitCarSelect() {
        transition(2);
    }

    // Transition to item shop
    void visitItemShop() {
        transition(3);
    }

    // Transition to prewave
    void visitPreWave() {
        transition(4);
    }

    // Transition to wave
    void visitWave() {
        transition(5);
    }

    // Transition to postwave
    void visitPostWave() {
        transition(6);
    }

    // Transition to paused
    void visitPaused() {
        transition(7);
    }

    // Transition to game over
    void visitEndgame() {
        transition(8);
    }

    // Transition to item guide
    void visitItemGuide() {
        transition(9);
    }

    // Transition to stats page
    void visitStats() {
        transition(10);
    }

    // Transition back to previous state
    void previous() {
        transition(lastPhase);
    }
}