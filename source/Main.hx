package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Lib;
import openfl.display.Sprite;

class Main extends Sprite {
  public function new() {
    super();
    addChild(new FlxGame(0, 0, null, 1, 60, 60, true));
    FlxG.switchState(new MenuState());

    FlxG.mouse.useSystemCursor = true;
#if neko
    FlxG.resizeWindow(Math.round(FlxG.width * FlxG.camera.zoom), Math.round(FlxG.height * FlxG.camera.zoom));
    FlxG.plugins.add(new DebugKeys());
#end
  }

  public static function fadeState(nextState: FlxState) {
    var overlay = new ColorSprite(FlxG.width, FlxG.height, FlxColor.BLACK);
    overlay.alpha = 0;
    FlxG.state.add(overlay);
    FlxTween.tween(overlay, {alpha: 1}, 0.4, {
      onComplete: function(tween) {
        FlxG.switchState(nextState);
      }
    });
  }

  public static function fadeIn() {
    var overlay = new ColorSprite(FlxG.width, FlxG.height, FlxColor.BLACK);
    FlxG.state.add(overlay);
    FlxTween.tween(overlay, {alpha: 0}, 0.4, {
      onComplete: function(tween) {
        FlxG.state.remove(overlay);
      }
    });
  }
}

#if neko
class DebugKeys extends FlxBasic {
  override public function update(elapsed: Float) {
    if (FlxG.keys.justPressed.ESCAPE) {
      Lib.exit();
    }
    super.update(elapsed);
  }
}
#end
