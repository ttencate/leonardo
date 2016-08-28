package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class Needle extends FlxSpriteGroup {

  public var col: Int = 0;
  public var row: Int = 0;

  private var embroidery: Embroidery;
  private var sprite: FlxSprite;
  private var colorSprite: FlxSprite;

  public function new(embroidery: Embroidery) {
    super();
    this.embroidery = embroidery;

    sprite = new FlxSprite(AssetPaths.needle__png);
    add(sprite);

    colorSprite = new FlxSprite(AssetPaths.needle_color__png);
    add(colorSprite);

    setEmbroideryPos(0, 0);
  }

  public function setColor(color: FlxColor) {
    colorSprite.color = color;
    colorSprite.alpha = color.alpha;
  }

  public function setEmbroideryPos(x: Float, y: Float) {
    sprite.setPosition(embroidery.stitchX(x) - 128, embroidery.stitchY(y) - 384);
    colorSprite.setPosition(sprite.x, sprite.y);
  }
}
