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
    FlxG.switchState(createStartState());

    FlxG.keys.preventDefaultKeys = [
      UP, DOWN, LEFT, RIGHT, SPACE, ENTER, ESCAPE, F1, PAGEUP, PAGEDOWN,
    ];

    FlxG.mouse.useSystemCursor = true;
#if neko
    FlxG.resizeWindow(Math.round(FlxG.width * FlxG.camera.zoom), Math.round(FlxG.height * FlxG.camera.zoom));
    FlxG.plugins.add(new DebugKeys());
#end
  }

  private function createStartState(): FlxState {
    var hash = Url.hash();
    if (hash != "") {
      var commaIndex = hash.indexOf(",");
      if (commaIndex >= 0) {
        var puzzleName = hash.substring(0, commaIndex);
        var programJson = StringTools.urlDecode(hash.substring(commaIndex + 1));
        var puzzle = Puzzles.find(puzzleName);
        if (puzzle != null) {
          return new PlayState(puzzle, programJson);
        }
      }
    }

    var puzzle = Puzzles.find(FlxG.save.data.currentPuzzle);
    if (puzzle != null) {
      return new PlayState(puzzle);
    } else if (FlxG.save.data.currentPuzzle == "menu") {
      return new MenuState();
    } else {
      return new PlayState(Puzzles.campaign[0]);
    }
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
    if (FlxG.keys.justPressed.Q) {
      Lib.exit();
    }
    super.update(elapsed);
  }
}
#end
