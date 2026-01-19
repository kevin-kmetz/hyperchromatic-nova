/*
 * hyperchromatic-nova/Source/HeightPalette.hx
 */

package hcnova;

private typedef HeightColorPair = {
  height:Float,
  color:Int,
}

class HeightPalette {
  private static final MIN_HEIGHTS:Int = 2;
  private static final MAX_HEIGHTS:Int = 128;
  private static final MAX_COLOR_VALUE:Int = 0x1000000;

  private final pairs:Array<HeightColorPair>;

  private function new(pairs:Array<HeightColorPair>) {
    this.pairs = pairs;

    this.pairs.sort(function(a:HeightColorPair, b:HeightColorPair):Int {
      // An epsilon approach for float equality is deliberately not
      // utilized here, as it would be over-engineering for a non-issue
      // at present.

      return switch (a.height - b.height) {
        case diff if (diff > 0.0): 1;
        case diff if (diff == 0.0): 0;
        case diff if (diff < 0.0): -1;
        case _: throw "Impossible case.";
      }
    });
  }

  public static function createRandom(?heightCount:Int):HeightPalette {
    final pairs:Array<HeightColorPair> = new Array<HeightColorPair>();

    if (heightCount == null)
      heightCount = Std.random(MAX_HEIGHTS - MIN_HEIGHTS) + MIN_HEIGHTS;

    for (i in 0...heightCount) {
      pairs.push({
        height: Math.random(),
        color: Std.random(MAX_COLOR_VALUE),
      });
    }

    return new HeightPalette(pairs);
  }
}

