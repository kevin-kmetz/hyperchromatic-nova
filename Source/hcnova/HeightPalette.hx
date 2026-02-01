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

  private final initialPairs:Array<HeightColorPair>; // No mutation after constructor.
  private final _pairs:Array<HeightColorPair>; // Internals mutate.

  private function new(pairs:Array<HeightColorPair>) {
    initialPairs = pairs;
    sortPairs(initialPairs);

    _pairs = new Array<HeightColorPair>();

    for (p in initialPairs)
      _pairs.push({ height: p.height, color: p.color });
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
    return initialPairs.length;
  }

  private function toHeightsMat4(begin:Int, end:Int):Array<Float> {
    final heights = new Array<Float>();
    final heightQuantity = _pairs.length;

    for (i in begin...end)
      if (i < heightQuantity)
        heights.push(_pairs[i].height);
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
    final heightQuantity = _pairs.length;

    for (i in 0...32)
      if (i < heightQuantity)
        data.setPixel(i, 0, _pairs[i].color);
      else
        data.setPixel(i, 0, HeightPalette.NO_HEIGHT_COLOR);

    return data;
  }

  public function update(constDelta:Float, hpTime:Float):Void {
    resetDupeToInit();

    for (p in _pairs) {
      var initialUpdatedHeight = p.height + constDelta * hpTime;
      final absUpdated = Math.abs(initialUpdatedHeight);
      final updatedFrac = absUpdated - Math.floor(absUpdated);

      if (initialUpdatedHeight >= 0.0)
        p.height = updatedFrac;
      else
        p.height = 1.0 - updatedFrac;
    }

    sortPairs(_pairs);
  }

  // The following sort is mutating.
  //
  private function sortPairs(pairs:Array<HeightColorPair>):Void {
    pairs.sort(function(a:HeightColorPair, b:HeightColorPair):Int {
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

  // The point of the following function is to minimize array and pair garbage
  // churn and collection.
  //
  private function resetDupeToInit():Void {
    for (i in 0...initialPairs.length) {
      final initialPair = initialPairs[i];
      final dupe = _pairs[i];

      dupe.height = initialPair.height;
      dupe.color = initialPair.color;
    }
  }
}

