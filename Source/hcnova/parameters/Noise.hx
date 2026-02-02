/*
 * hyperchromatic-nova/Source/hcnova/parameters/Noise.hx
 */

package hcnova.parameters;

import hcnova.Util;
import hcnova.dynamics.NoiseDynamic;

class Noise {
  private static final OCTAVES_LOWER_BOUND = 1;
  private static final OCTAVES_UPPER_BOUND = 12;

  private final octaves:Int;
  private final lacunarity:Float;
  private final persistence:Float;
  private final frequency:Float;

  public function new(?bounds:NoiseDynamic) {
    octaves = Util.randomInt(Noise.OCTAVES_LOWER_BOUND, Noise.OCTAVES_UPPER_BOUND);
    lacunarity = Util.randomFloat(bounds.lacunarity_a, bounds.lacunarity_b);
    persistence = Util.randomFloat(bounds.persistence_a, bounds.persistence_b);
    frequency = Util.randomFloat(bounds.frequency_a, bounds.frequency_b);
  }

  private function getRandomOctaves():Int {
    return ;
  }
}

