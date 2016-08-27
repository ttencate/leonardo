package;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class Runner extends FlxBasic {

  public var speed: Float = 1;
  public var done(get, never): Bool;

  private var program: Program;
  private var embroidery: Embroidery;
  private var needle: Needle;
  private var punchCards: Array<PunchCard>;

  private var state: State = INSTRUCTION_START;
  private var totalTimeInState: Float = 0;
  private var timeSpentInState: Float = 0;
  private var currentCard: Int = 0;
  private var currentInstruction: Int = 0;

  public function new(program: Program, embroidery: Embroidery, needle: Needle, punchCards: Array<PunchCard>) {
    super();
    this.program = program;
    this.embroidery = embroidery;
    this.needle = needle;
    this.punchCards = punchCards;

    reset();
  }

  public function reset() {
    needle.col = 0;
    needle.row = 0;
    needle.setEmbroideryPos(needle.col, needle.row);

    embroidery.removeAllStitches();
  }

  private function get_done(): Bool {
    return state == DONE;
  }
  
  override public function update(elapsed: Float) {
    elapsed *= speed;
    while (!done && elapsed > 0) {
      elapsed = tick(elapsed);
    }
  }

  private function tick(remainingInFrame: Float): Float {
    timeSpentInState += remainingInFrame;
    var stateDone;
    if (timeSpentInState >= totalTimeInState) {
      remainingInFrame = timeSpentInState - totalTimeInState;
      timeSpentInState = totalTimeInState;
      stateDone = true;
    } else {
      remainingInFrame = 0;
      stateDone = false;
    }
    var stateFraction = totalTimeInState == 0 ? 1.0 : timeSpentInState / totalTimeInState;

    var instruction = program.cards[currentCard][currentInstruction];
    switch (state) {
      case INSTRUCTION_START:
        switchState(MAYBE_MOVE_NEEDLE);
      case MAYBE_MOVE_NEEDLE:
        if (instruction.up || instruction.down || instruction.left || instruction.right) {
          var fromX = needle.col;
          var fromY = needle.row;
          needle.col += instruction.colDelta;
          needle.row += instruction.rowDelta;
          switchState(MOVING_NEEDLE(fromX, fromY, needle.col, needle.row), 1.0);
        } else {
          switchState(MAYBE_STITCH);
        }
      case MOVING_NEEDLE(fromX, fromY, toX, toY):
        needle.setEmbroideryPos(
            FlxMath.lerp(fromX, toX, stateFraction),
            FlxMath.lerp(fromY, toY, stateFraction));
        if (stateDone) {
          switchState(MAYBE_STITCH);
        }
      case MAYBE_STITCH:
        if (instruction.stitch) {
          var stitch = embroidery.addStitch(needle.col, needle.row, FlxColor.RED);
          switchState(STITCHING(stitch), 1.0);
        } else {
          switchState(NEXT_INSTRUCTION);
        }
      case STITCHING(sprite):
        var S = 0.4;
        if (stateFraction < 0.125) {
          var f = stateFraction * 8;
          needle.setEmbroideryPos(
              FlxMath.lerp(needle.col, needle.col - S, f),
              FlxMath.lerp(needle.row, needle.row - S, f));
        } else if (stateFraction < 0.375) {
          var f = (stateFraction - 0.125) * 4;
          needle.setEmbroideryPos(
              FlxMath.lerp(needle.col - S, needle.col + S, f),
              FlxMath.lerp(needle.row - S, needle.row + S, f));
        } else if (stateFraction < 0.625) {
          var f = (stateFraction - 0.375) * 4;
          needle.setEmbroideryPos(
              needle.col + S,
              FlxMath.lerp(needle.row + S, needle.row - S, f));
        } else if (stateFraction < 0.875) {
          var f = (stateFraction - 0.625) * 4;
          needle.setEmbroideryPos(
              FlxMath.lerp(needle.col + S, needle.col - S, f), 
              FlxMath.lerp(needle.row - S, needle.row + S, f));
        } else {
          var f = (stateFraction - 0.875) * 8;
          needle.setEmbroideryPos(
              FlxMath.lerp(needle.col - S, needle.col, f),
              FlxMath.lerp(needle.row + S, needle.row, f));
        }
        sprite.alpha = stateFraction;
        if (stateDone) {
          switchState(NEXT_INSTRUCTION);
        }
      case NEXT_INSTRUCTION:
        currentInstruction++;
        if (currentInstruction >= program.cardSize) {
          switchState(DONE);
        } else {
          switchState(INSTRUCTION_START);
        }
      case DONE:
    }

    return remainingInFrame;
  }

  private function switchState(nextState: State, duration: Float = 0.0) {
    this.state = nextState;
    this.totalTimeInState = duration;
    this.timeSpentInState = 0;
  }

  private function stateFraction(): Float {
    return totalTimeInState == 0 ? 1 : timeSpentInState / totalTimeInState;
  }
}

enum State {
  INSTRUCTION_START;
  MAYBE_MOVE_NEEDLE;
  MOVING_NEEDLE(fromX: Float, fromY: Float, toX: Float, toY: Float);
  MAYBE_STITCH;
  STITCHING(sprite: FlxSprite);
  NEXT_INSTRUCTION;
  DONE;
}
