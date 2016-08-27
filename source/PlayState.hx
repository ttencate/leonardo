package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class PlayState extends FlxState {

  private var program: Program;

  private var embroidery: Embroidery;
  private var needle: Needle;
  private var help: HelpText;

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

    help = new HelpText(6, 352, FlxG.width - 12);
    help.setFormat(AssetPaths.day_roman__ttf, 20, FlxColor.WHITE);
    help.setBorderStyle(SHADOW, 0x80000000, 2);
    add(help);

    var y: Float = 384 + 14;
    for (i in 0...program.numCards) {
      var punchCard = new PunchCard(program, i, help);
      punchCard.y = y;
      y += punchCard.height;
      add(punchCard);
    }
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);
  }
}
