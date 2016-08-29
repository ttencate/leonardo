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
  private var statusText: FlxText;

  private var runner: Runner;
  private var speed: Float = 1;
  private var complete: Bool = false;

  private var cursorCard: Null<Int>;
  private var cursorCol: Null<Int>;
  private var cursorRow: Null<Int>;
  private var dragType: Bool = true;

  private var inputEnabled: Bool = true;
  private var prevMouseX: Int;
  private var prevMouseY: Int;

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

    statusText = new FlxText(176 - 2, 16 + 12);
    statusText.setFormat(AssetPaths.day_roman__ttf, 14, 0xffac9d93);
    statusText.setBorderStyle(SHADOW, 0x80000000, 2);
    controlsGroup.add(statusText);

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

    updateStatusText();
    showTooltips();
    handleMouse();
    handleKeys();

    var debugSolve = false;
#if neko
    debugSolve = FlxG.keys.pressed.S;
#end
    if (!complete && ((runner != null && runner.isSolved()) || debugSolve)) {
      win();
    }
    if (complete && (FlxG.mouse.justPressed || FlxG.keys.firstPressed() != -1)) {
      Main.fadeState(new MenuState());
    }
  }

  private function updateStatusText() {
    var statusText = 'Holes: ${program.countHoles()}';
    if (runner != null) {
      statusText += '\nCycles: ${runner.cycleCount}';
    }
    if (this.statusText.text != statusText) {
      this.statusText.text = statusText;
    }
  }

  private function handleMouse() {
    if (!inputEnabled) {
      return;
    }

    var x = FlxG.mouse.x;
    var y = FlxG.mouse.y;
    var mouseMoved = (x != prevMouseX || y != prevMouseY);
    prevMouseX = x;
    prevMouseY = y;

    if (mouseMoved || FlxG.mouse.pressed || FlxG.mouse.pressedRight) {
      cursorCard = null;
      cursorCol = null;
      cursorRow = null;
      for (card in punchCards) {
        var col = Math.floor((x - card.x - card.paddingX) / card.holeWidth);
        var row = Math.floor((y - card.y - card.paddingY) / card.holeHeight);
        if (col >= 0 && col < card.cols && row >= 0 && row < card.rows && card.isRowEnabled(row)) {
          cursorCard = card.number;
          cursorCol = col;
          cursorRow = row;
        }
      }
      updateCursor();
    }

    if (cursorCard != null && cursorRow != null && cursorCol != null) {
      var card = punchCards[cursorCard];
      var instruction = program.cards[cursorCard][cursorCol];
      if (FlxG.mouse.justPressed) {
        dragType = !instruction.holes[cursorRow];
      }
      if (FlxG.mouse.pressed) {
        card.setHole(cursorCol, cursorRow, dragType);
      } else if (FlxG.mouse.pressedRight) {
        card.setHole(cursorCol, cursorRow, false);
      }
      help.set(instruction.toString());
    }
  }

  private function updateCursor() {
    for (card in punchCards) {
      if (inputEnabled && card.number == cursorCard) {
        card.setCursor(cursorCol, cursorRow);
      } else {
        card.setCursor(null, null);
      }
    }
  }

  private function handleKeys() {
    if (FlxG.keys.justPressed.ENTER) {
      onRunStopClick();
    }
    if (FlxG.keys.justPressed.ESCAPE) {
      if (runner != null) {
        onRunStopClick();
      }
    }
    if (FlxG.keys.justPressed.F1) {
      openSubState(new KeyboardHelpState());
    }
    if (FlxG.keys.justPressed.ONE) {
      onSpeedButtonClick(0);
    }
    if (FlxG.keys.justPressed.TWO) {
      onSpeedButtonClick(1);
    }
    if (FlxG.keys.justPressed.THREE) {
      onSpeedButtonClick(2);
    }
    if (FlxG.keys.justPressed.FOUR) {
      onSpeedButtonClick(3);
    }
    if (inputEnabled) {
      if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W || FlxG.keys.justPressed.Z) {
        moveCursor(0, -1);
      }
      if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S) {
        moveCursor(0, 1);
      }
      if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A) {
        moveCursor(-1, 0);
      }
      if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D) {
        moveCursor(1, 0);
      }
      if (FlxG.keys.justPressed.SPACE) {
        toggleHole();
      }
      if (FlxG.keys.justPressed.PAGEUP) {
        tickWheel(0, FlxG.keys.pressed.SHIFT ? -1 : 1);
      }
      if (FlxG.keys.justPressed.PAGEDOWN) {
        tickWheel(1, FlxG.keys.pressed.SHIFT ? -1 : 1);
      }
    }
  }

  private function moveCursor(colDirection: Int, rowDirection: Int) {
    if (cursorCard == null || cursorRow == null || cursorCol == null) {
      cursorCard = 0;
      cursorCol = 0;
      cursorRow = 0;
    }

    cursorCol = (((cursorCol + colDirection) % puzzle.cardSize) + puzzle.cardSize) % puzzle.cardSize;

    if (rowDirection > 0) {
      do {
        cursorRow++;
        if (cursorRow >= punchCards[cursorCard].rows) {
          cursorCard++;
          if (cursorCard >= punchCards.length) {
            cursorCard = 0;
          }
          cursorRow = 0;
        }
      } while (!punchCards[cursorCard].isRowEnabled(cursorRow));
    } else if (rowDirection < 0) {
      do {
        cursorRow--;
        if (cursorRow < 0) {
          cursorCard--;
          if (cursorCard < 0) {
            cursorCard = punchCards.length - 1;
          }
          cursorRow = punchCards[cursorCard].rows - 1;
        }
      } while (!punchCards[cursorCard].isRowEnabled(cursorRow));
    } else {
      while (!punchCards[cursorCard].isRowEnabled(cursorRow)) {
        cursorRow++;
        if (cursorRow >= punchCards[cursorCard].rows) {
          cursorCard++;
          if (cursorCard >= punchCards.length) {
            cursorCard = 0;
          }
          cursorRow = 0;
        }
      }
    }

    updateCursor();
  }

  private function toggleHole() {
    if (cursorCard != null && cursorCol != null && cursorRow != null) {
      punchCards[cursorCard].toggleHole(cursorCol, cursorRow);
    }
  }

  private function tickWheel(wheelIndex: Int, delta: Int) {
    if (wheelIndex >= 0 && wheelIndex < wheels.length) {
      var wheel = wheels[wheelIndex];
      wheel.value += delta;
      wheel.moveToValue(wheel.value);
      program.wheelStarts[wheelIndex] = wheel.value;
    }
  }

  private function showTooltips() {
    if (runStopButton.mouseIsOver) {
      if (runner != null) {
        help.set("Abort the run and reset the machine (Enter/Esc)");
      } else {
        help.set("Run the program (Enter)");
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
            "Pause program execution (1)",
            "Run program at 1x speed (2)",
            "Run program at 5x speed (3)",
            "Run program at 25x speed (4)",
          ][i]);
        }
      }
    }
  }

  private function win() {
    complete = true;

    Reflect.setField(FlxG.save.data, "solved_" + puzzle.name, true);
    FlxG.save.flush();

    var cycleCount = runner.cycleCount;
    runnerGroup.remove(runner);
    runner = null;

    controlsGroup.forEachExists(function(control) {
      control.active = false;
    });

    var overlay = new ColorSprite(FlxG.width, FlxG.height, 0xff483e37);
    overlay.alpha = 0;
    overlayGroup.add(overlay);
    FlxTween.tween(overlay, {alpha: 1}, 1.0, {ease: FlxEase.sineInOut});

    if (puzzle.title != null) {
      var titleText = new FlxText(0, 16, FlxG.width, '“${puzzle.title}” by Leonardo da Vinci');
      titleText.setFormat(AssetPaths.day_roman__ttf, 20, FlxColor.WHITE, CENTER);
      titleText.setBorderStyle(SHADOW, 0x80000000, 2);
      titleText.alpha = 0;
      overlayGroup.add(titleText);
      FlxTween.tween(titleText, {alpha: 1}, 1.0, {ease: FlxEase.sineInOut});
    }

    var resultText = new FlxText(0, FlxG.height - 48, FlxG.width, 'Completed in ${cycleCount} cycles, using ${program.countHoles()} holes');
    resultText.setFormat(AssetPaths.day_roman__ttf, 20, FlxColor.WHITE, CENTER);
    resultText.setBorderStyle(SHADOW, 0x80000000, 2);
    resultText.alpha = 0;
    overlayGroup.add(resultText);
    FlxTween.tween(resultText, {alpha: 1}, 1.0, {ease: FlxEase.sineInOut});

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
    this.inputEnabled = enabled;
    for (punchCard in punchCards) {
      punchCard.inputEnabled = enabled;
    }
    for (wheelButton in wheelButtons) {
      wheelButton.visible = enabled;
    }
  }
}
