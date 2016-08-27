package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.addons.ui.FlxUISpriteButton;
import flixel.util.FlxColor;

class PlayState extends FlxState {

  private var puzzle: Puzzle;

  private var program: Program;

  private var embroidery: Embroidery;
  private var needle: Needle;
  private var help: HelpText;
  private var punchCards: Array<PunchCard>;

  private var runner: Runner;

  public function new(puzzle: Puzzle) {
    super();
    this.puzzle = puzzle;
  }

  override public function create() {
    super.create();

    this.program = new Program(puzzle.numCards, puzzle.cardSize);

    add(new FlxSprite(AssetPaths.background__png));

    var runButton = new FlxUISpriteButton(16, 272, new FlxSprite(AssetPaths.run__png), onRunClick);
    runButton.loadGraphicsUpOverDown(AssetPaths.square_button__png);
    runButton.labelOffsets[2].set(1, 1);
    add(runButton);
    var stopButton = new FlxUISpriteButton(96, 272, new FlxSprite(AssetPaths.stop__png), onStopClick);
    stopButton.loadGraphicsUpOverDown(AssetPaths.square_button__png);
    stopButton.labelOffsets[2].set(1, 1);
    add(stopButton);

    embroidery = new Embroidery(puzzle);
    embroidery.x = 256;
    embroidery.y = (352 - embroidery.height) / 2;
    add(embroidery);

    if (puzzle.patternAsset != null) {
      var pattern = new FlxSpriteGroup(832, 176);
      var S = 24;
      for (row in 0...puzzle.rows) {
        for (col in 0...puzzle.cols) {
          pattern.add(new FlxSprite(S * col, S * row, AssetPaths.pattern_square_outline__png));
        }
      }
      for (row in 0...puzzle.rows) {
        for (col in 0...puzzle.cols) {
          var square = new FlxSprite(S * col, S * row, AssetPaths.pattern_square__png);
          square.color = puzzle.colorAt(col, row);
          pattern.add(square);
        }
      }
      pattern.offset.set((pattern.width - 1) / 2, (pattern.height - 1) / 2);
      add(pattern);
    }

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
      runner = new Runner(puzzle, program, embroidery, needle, punchCards, help);
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
