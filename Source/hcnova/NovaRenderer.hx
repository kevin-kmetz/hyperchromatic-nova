/*
 * hyperchromatic-nova/Source/hcnova/NovaRenderer.hx
 */

package hcnova;

import hcnova.parameters.HeightPalette;
import hcnova.parameters.Noise;
import hcnova.parameters.View;

import hcnova.dynamics.NoiseDynamic;
import hcnova.dynamics.PaletteDynamic;
import hcnova.dynamics.ViewDynamic;

import hcnova.Util;

class NovaRenderer {
  private final palette:HeightPalette;
  private final noise:Noise;
  private final view:View;

  private final noiseDynamic:NoiseDynamic;
  private final paletteDynamic:PaletteDynamic;
  private final viewDynamic:ViewDynamic;

  public function new() {
    noiseDynamic = new NoiseDynamic();

    palette = HeightPalette.createRandom();
    noise = new Noise(noiseDynamic);
    view = new View();

    paletteDynamic = new PaletteDynamic();
    viewDynamic = new ViewDynamic();
  }

  public function _listProperties():Void {
    Util.println("\n===== Properties for a NovaRenderer =====");

    palette._listProperties();
    noise._listProperties();
    view._listProperties();

    noiseDynamic._listProperties();
    paletteDynamic._listProperties();
    viewDynamic._listProperties();
  }
}

