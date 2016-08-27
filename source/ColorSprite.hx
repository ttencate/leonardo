package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class ColorSprite extends FlxSprite {
  public function new(width: Int, height: Int, color: FlxColor) {
    super();
    makeGraphic(width, height, color);
  }
}
