package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUISpriteButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MenuState extends FlxState {
  override public function create() {
    add(new FlxSprite(AssetPaths.menu__png));

    var x = 32.0;
    var y = 176.0;
    var nextLocked = false;
    for (puzzle in Puzzles.campaign) {
      var icon: FlxSprite;
      var locked = nextLocked;
      if (locked) {
        var text = new FlxText("?");
        text.setFormat(AssetPaths.day_roman__ttf, 40, FlxColor.WHITE);
        text.setBorderStyle(SHADOW, 0x80000000, 2);
        icon = text;
      } else if (puzzle.pattern == null) {
        var text = new FlxText("Sandbox");
        text.setFormat(AssetPaths.day_roman__ttf, 40, FlxColor.WHITE);
        text.setBorderStyle(SHADOW, 0x80000000, 2);
        icon = text;
      } else {
        icon = puzzle.createPatternSprite();
        icon.scale.set(0.5, 0.5);
      }

      if (puzzle.pattern != null && Reflect.field(FlxG.save.data, "solved_" + puzzle.name) != true) {
        nextLocked = true;
      }

      var button = new FlxUISpriteButton(x, y, icon, locked ? null : function() {
        Main.fadeState(new PlayState(puzzle));
      });
      button.loadGraphicsUpOverDown(AssetPaths.menu_button__png);
      button.labelOffsets[2].set(2, 2);
      button.setCenterLabelOffset(Math.floor(button.width - 19 - icon.width) / 2, Math.floor(button.height - 16 - icon.height) / 2);
      button.up_color = button.down_color = button.over_color = null;
      add(button);

      x += button.width;
      if (x >= 992) {
        x = 32;
        y += button.height;
      }
    }

    Main.fadeIn();

    FlxG.save.data.currentPuzzle = "menu";
    FlxG.save.flush();
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);
#if neko
    if (FlxG.keys.justPressed.X) {
      FlxG.save.erase();
      Main.fadeState(new MenuState());
    }
#end
  }
}
