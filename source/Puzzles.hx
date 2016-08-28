package;

class Puzzles {

  public static var campaign(get, null): Array<Puzzle>;
 
  private static function get_campaign(): Array<Puzzle> {
    if (campaign == null) {
      campaign = [
        new Puzzle(AssetPaths.puzzle_3x3_blue__png)
          .setCards(1, 12)
          .setText("Welcome to Leonardo's Painting Machine! You program the machine using punch cards to reproduce the sketch shown on the right. You can move the brush and tell it to paint."),

        new Puzzle(AssetPaths.puzzle04__png),
        new Puzzle(AssetPaths.puzzle04__png),
        new Puzzle(AssetPaths.puzzle04__png),
        new Puzzle(AssetPaths.puzzle04__png),

        new Puzzle(AssetPaths.puzzle04__png),
        new Puzzle(AssetPaths.puzzle04__png),
        new Puzzle(AssetPaths.puzzle04__png),
        new Puzzle(AssetPaths.puzzle04__png),
        new Puzzle(AssetPaths.puzzle10__png),

        new Puzzle(AssetPaths.puzzle04__png),
        new Puzzle(AssetPaths.puzzle04__png),
        new Puzzle(AssetPaths.puzzle04__png),
        new Puzzle(AssetPaths.puzzle04__png),
        new Puzzle(AssetPaths.puzzle04__png),
      ];
    }
    return campaign;
  }

  public static var sandbox(default, null) = new Puzzle(null);

}
