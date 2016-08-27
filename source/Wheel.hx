package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Wheel extends FlxSpriteGroup {

  public static inline var COUNT = 12;

  public var value: Int = 0;
  private var labels: Array<FlxText>;

  public function new(x: Float, y: Float) {
    super(x, y);

    add(new FlxSprite(-144, -144, AssetPaths.wheel__png));

    labels = [];
    for (i in 0...COUNT) {
      var text = new FlxText(Std.string(i));
      text.setFormat(AssetPaths.day_roman__ttf, 40, 0xff111111);
      text.setBorderStyle(SHADOW, 0x80000000);
      text.antialiasing = true;
      add(text);
      labels.push(text);
    }

    angle = 0;
  }

  public function moveToValue(value: Float) {
    angle = -360 * value / COUNT;
  }

  override private function set_angle(a: Float): Float {
    var r = 112;
    for (i in 0...COUNT) {
      var text = labels[i];
      var ta = a + i / COUNT * 360;
      text.x = x - r * Math.cos(ta * Math.PI / 180) - text.width / 2;
      text.y = y - r * Math.sin(ta * Math.PI / 180) - text.height / 2 - 5;
      text.angle = ta;
    }
    return super.set_angle(a);
  }
}
