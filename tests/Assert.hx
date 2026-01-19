/*
 * hyperchromatic-nova/tests/Assert.hx
 *
 * A simple assert function to be used in unit tests.
 */

package tests;

class Assert {
  public static function assert(
    assertion:Bool, ?message:String, ?pos:haxe.PosInfos
  ):Void {
    if (!assertion) {
      throw "Assertion failed"
          + (message != null ? (": " + message) : "")
          + ' at ${pos.fileName}:${pos.lineNumber}';
    }
  }
}

