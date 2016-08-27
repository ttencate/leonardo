package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class Embroidery extends FlxSpriteGroup {

  public var cols(default, null): Int;
  public var rows(default, null): Int;

  private var weaveWidth: Float;
  private var weaveHeight: Float;

  private var stitches: Array<FlxSprite> = [];

  public function new(cols: Int, rows: Int) {
    super();
    this.cols = cols;
    this.rows = rows;

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

  public function addStitch(col: Int, row: Int, color: FlxColor): FlxSprite {
    var stitch = new FlxSprite(weaveWidth * col, weaveHeight * row, AssetPaths.stitch__png);
    stitch.color = color;
    add(stitch);
    stitches.push(stitch);
    return stitch;
  }

  public function removeAllStitches() {
    for (stitch in stitches) {
      remove(stitch);
    }
    stitches = [];
  }
}
