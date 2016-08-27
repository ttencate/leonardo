package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class Embroidery extends FlxSpriteGroup {

  public var cols(default, null): Int;
  public var rows(default, null): Int;

  private var weaveWidth: Float;
  private var weaveHeight: Float;

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

  public function stitchX(col: Int): Float {
    return x + weaveWidth * (col + 0.5);
  }

  public function stitchY(row: Int): Float {
    return y + weaveHeight * (row + 0.5);
  }
}
