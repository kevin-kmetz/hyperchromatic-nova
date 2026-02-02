/*
 * hyperchromatic-nova/Source/hcnova/dynamics/ViewDynamic.hx
 */

package hcnova.dynamics;

import hcnova.Util;

class ViewDynamic {
  private static final VELOCITY_LOWER_BOUND:Float = -600.0;
  private static final VELOCITY_UPPER_BOUND:Float = 600.0;

  public final velocity_x:Float;
  public final velocity_y:Float;

  // To be implemented.
  //
  // private final zoomUpperBound:Float;
  // private final zoomLowerBound:Float;
  // private final rotationSpeed:Float;

  public function new() {
    velocity_x = getRandomVelocity();
    velocity_y = getRandomVelocity();
  }

  private function getRandomVelocity():Float {
    return Util.randomFloatFromRange(
      ViewDynamic.VELOCITY_LOWER_BOUND,
      ViewDynamic.VELOCITY_UPPER_BOUND
    );
  }
}

