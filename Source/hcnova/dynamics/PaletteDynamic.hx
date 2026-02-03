/*
 * hyperchromatic-nova/Source/hcnova/dynamics/PaletteDynamic.hx
 */

package hcnova.dynamics;

import hcnova.Util;

class PaletteDynamic {
  private static final DELTA_LOWER_BOUND = 0.005;
  private static final DELTA_UPPER_BOUND = 0.080;

  public final delta:Float;

  public function new() {
    delta = Util.randomFloat(
      PaletteDynamic.DELTA_LOWER_BOUND,
      PaletteDynamic.DELTA_UPPER_BOUND
    );
  }

  public function _listProperties():Void {
    Util.println('Height delta: $delta\n');
  }
}

