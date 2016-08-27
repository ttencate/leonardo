package;

class Instruction {
  public var up(get, never): Bool;
  public var down(get, never): Bool;
  public var left(get, never): Bool;
  public var right(get, never): Bool;
  public var stitch(get, never): Bool;

  public var holes(default, null): Array<Bool> = [for (i in 0...11) false];

  public function new() {
  }

  private function get_up(): Bool { return holes[6]; }
  private function get_down(): Bool { return holes[7]; }
  private function get_left(): Bool { return holes[8]; }
  private function get_right(): Bool { return holes[9]; }
  private function get_stitch(): Bool { return holes[10]; }
}
