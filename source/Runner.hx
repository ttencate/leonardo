package;

import flixel.FlxBasic;
import flixel.math.FlxMath;

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
    needle.setPos(embroidery.stitchX(needle.col), embroidery.stitchY(needle.row));
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
      remainingInFrame = totalTimeInState - timeSpentInState;
      timeSpentInState = totalTimeInState;
      stateDone = true;
    } else {
      remainingInFrame = 0;
      stateDone = false;
    }
    var stateFraction = totalTimeInState == 0 ? 1 : timeSpentInState / totalTimeInState;

    var instruction = program.cards[currentCard][currentInstruction];
    switch (state) {
      case INSTRUCTION_START:
        var fromX = embroidery.stitchX(needle.col);
        var fromY = embroidery.stitchY(needle.row);
        if (instruction.up || instruction.down || instruction.left || instruction.right) {
          needle.col += instruction.colDelta;
          needle.row += instruction.rowDelta;
          var toX = embroidery.stitchX(needle.col);
          var toY = embroidery.stitchY(needle.row);
          switchState(MOVING_NEEDLE(fromX, fromY, toX, toY), 1.0);
        } else {
          switchState(MOVING_NEEDLE(fromX, fromY, fromX, fromY), 0.0);
        }
      case MOVING_NEEDLE(fromX, fromY, toX, toY):
        needle.setPos(FlxMath.lerp(fromX, toX, stateFraction), FlxMath.lerp(fromY, toY, stateFraction));
        if (stateDone) {
          switchState(NEXT_INSTRUCTION);
        }
      case NEXT_INSTRUCTION:
        currentInstruction++;
        if (currentInstruction >= program.cardSize) {
          switchState(DONE);
        }
        switchState(INSTRUCTION_START);
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
  MOVING_NEEDLE(fromCol: Float, fromRow: Float, toCol: Float, toRow: Float);
  NEXT_INSTRUCTION;
  DONE;
}
