package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class Embroidery extends FlxSpriteGroup {

  public var cols(default, null): Int;
  public var rows(default, null): Int;

  private var weaveWidth: Float;
  private var weaveHeight: Float;

  private var stitches: Array<Array<FlxSprite>>;

  public function new(puzzle: Puzzle) {
    super();
    this.cols = puzzle.cols;
    this.rows = puzzle.rows;

    this.stitches = [for (row in 0...rows) [for (col in 0...cols) null]];

    var y: Float = 0;
    for (row in 0...rows) {
      var weave = null;
      var x: Float = 0;
      for (col in 0...cols) {
        weave = new FlxSprite(x, y, AssetPaths.weave__png);
        weaveWidth = weave.width;
        weaveHeight = weave.height;
        x += weaveWidth;
        add(weave);
      }
      y += weaveHeight;
    }
  }

  public function stitchX(col: Float): Float {
    return x + weaveWidth * (col + 0.5);
  }

  public function stitchY(row: Float): Float {
    return y + weaveHeight * (row + 0.5);
  }

  public function stitchAt(col: Int, row: Int): Null<FlxColor> {
    var stitch = stitches[row][col];
    return stitch == null ? null : stitch.color;
  }

  public function addStitch(col: Int, row: Int, color: FlxColor): FlxSprite {
    var stitch = new FlxSprite(weaveWidth * col, weaveHeight * row, AssetPaths.stitch__png);
    stitch.color = color;
    add(stitch);
    stitches[row][col] = stitch;
    return stitch;
  }

  public function removeAllStitches() {
    for (row in stitches) {
      for (stitch in row) {
        if (stitch != null) {
          remove(stitch);
        }
      }
    }
    stitches = [for (row in 0...rows) [for (col in 0...cols) null]];
  }
}
