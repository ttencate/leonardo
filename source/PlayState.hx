package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.addons.ui.FlxUISpriteButton;
import flixel.util.FlxColor;

class PlayState extends FlxState {

  private var program: Program;

  private var embroidery: Embroidery;
  private var needle: Needle;
  private var help: HelpText;
  private var punchCards: Array<PunchCard>;

  private var runner: Runner;

  public function new(program: Program) {
    super();
    this.program = program;
  }

  override public function create() {
    super.create();

    add(new FlxSprite(AssetPaths.background__png));

    var runButton = new FlxUISpriteButton(16, 272, new FlxSprite(AssetPaths.run__png), onRunClick);
    runButton.loadGraphicsUpOverDown(AssetPaths.square_button__png);
    runButton.labelOffsets[2].set(1, 1);
    add(runButton);
    var stopButton = new FlxUISpriteButton(96, 272, new FlxSprite(AssetPaths.stop__png), onStopClick);
    stopButton.loadGraphicsUpOverDown(AssetPaths.square_button__png);
    stopButton.labelOffsets[2].set(1, 1);
    add(stopButton);

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
    punchCards = [];
    for (i in 0...program.numCards) {
      var punchCard = new PunchCard(program, i, help);
      punchCard.y = y;
      y += punchCard.height;
      add(punchCard);
      punchCards.push(punchCard);
    }
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);
  }

  private function onRunClick() {
    if (runner == null) {
      runner = new Runner(program, embroidery, needle, punchCards);
      add(runner);
      enableInput(false);
    }
    runner.speed = 1;
  }

  private function onStopClick() {
    if (runner != null) {
      runner.reset();
      remove(runner);
      runner = null;
      enableInput(true);
    }
  }

  private function enableInput(enabled: Bool) {
    for (punchCard in punchCards) {
      punchCard.inputEnabled = enabled;
    }
  }
}
