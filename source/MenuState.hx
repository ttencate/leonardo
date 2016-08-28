package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUISpriteButton;

class MenuState extends FlxState {
  override public function create() {
    add(new FlxSprite(AssetPaths.menu__png));

    var x = 32.0;
    var y = 176.0;
    for (puzzle in Puzzles.campaign) {
      var button = new FlxUISpriteButton(x, y, null, function() {
        Main.fadeState(new PlayState(puzzle));
      });
      button.loadGraphicsUpOverDown(AssetPaths.menu_button__png);
      button.labelOffsets[2].set(2, 2);
      add(button);

      x += button.width;
      if (x >= 992) {
        x = 32;
        y += button.height;
      }
    }

    Main.fadeIn();
  }
}
