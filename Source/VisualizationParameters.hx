/*
 * hyperchromatic-nova/Source/VisualizationParameters.hx
 *
 * This will probably have to be renamed at some point, because technically
 * a visualization can be made up of tweening / interpolating between several
 * of these. I'm not quite sure what the "individual units" should be called,
 * thought.
 */

package;

import openfl.display.BitmapData;

class VisualizationParameters {
  final octaves:Int;
  final persistence:Int;
  final lacunarity:Int;
  final frequency:Int;

  final heightPalette:HeightPalette;

  public function new() {
  }
}

