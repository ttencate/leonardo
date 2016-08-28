package;

class Puzzles {

  public static var campaign(get, null): Array<Puzzle>;
 
  private static function get_campaign(): Array<Puzzle> {
    if (campaign == null) {
      campaign = [
        new Puzzle(2, 16, AssetPaths.puzzle04__png),
        new Puzzle(2, 16, AssetPaths.puzzle04__png),
        new Puzzle(2, 16, AssetPaths.puzzle04__png),
        new Puzzle(2, 16, AssetPaths.puzzle04__png),
        new Puzzle(2, 16, AssetPaths.puzzle04__png),

        new Puzzle(2, 16, AssetPaths.puzzle04__png),
        new Puzzle(2, 16, AssetPaths.puzzle04__png),
        new Puzzle(2, 16, AssetPaths.puzzle04__png),
        new Puzzle(2, 16, AssetPaths.puzzle04__png),
        new Puzzle(2, 16, AssetPaths.puzzle10__png),

        new Puzzle(2, 16, AssetPaths.puzzle04__png),
        new Puzzle(2, 16, AssetPaths.puzzle04__png),
        new Puzzle(2, 16, AssetPaths.puzzle04__png),
        new Puzzle(2, 16, AssetPaths.puzzle04__png),
        new Puzzle(2, 16, AssetPaths.puzzle04__png),
      ];
    }
    return campaign;
  }

  public static var sandbox = new Puzzle(3, 84, null);

}
