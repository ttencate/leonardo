package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import openfl.display.BitmapData;

class Puzzle {

  public var name(default, null): String;
  public var numCards(default, null): Int = 3;
  public var cardSize(default, null): Int = 84;
  public var numWheels(default, null): Int = 2;
  public var features(default, null): Array<Feature> = [INCREMENT, DECREMENT, TEST_ZERO, TEST_NONZERO, JUMP];
  public var patternAsset(default, null): Null<String>;
  public var cols(default, null): Int;
  public var rows(default, null): Int;
  public var pattern(default, null): Null<Array<Array<FlxColor>>>;
  public var colors(default, null): Array<FlxColor>;
  public var text(default, null): Null<String>;

  public function new(name: String, patternAsset: Null<String>) {
    this.name = name;
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
      colors = [0xff111111, 0xffffffff, 0xff001f3f, 0xff0074d9, 0xff7fdbff, 0xff39cccc, 0xff3d9970, 0xff2ecc40, 0xff01ff70, 0xffffdc00, 0xffff851b, 0xffff4136, 0xff85144b, 0xfff012be, 0xffb10dc9, 0xffaaaaaa, 0xffdddddd];
    }
  }

  public function setCards(numCards: Int, cardSize: Int): Puzzle {
    this.numCards = numCards;
    this.cardSize = cardSize;
    return this;
  }

  public function setNumWheels(numWheels: Int): Puzzle {
    this.numWheels = numWheels;
    return this;
  }

  public function setFeatures(features: Array<Feature>) {
    this.features = features;
    return this;
  }

  public function setText(text: String): Puzzle {
    this.text = text;
    return this;
  }

  public function hasFeature(f: Feature): Bool {
    return features.indexOf(f) >= 0;
  }

  public function colorAt(col: Int, row: Int) {
    return pattern[row][col];
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

  public function createPatternSprite(): FlxSprite {
    var pattern = new FlxSprite();
    var S = 24;
    pattern.makeGraphic(S * cols + 1, S * rows + 1, FlxColor.TRANSPARENT, true);
    var squareOutline = new FlxSprite(AssetPaths.pattern_square_outline__png);
    for (row in 0...rows) {
      for (col in 0...cols) {
        pattern.stamp(squareOutline, S * col, S * row);
      }
    }
    var square = new FlxSprite(AssetPaths.pattern_square__png);
    for (row in 0...rows) {
      for (col in 0...cols) {
        square.color = colorAt(col, row);
        pattern.stamp(square, S * col, S * row);
      }
    }
    return pattern;
  }
}
