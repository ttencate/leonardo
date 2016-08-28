package;

import flixel.util.FlxColor;
import haxe.Json;

class Program {

  public var puzzle(default, null): Puzzle;

  public var cards(default, null): Array<Array<Instruction>>;
  public var colorIndices(default, null): Array<Int>;

  public function new(puzzle: Puzzle) {
    this.puzzle = puzzle;
    cards = [for (i in 0...puzzle.numCards) [for (j in 0...puzzle.cardSize) new Instruction()]];
    colorIndices = [for (i in 0...puzzle.numCards) i % puzzle.colors.length];
  }

  public function getThreadColor(card: Int): FlxColor {
    return puzzle.colors[colorIndices[card]];
  }

  public function toJson(): String {
    return Json.stringify({
      cards: [for (card in cards) [for (instruction in card) instruction.toInt()]],
      colorIndices: colorIndices,
    });
  }

  public function fromJson(puzzle: Puzzle, json: String) {
    if (json == null) {
      return;
    }
    try {
      var j = Json.parse(json);
      for (card in 0...cards.length) {
        for (i in 0...cards[card].length) {
          var instruction = j.cards[card][i];
          if (instruction != null) {
            cards[card][i] = Instruction.fromInt(instruction);
          }
        }
        var colorIndex = j.colorIndices[card];
        if (colorIndex != null) {
          colorIndices[card] = colorIndex % puzzle.colors.length;
        }
      }
    } catch (ex: Dynamic) {
      return;
    }
  }
}
