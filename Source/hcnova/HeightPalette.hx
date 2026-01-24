/*
 * hyperchromatic-nova/Source/HeightPalette.hx
 */

package hcnova;

import openfl.display.BitmapData;

private typedef HeightColorPair = {
  height:Float,
  color:Int,
}

class HeightPalette {
  private static final MIN_HEIGHTS:Int = 2;
  private static final MAX_HEIGHTS:Int = 32;
  private static final MAX_COLOR_VALUE:Int = 0x1000000;
  private static final TERMINATE_SENTINEL:Float = -5.67;
  private static final BITMAP_DEFAULT_FILL:Int = 0x00AA55;
  private static final NO_HEIGHT_COLOR:Int = 0xFF00FF;

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

  public function getPairsCount():Int {
    return pairs.length;
  }

  private function toHeightsMat4(begin:Int, end:Int):Array<Float> {
    final heights = new Array<Float>();
    final heightQuantity = pairs.length;

    for (i in begin...end)
      if (i < heightQuantity)
        heights.push(pairs[i].height);
      else
        heights.push(HeightPalette.TERMINATE_SENTINEL);

    return heights;
  }

  public function toLowerHeightsMat4():Array<Float> {
    return toHeightsMat4(0, 16);
  }

  public function toHigherHeightsMat4():Array<Float> {
    return toHeightsMat4(16, 32);
  }

  public function toColorLUT():BitmapData {
    final data = new BitmapData(32, 1, false, HeightPalette.BITMAP_DEFAULT_FILL);
    final heightQuantity = pairs.length;

    for (i in 0...32)
      if (i < heightQuantity)
        data.setPixel(i, 0, pairs[i].color);
      else
        data.setPixel(i, 0, HeightPalette.NO_HEIGHT_COLOR);

    return data;
  }
}

