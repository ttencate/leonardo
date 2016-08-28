package;

class Puzzles {

  public static var campaign(get, null): Array<Puzzle>;
 
  private static function get_campaign(): Array<Puzzle> {
    if (campaign == null) {
      campaign = [

        // FIRST ROW

        new Puzzle("3x3_blue", AssetPaths.puzzle_3x3_blue__png)
          .setCards(1, 12)
          .setNumWheels(0)
          .setFeatures([])
          .setText("Welcome to Leonardo's Painting Machine!\nYou program the machine using punch cards to reproduce the sketch shown on the right. The card is read left to right. Holes in the punch card tell the brush where to move and when to paint."),

        new Puzzle("5x5_cross", AssetPaths.puzzle_5x5_cross__png)
          .setCards(1, 30)
          .setNumWheels(0)
          .setFeatures([])
          .setText("The machine stops when it runs off the edge of a punch card. It also stops as soon as the painting is done."),

        new Puzzle("5x5_horizontal_stripes", AssetPaths.puzzle_5x5_horizontal_stripes__png)
          .setCards(2, 10)
          .setNumWheels(0)
          .setFeatures([JUMP])
          .setText("Each punch card paints with a different colour. By punching a hole in the 'jump' row combined with a direction, you can switch up or down between them. You can also change the direction of reading: left or right."),

        new Puzzle("6x6_landscape", AssetPaths.puzzle_6x6_landscape__png)
          .setCards(2, 15)
          .setNumWheels(0)
          .setFeatures([JUMP])
          .setText("The painting machine was one of many inventions by Leonardo da Vinci. He kept it secret, because he was afraid it would make people think less of the paintings he produced with it."),

        new Puzzle("6x6_checkerboard", AssetPaths.puzzle_6x6_checkerboard__png)
          .setCards(3, 30)
          .setNumWheels(0)
          .setFeatures([JUMP])
          .setText("If you jump off the top of the top card, you end up on the bottom card, and vice versa."),

        // SECOND ROW

        new Puzzle("12x5_red_yellow_blue", AssetPaths.puzzle_12x5_red_yellow_blue__png)
          .setCards(3, 10)
          .setNumWheels(1)
          .setFeatures([JUMP, DECREMENT, TEST_NONZERO])
          .setText("Wheels can be used to keep track of a counter. Set an initial value by clicking it. Punch holes for decrementing and testing whether the counter is 0."),

        new Puzzle("12x12_diagonal", AssetPaths.puzzle_12x12_diagonal__png)
          .setCards(3, 25)
          .setText("The machine actually has two counter wheels available. Punch a hole in the first row to select the bottom wheel instead of the top one."),

        new Puzzle("sandbox", null)
          .setText("Welcome to the sandbox. Let's make a happy little painting. This is your world. You can do anything you want to do."),

        new Puzzle("11x12_waves", AssetPaths.puzzle_11x12_waves__png)
          .setCards(3, 25)
          .setText("Da Vinci was so secretive about this painting machine that nobody had ever heard about it before this game was made."),

        new Puzzle("", AssetPaths.puzzle04__png),

        // THIRD ROW

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
    for (puzzle in campaign) {
      if (puzzle.name == name) {
        return puzzle;
      }
    }
    return null;
  }
}
