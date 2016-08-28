package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseButton;
import flixel.input.mouse.FlxMouseButton.FlxMouseButtonID;
import flixel.addons.ui.FlxUISpriteButton;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;

class PlayState extends FlxState {

  private var puzzle: Puzzle;
  private var programJson: Null<String>;

  private var program: Program;

  private var embroidery: Embroidery;
  private var needle: Needle;
  private var help: HelpText;
  private var punchCards: Array<PunchCard>;
  private var wheels: Array<Wheel>;
  private var wheelButtons: Array<WheelButton>;

  private var backgroundGroup: FlxGroup;
  private var patternGroup: FlxGroup;
  private var controlsGroup: FlxGroup;
  private var programGroup: FlxGroup;
  private var overlayGroup: FlxGroup;
  private var paintingGroup: FlxGroup;
  private var runnerGroup: FlxGroup;
  private var brushGroup: FlxGroup;

  private var backButton: FlxUISpriteButton;
  private var linkButton: FlxUISpriteButton;
  private var runStopButton: FlxUISpriteButton;
  private var speedButtons: Array<FlxUISpriteButton>;

  private var runner: Runner;
  private var speed: Float = 1;
  private var complete: Bool = false;

  public function new(puzzle: Puzzle, ?programJson: String) {
    super();
    this.puzzle = puzzle;
    this.programJson = programJson;
  }

  override public function create() {
    super.create();

    this.program = new Program(puzzle);
    if (this.programJson != null) {
      this.program.fromJson(puzzle, programJson);
      programJson = null;
    } else {
      this.program.fromJson(puzzle, Reflect.field(FlxG.save.data, "program_" + puzzle.name + "_0"));
    }

    add(backgroundGroup = new FlxGroup());
    add(patternGroup = new FlxGroup());
    add(controlsGroup = new FlxGroup());
    add(programGroup = new FlxGroup());
    add(overlayGroup = new FlxGroup());
    add(paintingGroup = new FlxGroup());
    add(runnerGroup = new FlxGroup());
    add(brushGroup = new FlxGroup());

    backgroundGroup.add(new FlxSprite(AssetPaths.background__png));

    backButton = new FlxUISpriteButton(16, 16, new FlxSprite(AssetPaths.back__png), function() {
      Main.fadeState(new MenuState());
    });
    backButton.loadGraphicsUpOverDown(AssetPaths.square_button__png);
    backButton.labelOffsets[2].set(1, 1);
    controlsGroup.add(backButton);

    linkButton = new FlxUISpriteButton(96, 16, new FlxSprite(AssetPaths.link__png), onLinkClick);
    linkButton.loadGraphicsUpOverDown(AssetPaths.square_button__png);
    linkButton.labelOffsets[2].set(1, 1);
    controlsGroup.add(linkButton);

    if (puzzle.text != null) {
      var instructions = new FlxText(16, 96, 240, puzzle.text);
      instructions.setFormat(AssetPaths.day_roman__ttf, 20, FlxColor.WHITE);
      instructions.setBorderStyle(SHADOW, 0x80000000, 2);
      while (instructions.height > 160) {
        instructions.size -= 1;
      }
      controlsGroup.add(instructions);
    }

    runStopButton = new FlxUISpriteButton(16, 272, new FlxSprite(AssetPaths.run__png), onRunStopClick);
    runStopButton.loadGraphicsUpOverDown(AssetPaths.square_button__png);
    runStopButton.labelOffsets[2].set(1, 1);
    controlsGroup.add(runStopButton);

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
      controlsGroup.add(speedButton);
      speedButtons.push(speedButton);
    }
    speedButtons[1].toggled = true;

    if (puzzle.patternAsset != null) {
      var pattern = puzzle.createPatternSprite();
      pattern.x = 832 - Math.floor(pattern.width / 2);
      pattern.y = 176 - Math.floor(pattern.height / 2);
      patternGroup.add(pattern);
    }

    help = new HelpText(6, 352, FlxG.width - 12);
    help.setFormat(AssetPaths.day_roman__ttf, 20, FlxColor.WHITE);
    help.setBorderStyle(SHADOW, 0x80000000, 2);
    programGroup.add(help);

    var y: Float = 384 + 14;
    punchCards = [];
    for (i in 0...puzzle.numCards) {
      var punchCard = new PunchCard(puzzle, program, i, help);
      punchCard.y = y;
      y += punchCard.height;
      programGroup.add(punchCard);
      punchCards.push(punchCard);
    }

    wheels = [];
    wheelButtons = [];
    for (i in 0...puzzle.numWheels) {
      var wheel = new Wheel(FlxG.width + 80, FlxG.height - 256 + 128 * i);
      programGroup.add(wheel);
      wheels.push(wheel);

      var wheelButton = new WheelButton(FlxG.width - 64, FlxG.height - 256 - 32 + 128 * i, function() {
        onWheelButtonClick(i);
      }, help);
      programGroup.add(wheelButton);
      wheelButtons.push(wheelButton);
    }
    if (puzzle.numWheels > 0) {
      programGroup.add(new FlxSprite(FlxG.width - 128, FlxG.height - 384, AssetPaths.wheels_overlay__png));
    }

    embroidery = new Embroidery(puzzle);
    embroidery.setPosition(272, 0);
    paintingGroup.add(embroidery);

    needle = new Needle(embroidery);
    brushGroup.add(needle);

    reset();

    Main.fadeIn();

    FlxG.save.data.currentPuzzle = puzzle.name;
    FlxG.save.flush();
  }

  private function save() {
    Reflect.setField(FlxG.save.data, "program_" + puzzle.name + "_0", program.toJson());
    FlxG.save.flush();
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);

    if (runStopButton.mouseIsOver) {
      if (runner != null) {
        help.set("Abort the run and reset the machine");
      } else {
        help.set("Run the program");
      }
    } else if (backButton.mouseIsOver) {
      help.set("Back to main menu");
    } else if (linkButton.mouseIsOver) {
      help.set("Set the browser address bar to a link containing this solution, for copying and sharing");
    } else {
      for (i in 0...speedButtons.length) {
        var button = speedButtons[i];
        if (button.mouseIsOver) {
          help.set([
            "Pause program execution",
            "Run program at 1x speed",
            "Run program at 5x speed",
            "Run program at 25x speed",
          ][i]);
        }
      }
    }

    var debugSolve = false;
#if neko
    debugSolve = FlxG.keys.pressed.S;
#end
    if (!complete && ((runner != null && runner.isSolved()) || debugSolve)) {
      win();
    }
    if (complete && FlxG.mouse.justPressed) {
      Main.fadeState(new MenuState());
    }
  }

  public function win() {
    complete = true;

    Reflect.setField(FlxG.save.data, "solved_" + puzzle.name, true);
    FlxG.save.flush();

    runnerGroup.remove(runner);
    runner = null;

    controlsGroup.forEachExists(function(control) {
      control.active = false;
    });

    var overlay = new ColorSprite(FlxG.width, FlxG.height, 0xff483e37);
    overlay.alpha = 0;
    overlayGroup.add(overlay);
    FlxTween.tween(overlay, {alpha: 1}, 1.0, {ease: FlxEase.sineInOut});

    embroidery.antialiasing = true;
    embroidery.pixelPerfectPosition = false;
    embroidery.pixelPerfectRender = false;
    var s = 2;
    FlxTween.tween(embroidery.scale, {x: s, y: s}, 1.0, {ease: FlxEase.quadInOut});
    FlxTween.tween(embroidery, {x: Math.floor((FlxG.width - embroidery.width) / 2), y: Math.floor((FlxG.height - embroidery.height) / 2)}, 1.0, {ease: FlxEase.quadInOut});
    FlxTween.tween(needle, {y: -needle.height}, 1.0, {ease: FlxEase.quadIn});
  }

  public function reset() {
    needle.col = 0;
    needle.row = 0;
    needle.setColor(FlxColor.TRANSPARENT);
    needle.setEmbroideryPos(needle.col, needle.row);

    embroidery.removeAllStitches();

    for (i in 0...wheels.length) {
      var wheel = wheels[i];
      wheel.alpha = 1;
      wheel.value = program.wheelStarts[i];
      wheel.moveToValue(wheel.value);
    }
  }

  private function onRunStopClick() {
    if (runner == null) {
      save();
      runStopButton.label = new FlxSprite(AssetPaths.stop__png);
      runner = new Runner(puzzle, program, embroidery, needle, punchCards, wheels, help);
      runner.speed = speed;
      runnerGroup.add(runner);
      enableInput(false);
    } else {
      runStopButton.label = new FlxSprite(AssetPaths.run__png);
      reset();
      runnerGroup.remove(runner);
      runner = null;
      enableInput(true);
    }
  }

  override public function switchTo(next: FlxState): Bool {
    save();
    return super.switchTo(next);
  }

  private function onSpeedButtonClick(button: Int) {
    for (speedButton in speedButtons) {
      speedButton.toggled = false;
    }
    speedButtons[button].toggled = true;
    speed = [0.0, 1.0, 5.0, 25.0][button];
    if (runner != null) {
      runner.speed = speed;
    }
  }

  private function onLinkClick() {
    var url = Url.base() + "#" + puzzle.name + "," + StringTools.urlEncode(program.toJson());
    Url.setLocation(url);
  }

  private function onWheelButtonClick(index: Int) {
    var wheel = wheels[index];
    if (FlxG.mouse.pressedRight) {
      wheel.value--;
    } else {
      wheel.value++;
    }
    wheel.moveToValue(wheel.value);
    program.wheelStarts[index] = wheel.value;
  }

  private function enableInput(enabled: Bool) {
    for (punchCard in punchCards) {
      punchCard.inputEnabled = enabled;
    }
    for (wheelButton in wheelButtons) {
      wheelButton.visible = enabled;
    }
  }
}
