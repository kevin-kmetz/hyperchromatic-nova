/*
 * hyperchromatic-nova/Source/hcnova/dynamics/NoiseDynamic.hx
 */

package hcnova.dynamics;

class NoiseDynamic {
  private static final OCTAVES_LOWER_BOUND = 1;
  private static final OCTAVES_UPPER_BOUND = 12;

  private static final LACUNARITY_LOWER_BOUND = 1.20;
  private static final LACUNARITY_UPPER_BOUND = 2.30;

  private static final PERSISTENCE_LOWER_BOUND = 0.25;
  private static final PERSISTENCE_UPPER_BOUND = 1.25;

  private static final FREQUENCY_LOWER_BOUND = 0.25;
  private static final FREQUENCY_UPPER_BOUND = 24.0;

  private static final OSC_FREQ_LOWER_BOUND = 0.0;
  private static final OSC_FREQ_UPPER_BOUND = 2.0;

  private static final OSC_OFFSET_LOWER_BOUND = 0.0;
  private static final OSC_OFFSET_UPPER_BOUND = 100.0;

  // The reason 'a' and 'b' are used instead of "lower" and "upper", is that
  // it should not matter which is lower or upper, because the functions and
  // methods that will be written will be able to tween between them in any
  // case.

  public final lacunarity_a:Float;
  public final lacunarity_b:Float;
  public final lacunarityFrequency:Float;
  public final lacunarityOffset:Float;

  public final persistence_a:Float;
  public final persistence_b:Float;
  public final persistenceFrequency:Float;
  public final persistenceOffset:Float;

  public final frequency_a:Float;
  public final frequency_b:Float;
  public final frequencyFrequency:Float;  // ;)
  public final frequencyOffset:Float;

  // To be implemented.
  //
  // private final octaves_a:Float;
  // private final octaves_b:Float;

  public function new() {
    lacunarity_a = getRandomLacunarity();
    lacunarity_b = getRandomLacunarity();
    lacunarityFrequency = getRandomOscillationFrequency();
    lacunarityOffset = getRandomOscillationOffset();

    persistence_a = getRandomPersistence();
    persistence_b = getRandomPersistence();
    persistenceFrequency = getRandomOscillationFrequency();
    persistenceOffset = getRandomOscillationOffset();

    frequency_a = getRandomFrequency();
    frequency_b = getRandomFrequency();
    frequencyFrequency = getRandomOscillationFrequency();
    frequencyOffset = getRandomOscillationFrequency();
  }

  private function getRandomLacunarity():Float {
    return Util.randomFloat(
      NoiseDynamic.LACUNARITY_LOWER_BOUND,
      NoiseDynamic.LACUNARITY_UPPER_BOUND
    );
  }

  private function getRandomPersistence():Float {
    return Util.randomFloat(
      NoiseDynamic.PERSISTENCE_LOWER_BOUND,
      NoiseDynamic.PERSISTENCE_UPPER_BOUND
    );
  }

  private function getRandomFrequency():Float {
    return Util.randomFloat(
      NoiseDynamic.FREQUENCY_LOWER_BOUND,
      NoiseDynamic.FREQUENCY_UPPER_BOUND
    );
  }

  private function getRandomOscillationFrequency():Float {
    return Util.randomFloat(
      NoiseDynamic.OSC_FREQ_LOWER_BOUND,
      NoiseDynamic.OSC_FREQ_UPPER_BOUND
    );
  }

  private function getRandomOscillationOffset():Float {
    return Util.randomFloat(
      NoiseDynamic.OSC_OFFSET_LOWER_BOUND,
      NoiseDynamic.OSC_OFFSET_UPPER_BOUND
    );
  }
}

