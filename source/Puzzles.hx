package;

class Puzzles {

  public static var campaign(get, null): Array<Puzzle>;
 
  private static function get_campaign(): Array<Puzzle> {
    if (campaign == null) {
      campaign = [
        new Puzzle("3x3_blue", AssetPaths.puzzle_3x3_blue__png)
          .setCards(1, 12)
          .setNumWheels(0)
          .setFeatures([])
          .setText("Welcome to Leonardo's Painting Machine!\nYou program the machine using punch cards to reproduce the sketch shown on the right. The card is read left to right. Holes in the punch card tell the brush where to move and when to paint."),

        new Puzzle("", AssetPaths.puzzle04__png),
        new Puzzle("", AssetPaths.puzzle04__png),
        new Puzzle("", AssetPaths.puzzle04__png),
        new Puzzle("", AssetPaths.puzzle04__png),

        new Puzzle("", AssetPaths.puzzle04__png),
        new Puzzle("", AssetPaths.puzzle04__png),
        new Puzzle("", AssetPaths.puzzle04__png),
        new Puzzle("", AssetPaths.puzzle04__png),
        new Puzzle("", AssetPaths.puzzle10__png),

        new Puzzle("", AssetPaths.puzzle04__png),
        new Puzzle("", AssetPaths.puzzle04__png),
        new Puzzle("", AssetPaths.puzzle04__png),
        new Puzzle("", AssetPaths.puzzle04__png),
        new Puzzle("", AssetPaths.puzzle04__png),
      ];
    }
    return campaign;
  }

  public static function find(name: String): Null<Puzzle> {
    if (name == sandbox.name) {
      return sandbox;
    }
    for (puzzle in campaign) {
      if (puzzle.name == name) {
        return puzzle;
      }
    }
    return null;
  }

  public static var sandbox(default, null) = new Puzzle("sandbox", null);

}
