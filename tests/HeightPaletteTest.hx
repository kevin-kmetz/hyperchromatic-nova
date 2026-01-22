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
    toHeightsMat4Test();

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

  private static function toHeightsMat4Test():Void {
    // Quantities of heights that exceed the maximum renderable amount that
    // has been hard-coded are deliberately being tested here. The reason is
    // that I am considering implementing a CPU-based version at some point
    // in the future as a fallback where such a constraint may not apply.
    //
    for (i in 1...129) {
      final palette = HeightPalette.createRandom(i);
      final heightQuantity = palette.pairs.length;
      final lowerHeights = palette.toLowerHeightsMat4();
      final higherHeights = palette.toHigherHeightsMat4();

      assert(heightQuantity == i);
      assert(lowerHeights.length == 16);
      assert(higherHeights.length == 16);

      switch (heightQuantity) {
        case qty if (qty <= 16):
          for (j in 0...(qty - 1))
            assert(lowerHeights[j] <= lowerHeights[j + 1]);
          for (j in qty...16)
            assert(lowerHeights[j] == HeightPalette.TERMINATE_SENTINEL);
          for (j in 0...16)
            assert(higherHeights[j] == HeightPalette.TERMINATE_SENTINEL);
        case qty if (qty > 16):
          assert(lowerHeights[15] <= higherHeights[0]);
          for (j in 0...(16 - 1))
            assert(lowerHeights[j] <= lowerHeights[j + 1]);
          final upperQty = qty <= 32 ? qty - 16 : 16;
          for (j in 0...(upperQty - 1))
            assert(higherHeights[j] <= higherHeights[j + 1]);
          for (j in upperQty...16)
            assert(higherHeights[j] == HeightPalette.TERMINATE_SENTINEL);
      }
    }
  }
}

