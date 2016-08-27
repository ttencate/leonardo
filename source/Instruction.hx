package;

using StringTools;

class Instruction {

  public var stitch(get, never): Bool;
  public var move(get, never): Bool;
  public var jump(get, never): Bool;
  public var up(get, never): Bool;
  public var down(get, never): Bool;
  public var left(get, never): Bool;
  public var right(get, never): Bool;

  public var colDelta(get, never): Int;
  public var rowDelta(get, never): Int;

  public var holes(default, null): Array<Bool> = [for (i in 0...11) false];

  public function new() {
  }

  private function get_stitch(): Bool { return holes[5]; }
  private function get_move(): Bool { return !holes[6] && (up || down || left || right); }
  private function get_jump(): Bool { return holes[6] && (up || down || left || right); }
  private function get_up(): Bool { return holes[7] && !holes[8]; }
  private function get_down(): Bool { return holes[8] && !holes[7]; }
  private function get_left(): Bool { return holes[9] && !holes[10]; }
  private function get_right(): Bool { return holes[10] && !holes[9]; }

  private function get_colDelta(): Int { return left ? -1 : right ? 1 : 0; }
  private function get_rowDelta(): Int { return up ? -1 : down ? 1 : 0; }

  public function toString() {
    var text = "";
    if (stitch) {
      if (text != "") {
        text += ", then";
      }
      text += " make a stitch";
    }
    if (move) {
      if (text != "") {
        text += ", then";
      }
      text += " move the needle";
      if (up) {
        text += " up";
      } else if (down) {
        text += " down";
      }
      if ((up || down) && (left || right)) {
        text += " and";
      }
      if (left) {
        text += " to the left";
      } else if (right) {
        text += " to the right";
      }
    }
    if (jump) {
      if (text != "") {
        text += ", then";
      }
      if (up || down) {
        text += " jump";
        if (up) {
          text += " one card up";
        } else if (down) {
          text += " one card down";
        }
      }
      if ((up || down) && (left || right)) {
        text += " and";
      }
      if (left) {
        text += " continue to the left";
      } else if (right) {
        text += " continue to the right";
      }
    }
    text = text.trim();
    if (text == "") {
      text = "do nothing";
    }
    text = text.charAt(0).toUpperCase() + text.substring(1);
    return text;
  }
}
