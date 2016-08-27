package;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import openfl.display.BitmapData;

class Puzzle {

  public var numCards(default, null): Int;
  public var cardSize(default, null): Int;
  public var patternAsset(default, null): Null<String>;
  public var cols(default, null): Int;
  public var rows(default, null): Int;
  public var pattern(default, null): Null<Array<Array<FlxColor>>>;
  public var colors(default, null): Array<FlxColor>;

  public function new(numCards: Int, cardSize: Int, patternAsset: Null<String>) {
    this.numCards = numCards;
    this.cardSize = cardSize;
    this.patternAsset = patternAsset;
    if (patternAsset != null) {
      var bitmap = FlxG.bitmap.add(patternAsset).bitmap;
      cols = bitmap.width;
      rows = bitmap.height;
      pattern = [for (y in 0...bitmap.height) [for (x in 0...bitmap.width) bitmap.getPixel32(x, y)]];
      colors = extractColors(bitmap);
    } else {
      cols = 13;
      rows = 13;
      pattern = null;
      colors = [0xffffffff, 0xff111111, 0xffFF4136, 0xffFFDC00, 0xff0074D9];
    }
  }

  private function extractColors(bitmap: BitmapData): Array<FlxColor> {
    var colors = [];
    for (y in 0...bitmap.height) {
      for (x in 0...bitmap.width) {
        var color = bitmap.getPixel32(x, y);
        if (colors.indexOf(color) == -1) {
          colors.push(color);
        }
      }
    }
    return colors;
  }
}
