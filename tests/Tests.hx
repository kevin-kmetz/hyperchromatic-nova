/*
 * hyperchromatic-nova/tests/Tests.hx
 */

package tests;

class Tests {
  private static function main():Void {
    trace("\nNow running all tests for the package 'hcnova'...");

    runAll();

    trace("...all tests for package 'hcnova' passed!\n");
  }

  private static function runAll():Void {
    HeightPaletteTest.run();
  }
}
