/*
 * hyperchromatic-nova/tests/HeightPaletteTest.hx
 */

package tests;

import hcnova.HeightPalette;

private final assert = Assert.assert;

class HeightPaletteTest {
  public static function run():Void {
    trace("Running all tests for the class hcnova.HeightPalette...");

    createRandomTest();

    trace("...all tests passed!");
  }

  private static function createRandomTest():Void {
    final palette_01 = HeightPalette.createRandom();
    final palette_02 = HeightPalette.createRandom(5);
    final palette_03 = HeightPalette.createRandom(123);

    assert(palette_01.size() >= HeightPalette.MIN_HEIGHTS);
    assert(palette_01.size() < HeightPalette.MAX_HEIGHTS);

    assert(palette_02.size() == 5);
    assert(palette_03.size() == 123);

    for (i in 0...1000) {
       final palette = HeightPalette.createRandom();

       assert(palette.size() >= HeightPalette.MIN_HEIGHTS);
       assert(palette.size() < HeightPalette.MAX_HEIGHTS);
    }
  }
}

