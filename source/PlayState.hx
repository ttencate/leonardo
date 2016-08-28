package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.addons.ui.FlxUISpriteButton;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState {

  private var puzzle: Puzzle;

  private var program: Program;

  private var embroidery: Embroidery;
  private var needle: Needle;
  private var help: HelpText;
  private var punchCards: Array<PunchCard>;
  private var wheels: Array<Wheel>;

  private var runStopButton: FlxUISpriteButton;
  private var speedButtons: Array<FlxUISpriteButton>;

  private var runner: Runner;
  private var speed: Float = 1;

  public function new(puzzle: Puzzle) {
    super();
    this.puzzle = puzzle;
  }

  override public function create() {
    super.create();

    this.program = new Program(puzzle.numCards, puzzle.cardSize, puzzle.colors);

    add(new FlxSprite(AssetPaths.background__png));

    var backButton = new FlxUISpriteButton(16, 16, new FlxSprite(AssetPaths.back__png), function() {
      Main.fadeState(new MenuState());
    });
    backButton.loadGraphicsUpOverDown(AssetPaths.square_button__png);
    backButton.labelOffsets[2].set(1, 1);
    add(backButton);

    if (puzzle.text != null) {
      var instructions = new FlxText(16, 96, 240, puzzle.text);
      instructions.setFormat(AssetPaths.day_roman__ttf, 20, FlxColor.WHITE);
      instructions.setBorderStyle(SHADOW, 0x80000000, 2);
      while (instructions.height > 160) {
        instructions.size -= 1;
      }
      add(instructions);
    }

    runStopButton = new FlxUISpriteButton(16, 272, new FlxSprite(AssetPaths.run__png), onRunStopClick);
    runStopButton.loadGraphicsUpOverDown(AssetPaths.square_button__png);
    runStopButton.labelOffsets[2].set(1, 1);
    add(runStopButton);

    speedButtons = [];
    for (i in 0...4) {
      var speedButton = new FlxUISpriteButton(96 + 40 * i, 272, new FlxSprite([
        AssetPaths.speed_0__png,
        AssetPaths.speed_1__png,
        AssetPaths.speed_2__png,
        AssetPaths.speed_3__png,
      ][i]), function() { onSpeedButtonClick(i); });
      speedButton.loadGraphicsUpOverDown(AssetPaths.speed_button__png, true);
      speedButton.labelOffsets[2].set(1, 1);
      add(speedButton);
      speedButtons.push(speedButton);
    }
    speedButtons[1].toggled = true;

    embroidery = new Embroidery(puzzle);
    embroidery.x = 464 - embroidery.width / 2;
    embroidery.y = 176 - embroidery.height / 2;
    add(embroidery);

    if (puzzle.patternAsset != null) {
      var pattern = puzzle.createPatternSprite();
      pattern.x = 832 - Math.floor(pattern.width / 2);
      pattern.y = 176 - Math.floor(pattern.height / 2);
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
      var punchCard = new PunchCard(puzzle, program, i, help);
      punchCard.y = y;
      y += punchCard.height;
      add(punchCard);
      punchCards.push(punchCard);
    }

    wheels = [];
    for (i in 0...puzzle.numWheels) {
      var wheel = new Wheel(FlxG.width + 80, FlxG.height - 256 + 128 * i);
      add(wheel);
      wheels.push(wheel);
    }
    if (puzzle.numWheels > 0) {
      add(new FlxSprite(FlxG.width - 128, FlxG.height - 384, AssetPaths.wheels_overlay__png));
    }

    Main.fadeIn();
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);
  }

  private function onRunStopClick() {
    if (runner == null) {
      runStopButton.label = new FlxSprite(AssetPaths.stop__png);
      runner = new Runner(puzzle, program, embroidery, needle, punchCards, wheels, help);
      runner.speed = speed;
      add(runner);
      enableInput(false);
    } else {
      runStopButton.label = new FlxSprite(AssetPaths.run__png);
      runner.reset();
      remove(runner);
      runner = null;
      enableInput(true);
    }
  }

  private function onSpeedButtonClick(button: Int) {
    for (speedButton in speedButtons) {
      speedButton.toggled = false;
    }
    speedButtons[button].toggled = true;
    speed = [0.0, 1.0, 3.0, 10.0][button];
    if (runner != null) {
      runner.speed = speed;
    }
  }

  private function enableInput(enabled: Bool) {
    for (punchCard in punchCards) {
      punchCard.inputEnabled = enabled;
    }
  }
}
