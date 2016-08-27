package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState {

  private var program: Program;

  private var embroidery: Embroidery;
  private var needle: Needle;

  public function new(program: Program) {
    super();
    this.program = program;
  }

  override public function create() {
    super.create();

    add(new FlxSprite(AssetPaths.background__png));

    embroidery = new Embroidery(4, 4);
    embroidery.x = 256;
    embroidery.y = (352 - embroidery.height) / 2;
    add(embroidery);

    needle = new Needle(embroidery);
    add(needle);

    var y: Float = 384 + 14;
    for (i in 0...program.numCards) {
      var punchCard = new PunchCard(program, i);
      punchCard.y = y;
      y += punchCard.height;
      add(punchCard);
    }
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);
  }
}
