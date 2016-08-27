package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;

class Main extends Sprite {
  public function new() {
    super();
    addChild(new FlxGame(0, 0, PlayState, 1, 60, 60, true));
    FlxG.mouse.useSystemCursor = true;
#if neko
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
