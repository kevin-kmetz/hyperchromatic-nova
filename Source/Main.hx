/*
 * hyperchromatic-nova/Source/Main.hx
 */

package;

import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.filters.ShaderFilter;
import openfl.utils.ByteArray;

import hcnova.HeightPalette;
import hcnova.NovaShader;

class Main extends Sprite {
  private final window = Lib.current.stage.window;

  private var bitmap:Bitmap;
  private var novaShader:NovaShader;

  public function new() {
    super();

    initBitmapShader();
    registerEventHandlers();
    createColorLUT();
    setShaderUniforms();
  }

  private function initBitmapShader():Void {
    final data = new BitmapData(1, 1, false, 0x00FFAA55);
    bitmap = new Bitmap(data);

    bitmap.width = window.width;
    bitmap.height = window.height;

    novaShader = new NovaShader();
    novaShader.data.octaves.value = [6];
    bitmap.filters = [new ShaderFilter(novaShader)];

    addChild(bitmap);
  }

  private function registerEventHandlers():Void {
    stage.addEventListener(Event.RESIZE, onResize);
  }

  private function onResize(event:Event):Void {
    bitmap.width = window.width;
    bitmap.height = window.height;

    stage.invalidate();
  }

  private function createColorLUT():BitmapData {
    final colorData = new BitmapData(32, 1, false, 0x0000AA55);

    for (i in 0...8)
      colorData.setPixel(i, 0, 0xFF0000);

    for (i in 8...16)
      colorData.setPixel(i, 0, 0x00FF00);

    for (i in 16...24)
      colorData.setPixel(i, 0, 0x0000FF);

    for (i in 24...32)
      colorData.setPixel(i, 0, 0xFFFF00);

    novaShader.data.colorLUT.input = colorData;
    return colorData;
  }

  private function initHeightPalette():Void {
    final palette = HeightPalette.createRandom();
  }

  private function setShaderUniforms():Void {
    // novaShader.data.lowerHeights.value = [];

    // novaShader.data.lowerHeights.value = [];
  }
}

