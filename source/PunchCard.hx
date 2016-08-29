package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class PunchCard extends FlxSpriteGroup {

  private static inline var highlightColor = 0x80ffffff;

  public var inputEnabled: Bool = true;

  private var puzzle: Puzzle;
  private var program: Program;
  public var number(default, null): Int;
  private var help: HelpText;

  public var paddingX(default, null): Float = 94;
  public var paddingY(default, null): Float = 0;
  public var rows(default, null): Int;
  public var cols(default, null): Int;

  public var holeWidth(default, null): Int;
  public var holeHeight(default, null): Int;

  private var colHighlight: FlxSprite;
  private var rowHighlight: FlxSprite;
  private var colorHighlight: FlxSprite;

  private var holes: Array<FlxSprite>;

  private var swatch: FlxSprite;

  public function new(puzzle: Puzzle, program: Program, number: Int, help: HelpText) {
    super();
    this.puzzle = puzzle;
    this.program = program;
    this.number = number;
    this.help = help;
    this.rows = program.cards[number][0].holes.length;
    this.cols = puzzle.cardSize;

    var holeSprite = new FlxSprite(AssetPaths.hole__png);
    holeWidth = Math.ceil(holeSprite.width);
    holeHeight = Math.ceil(holeSprite.height);

    add(new FlxSprite(AssetPaths.punch_card__png));
    add(new FlxSprite(paddingX + puzzle.cardSize * holeWidth, 0, AssetPaths.punch_card_right__png));
    for (row in 0...rows) {
      if (!isRowEnabled(row)) {
        var blackOut = new ColorSprite(30, 10, 0xff483e37);
        blackOut.x = 64;
        blackOut.y = row * holeHeight;
        add(blackOut);
      }
    }

    colHighlight = makeColHighlight();
    colHighlight.y = paddingY;
    colHighlight.visible = false;
    add(colHighlight);
    rowHighlight = new ColorSprite(30 + cols * holeWidth, holeHeight, highlightColor);
    rowHighlight.x = paddingX - 30;
    rowHighlight.visible = false;
    add(rowHighlight);

    holes = [for (i in 0...(rows*cols)) null];
    for (col in 0...cols) {
      for (row in 0...rows) {
        if (program.cards[number][col].holes[row]) {
          toggleHole(col, row);
        }
      }
    }

    swatch = new ColorSprite(30, 30, FlxColor.WHITE);
    swatch.color = program.getThreadColor(number);
    swatch.setPosition(14, 40);
    add(swatch);

    colorHighlight = new ColorSprite(40, 40, 0x40ffffff);
    colorHighlight.setPosition(9, 35);
    add(colorHighlight);
  }

  public function isRowEnabled(row: Int): Bool {
    return Instruction.isRowEnabled(row, puzzle);
  }

  public function makeColHighlight(): FlxSprite {
    return new ColorSprite(holeWidth, rows * holeHeight, highlightColor);
  }

  override public function update(elapsed: Float) {
    if (!inputEnabled) {
      colHighlight.visible = false;
      rowHighlight.visible = false;
      colorHighlight.visible = false;
      return;
    }

    var x = FlxG.mouse.x;
    var y = FlxG.mouse.y;
    var col = Math.floor((x - this.x - paddingX) / holeWidth);
    var row = Math.floor((y - this.y - paddingY) / holeHeight);
    if (col >= -3 && col < 0 && row >= 0 && row < rows && isRowEnabled(row)) {
      help.set(Instruction.helpForRow(row));
    }

    var ch = colorHighlight;
    if (x >= ch.x && x < ch.x + ch.width && y >= ch.y && y < ch.y + ch.height) {
      help.set("Click or right-click to change the colour used by this punch card");
      colorHighlight.visible = true;
      colorHighlight.alpha = FlxG.mouse.pressed ? 1.0 : 0.5;
      if (FlxG.mouse.justPressed) {
        cycleColor(1);
      } else if (FlxG.mouse.justPressedRight) {
        cycleColor(-1);
      }
    } else {
      colorHighlight.visible = false;
    }
  }

  public function setCursor(col: Null<Int>, row: Null<Int>) {
    if (col == null || row == null) {
      colHighlight.visible = false;
      rowHighlight.visible = false;
    } else {
      colHighlight.visible = true;
      rowHighlight.visible = true;
      colHighlight.x = this.x + paddingX + col * holeWidth;
      rowHighlight.y = this.y + paddingY + row * holeHeight;
    }
  }

  public function setHole(col: Int, row: Int, hole: Bool) {
    var index = row * cols + col;
    if ((holes[index] != null) != hole) {
      toggleHole(col, row);
    }
  }

  public function toggleHole(col: Int, row: Int) {
    var index = row * cols + col;
    if (holes[index] != null) {
      remove(holes[index]);
      holes[index] = null;
      program.cards[number][col].holes[row] = false;
    } else {
      var hole = new FlxSprite(paddingX + col * holeWidth, paddingY + row * holeHeight, AssetPaths.hole__png);
      holes[index] = hole;
      add(hole);
      program.cards[number][col].holes[row] = true;
    }
  }

  private function cycleColor(direction: Int = 1) {
    program.colorIndices[number] = (program.colorIndices[number] + puzzle.colors.length + direction) % puzzle.colors.length;
    swatch.color = program.getThreadColor(number);
  }
}
