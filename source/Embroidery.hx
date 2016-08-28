package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class Embroidery extends FlxSprite {

  public var cols(default, null): Int;
  public var rows(default, null): Int;

  private var paddingX: Float;
  private var paddingY: Float;
  private var weaveWidth: Float = 24;
  private var weaveHeight: Float = 24;

  private var colors: Array<Array<FlxColor>>;

  public function new(puzzle: Puzzle) {
    super(AssetPaths.canvas__png);
    this.cols = puzzle.cols;
    this.rows = puzzle.rows;

    this.paddingX = Math.floor((width - cols * weaveWidth) / 2);
    this.paddingY = Math.floor((height - rows * weaveHeight) / 2);

    removeAllStitches();
  }

  public function stitchX(col: Float): Float {
    return x + paddingX + weaveWidth * (col + 0.5);
  }

  public function stitchY(row: Float): Float {
    return y + paddingY + weaveHeight * (row + 0.5);
  }

  public function stitchAt(col: Int, row: Int): FlxColor {
    return colors[row][col];
  }

  public function stampStitch(col: Int, row: Int, color: FlxColor) {
    var stitch = new FlxSprite(AssetPaths.stitch__png);
    stitch.color = color;
    stamp(stitch, Math.round(paddingX + col * weaveWidth - 2), Math.round(paddingY + row * weaveHeight - 2));
    colors[row][col] = color;
  }

  public function makeStitch(col: Int, row: Int, color: FlxColor): FlxSprite {
    var stitch = new FlxSprite(x + paddingX + weaveWidth * col - 2, y + paddingY + weaveHeight * row - 2, AssetPaths.stitch__png);
    stitch.color = color;
    return stitch;
  }

  public function removeAllStitches() {
    loadGraphic(AssetPaths.canvas__png, false, 0, 0, true);
    this.colors = [for (row in 0...rows) [for (col in 0...cols) FlxColor.WHITE]];
    var weave = new FlxSprite(AssetPaths.weave__png);
    for (row in 0...rows) {
      for (col in 0...cols) {
        stamp(weave, Math.round(paddingX + col * weaveWidth), Math.round(paddingY + row * weaveHeight));
      }
    }
  }

  public function matches(puzzle: Puzzle) {
    if (this.rows != puzzle.rows || this.cols != puzzle.cols || puzzle.pattern == null) {
      return false;
    }
    for (row in 0...rows) {
      for (col in 0...cols) {
        if (stitchAt(col, row) == null || stitchAt(col, row) != puzzle.colorAt(col, row)) {
          return false;
        }
      }
    }
    return true;
  }
}
