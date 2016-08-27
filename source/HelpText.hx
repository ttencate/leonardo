package;

import flixel.text.FlxText;

class HelpText extends FlxText {

  private var nextText: String;

  public function new(x: Float, y: Float, width: Float) {
    super(x, y, width);
  }

  public function set(help: String) {
    nextText = help;
  }

  override public function update(elapsed: Float) {
    if (nextText != null) {
      if (text != nextText) {
        text = nextText;
      }
    } else {
      text = "";
    }
    nextText = null;
  }
}
