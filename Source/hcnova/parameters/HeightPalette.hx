/*
 * hyperchromatic-nova/Source/hcnova/parameters/HeightPalette.hx
 */

package hcnova.parameters;

import openfl.display.BitmapData;

import hcnova.Util;

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

  private var initialPairs:Array<HeightColorPair>;
  private var _pairs:Array<HeightColorPair>;

  private function new(pairs:Array<HeightColorPair>) {
    initialPairs = pairs;
    sortPairs(initialPairs);

    _pairs = new Array<HeightColorPair>();

    for (p in initialPairs)
      _pairs.push({ height: p.height, color: p.color });
  }

  public static function createRandom(?heightCount:Int):HeightPalette {
    final pairs = createRandomPairArray(heightCount);

    return new HeightPalette(pairs);
  }

  public function _listProperties():Void {
    Util.println('Height-color pair count: ${initialPairs.length}\n');
  }

  private static function createRandomPairArray(?heightCount:Int):Array<HeightColorPair> {
    final pairs:Array<HeightColorPair> = new Array<HeightColorPair>();

    if (heightCount == null)
      heightCount = Std.random(MAX_HEIGHTS - MIN_HEIGHTS) + MIN_HEIGHTS;

    for (i in 0...heightCount) {
      pairs.push({
        height: Math.random(),
        color: Std.random(MAX_COLOR_VALUE),
      });
    }

    return pairs;
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

    for (p in _pairs)
      p.height = calculateNewHeight(p.height, constDelta, hpTime);

    sortPairs(_pairs);
  }

  private function calculateNewHeight(
    height:Float, constDelta:Float, hpTime:Float
  ):Float {
    final initialUpdatedHeight = height + constDelta * hpTime;
    final absUpdated = Math.abs(initialUpdatedHeight);
    final updatedFrac = absUpdated - Math.floor(absUpdated);

    return initialUpdatedHeight >= 0.0 ? updatedFrac : 1.0 - updatedFrac;
   }

  public function randomizeColors():Void {
    for (p in initialPairs)
      p.color = Std.random(MAX_COLOR_VALUE);
  }

  public function randomizeHeightsAndColors():Void {
    initialPairs = HeightPalette.createRandomPairArray();

     fullyResetDupe();
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

  // This differs from resetDupeToInit in that resetDupeToInit makes an
  // assumption that the quantity of pairs has remained the same, and in that
  // it reuses the pair, overwriting its values, preventing them from being
  // garbage collected.
  //
  private function fullyResetDupe():Void {
    _pairs = new Array<HeightColorPair>();

    for (p in initialPairs)
      _pairs.push({ height: p.height, color: p.color });
   }

  public function renormalizeHeights(constDelta:Float, hpTime:Float):Void {
    final newPairs = new Array<HeightColorPair>();

    for (ipair in initialPairs) {
      newPairs.push({
        height: calculateNewHeight(ipair.height, constDelta, hpTime),
        color: ipair.color,
      });
    }

    sortPairs(newPairs);

    initialPairs = newPairs;
    fullyResetDupe();
  }
}

