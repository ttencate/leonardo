package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class Needle extends FlxSpriteGroup {

  public var col: Int = 0;
  public var row: Int = 0;

  private var embroidery: Embroidery;
  private var sprite: FlxSprite;

  public function new(embroidery: Embroidery) {
    super();
    this.embroidery = embroidery;

    sprite = new FlxSprite(AssetPaths.needle__png);
    sprite.offset.set(128, 384);
    add(sprite);

    setEmbroideryPos(0, 0);
  }

  public function setEmbroideryPos(x: Float, y: Float) {
    sprite.setPosition(embroidery.stitchX(x), embroidery.stitchY(y));
  }
}
