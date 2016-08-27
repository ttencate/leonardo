package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class PunchCard extends FlxSpriteGroup {

  private static inline var highlightColor = 0x80ffffff;

  private var program: Program;
  private var number: Int;

  private var paddingX: Float = 94;
  private var paddingY: Float = 0;
  private var rows: Int = 11;
  private var cols: Int = 92;

  private var holeSprite: FlxSprite;
  private var holeWidth: Int;
  private var holeHeight: Int;

  private var colHighlight: FlxSprite;
  private var rowHighlight: FlxSprite;

  private var holes: Array<FlxSprite>;

  public function new(program: Program, number: Int) {
    super();
    this.program = program;
    this.number = number;

    var background = new FlxSprite(AssetPaths.punch_card__png);
    add(background);

    holeSprite = new FlxSprite(AssetPaths.hole__png);
    holeWidth = Math.ceil(holeSprite.width);
    holeHeight = Math.ceil(holeSprite.height);

    colHighlight = new ColorSprite(holeWidth, rows * holeHeight, highlightColor);
    colHighlight.y = paddingY;
    add(colHighlight);
    rowHighlight = new ColorSprite(30 + cols * holeWidth, holeHeight, highlightColor);
    rowHighlight.x = paddingX - 30;
    add(rowHighlight);

    holes = [for (i in 0...(rows*cols)) null];
  }

  override public function update(elapsed: Float) {
    var x = FlxG.mouse.x;
    var y = FlxG.mouse.y;
    var col = Math.floor((x - this.x - paddingX) / holeSprite.width);
    var row = Math.floor((y - this.y - paddingY) / holeSprite.height);
    if (col >= 0 && col < cols && row >= 0 && row < rows) {
      colHighlight.visible = true;
      rowHighlight.visible = true;
      colHighlight.x = this.x + paddingX + col * holeWidth;
      rowHighlight.y = this.y + paddingY + row * holeHeight;
      if (FlxG.mouse.justPressed) {
        toggleHole(col, row);
      }
    } else {
      colHighlight.visible = false;
      rowHighlight.visible = false;
    }
  }

  private function toggleHole(col: Int, row: Int) {
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
}
