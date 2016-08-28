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

        new Puzzle("5x5_horizontal_stripes", AssetPaths.puzzle_5x5_horizontal_stripes__png)
          .setCards(2, 10)
          .setNumWheels(0)
          .setFeatures([JUMP])
          .setText("You now have two punch cards available, one for each colour. By punching a hole in the 'jump' row, you can switch up or down between them. You can also change the direction of reading: left or right."),

        new Puzzle("6x6_landscape", AssetPaths.puzzle_6x6_landscape__png)
          .setCards(2, 15)
          .setNumWheels(0)
          .setFeatures([JUMP])
          .setText("The painting machine was one of many inventions by Leonardo da Vinci. He kept it secret, because he was afraid that people would steal his idea."),
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
