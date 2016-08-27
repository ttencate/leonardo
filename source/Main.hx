package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.input.mouse.FlxMouseEventManager;
import openfl.Lib;
import openfl.display.Sprite;

class Main extends Sprite {
  public function new() {
    super();
    addChild(new FlxGame(0, 0, null, 1, 60, 60, true));
    FlxG.switchState(new PlayState(new Puzzle(2, 16, AssetPaths.puzzle04__png)));

    FlxG.plugins.add(new FlxMouseEventManager());
    FlxG.mouse.useSystemCursor = true;
#if neko
    FlxG.resizeWindow(FlxG.width, FlxG.height);
    FlxG.plugins.add(new DebugKeys());
#end
  }
}

class DebugKeys extends FlxBasic {
  override public function update(elapsed: Float) {
    if (FlxG.keys.justPressed.ESCAPE) {
      Lib.exit();
    }
    super.update(elapsed);
  }
}
