package;

import flixel.FlxG;
import flixel.FlxSprite;

class WheelButton extends FlxSprite {

  private var onClick: Void->Void;
  private var help: HelpText;

  public function new(x: Float, y: Float, onClick: Void->Void, help: HelpText) {
    super(x, y);
    this.onClick = onClick;
    this.help = help;

    loadGraphic(AssetPaths.wheel_button__png, true, 64, 64);
    animation.add("up", [0]);
    animation.add("over", [1]);
    animation.add("down", [2]);
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);
    if (visible) {
      var over = FlxG.mouse.x >= x && FlxG.mouse.x < x + width && FlxG.mouse.y >= y && FlxG.mouse.y < y + height;
      if (!over) {
        animation.play("up");
      } else {
        help.set("Click to increment the wheel's initial value, right-click to decrement");
        if (FlxG.mouse.pressed || FlxG.mouse.pressedRight) {
          animation.play("down");
        } else {
          animation.play("over");
        }
        if (FlxG.mouse.justPressed || FlxG.mouse.justPressedRight) {
          onClick();
        }
      }
    }
  }
}
