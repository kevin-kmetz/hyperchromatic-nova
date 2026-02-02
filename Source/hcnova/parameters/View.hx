/*
 * hyperchromatic-nova/Source/hcnova/parameters/View.hx
 */

package hcnova.parameters;

import hcnova.Util;

class View {
  private static final COORD_LOWER_LIMIT = -50000.0;
  private static final COORD_UPPER_LIMIT =  50000.0;

  private final x:Float;
  private final y:Float;

  // To be implemented.
  //
  // var zoomLevel:Float;
  // var rotation:Float;

  public function new() {
    x = getRandomComponent();
    y = getRandomComponent();
  }

  private function getRandomComponent():Float {
    return Util.randomFloat(View.COORD_LOWER_LIMIT, View.COORD_UPPER_LIMIT);
  }
}

