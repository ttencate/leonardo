package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;

class KeyboardHelpState extends FlxSubState {

  private var closing: Bool = false;

  override public function create() {
    var background = new ColorSprite(FlxG.width, FlxG.height, 0xd0000000);
    add(background);
    fadeIn(background);

    var m = 16;

    var left = new FlxText(0, 128, FlxG.width / 3 - m,
"F1
Up/down/left/right
or W/S/A/D
or Z/S/A/D
Space
Enter
Esc
1/2/3/4
PgUp/PgDn
Shift+PgUp/Shift+PgDn");
    left.setFormat(AssetPaths.day_roman__ttf, 32, FlxColor.WHITE, RIGHT);
    left.setBorderStyle(SHADOW, 0x80000000, 2);
    add(left);
    fadeIn(left);

    var right = new FlxText(FlxG.width / 3 + m, 128,
"show this help
move the cursor


toggle hole at current position
run the machine (stop if already running)
stop the machine
set speed to paused/1x/5x/25x
increment value of the top/bottom wheel);
decrement value of the top/bottom wheel");
    right.setFormat(AssetPaths.day_roman__ttf, 32, FlxColor.WHITE, LEFT);
    right.setBorderStyle(SHADOW, 0x80000000, 2);
    add(right);
    fadeIn(right);
  }

  private static function fadeIn(sprite: FlxSprite) {
    sprite.alpha = 0;
    FlxTween.tween(sprite, {alpha: 1}, 0.4);
  }

  private static function fadeOut(sprite: FlxSprite) {
    FlxTween.tween(sprite, {alpha: 0}, 0.4);
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);

    if (!closing && (FlxG.mouse.justPressed || FlxG.keys.firstPressed() != -1)) {
      closing = true;
      forEachAlive(function(child) {
        fadeOut(cast child);
      });
      new FlxTimer().start(0.4, function(timer) { close(); });
    }
  }
}
