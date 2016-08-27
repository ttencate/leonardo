package;

import flixel.util.FlxColor;

class Program {

  public var numCards(default, null): Int;
  public var cardSize(default, null): Int;
  public var colors(default, null): Array<FlxColor>;
  public var cards(default, null): Array<Array<Instruction>>;
  public var colorIndices(default, null): Array<Int>;

  public function new(numCards: Int, cardSize: Int, colors: Array<FlxColor>) {
    this.numCards = numCards;
    this.cardSize = cardSize;
    this.colors = colors;
    cards = [for (i in 0...numCards) [for (j in 0...cardSize) new Instruction()]];
    colorIndices = [for (i in 0...numCards) i % colors.length];
  }

  public function getThreadColor(card: Int): FlxColor {
    return colors[colorIndices[card]];
  }
}
