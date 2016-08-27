package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class Needle extends FlxSpriteGroup {

  private var embroidery: Embroidery;
  private var sprite: FlxSprite;

  public function new(embroidery: Embroidery) {
    super();
    this.embroidery = embroidery;

    sprite = new FlxSprite(AssetPaths.needle__png);
    sprite.offset.set(128, 384);
    sprite.x = embroidery.stitchX(0);
    sprite.y = embroidery.stitchY(0);
    add(sprite);
  }
}
