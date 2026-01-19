/*
 * hyperchromatic-nova/tests/HeightPaletteTest.hx
 */

package tests;

import hcnova.HeightPalette;

private final assert = Assert.assert;

@:access(hcnova.HeightPalette)
class HeightPaletteTest {
  public static function run():Void {
    trace("Running all tests for the class hcnova.HeightPalette...");

    createRandomTest();
    checkSortedTest();

    trace("...all tests passed!");
  }

  private static function createRandomTest():Void {
    final palette_01 = HeightPalette.createRandom();
    final palette_02 = HeightPalette.createRandom(5);
    final palette_03 = HeightPalette.createRandom(123);

    assert(palette_01.pairs.length >= HeightPalette.MIN_HEIGHTS);
    assert(palette_01.pairs.length < HeightPalette.MAX_HEIGHTS);

    assert(palette_02.pairs.length == 5);
    assert(palette_03.pairs.length == 123);

    for (i in 0...1000) {
       final palette = HeightPalette.createRandom();

       assert(palette.pairs.length >= HeightPalette.MIN_HEIGHTS);
       assert(palette.pairs.length < HeightPalette.MAX_HEIGHTS);
    }
  }

  private static function checkSortedTest():Void {
    final pairs = HeightPalette.createRandom(100).pairs;

    for (i in 0...(pairs.length - 1))
      assert(pairs[i].height <= pairs[i + 1].height);
  }
}

