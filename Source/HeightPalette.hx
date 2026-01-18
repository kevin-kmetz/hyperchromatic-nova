/*
 * hyperchromatic-nova/Source/HeightPalette.hx
 */

private typedef HeightColorPair = {
  height:Float,
  color:Int,
}

class HeightPalette {
  private static final MAX_HEIGHTS:Int = 128;
  private static final MAX_COLOR_VALUE:Int = 0x1000000;

  private final palette:Array<HeightColorPair>;

  private function new(pairs:Array<HeightColorPair>) {
    palette = pairs;
  }

  public static function createRandom(?heightCount:Int):HeightPalette {
    final pairs:Array<HeightColorPair> = new Array<HeightColorPair>();

    if (heightCount == null)
      heightCount = Std.random(MAX_HEIGHTS);

    for (i in 0...heightCount) {
      pairs.push({
        height = Math.random,
        color = Std.random(MAX_COLOR_VALUE),
      });
    }

    return HeightPalette.new(pairs);
  }
}
