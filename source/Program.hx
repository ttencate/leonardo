package;

class Program {

  public var numCards(default, null): Int;
  public var cardSize(default, null): Int;
  public var cards(default, null): Array<Array<Instruction>>;

  public function new(numCards: Int, cardSize: Int) {
    this.numCards = numCards;
    this.cardSize = cardSize;
    cards = [for (i in 0...numCards) [for (j in 0...cardSize) new Instruction()]];
  }
}
