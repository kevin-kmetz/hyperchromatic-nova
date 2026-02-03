/*
 * hyperchromatic-nova/Source/hcnova/NovaRenderer.hx
 */

package hcnova;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;

import hcnova.parameters.HeightPalette;
import hcnova.parameters.Noise;
import hcnova.parameters.View;

import hcnova.dynamics.NoiseDynamic;
import hcnova.dynamics.PaletteDynamic;
import hcnova.dynamics.ViewDynamic;

import hcnova.shaders.NovaShader;

import hcnova.Util;

class NovaRenderer {
  private final palette:HeightPalette;
  private final noise:Noise;
  private final view:View;

  private final noiseDynamic:NoiseDynamic;
  private final paletteDynamic:PaletteDynamic;
  private final viewDynamic:ViewDynamic;

  private final bitmap:Bitmap;
  private final shader:NovaShader;
  private final filters:Array<BitmapFilter>;

  public function new(width:Int, height:Int) {
    noiseDynamic = new NoiseDynamic();

    palette = HeightPalette.createRandom();
    noise = new Noise(noiseDynamic);
    view = new View();

    paletteDynamic = new PaletteDynamic();
    viewDynamic = new ViewDynamic();

    bitmap = createBitmap(width, height);
    shader = createShader(palette, noise, view);
    filters = [new ShaderFilter(shader)];
    bitmap.filters = filters;
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

  private function createBitmap(width:Int, height:Int):Bitmap {
    final data = new BitmapData(1, 1, false, 0x00FFAA55);
    final bitmap = new Bitmap(data);

    bitmap.width = width;
    bitmap.height = height;

    return bitmap;
  }

  // Shadowing here is deliberate. I want to see the arguments in case I ever
  // spin this out of the class.
  //
  private function createShader(
    palette:HeightPalette, noise:Noise, view:View
  ):NovaShader {
    final shader = new NovaShader();
    shader.initializeUniformsAndSamplers(palette, noise, view);

    return shader;
  }
}

