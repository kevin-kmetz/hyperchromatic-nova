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
  private var palette:HeightPalette;

  public function new() {
    super();

    initBitmapShader();
    registerEventHandlers();
    initHeightPalette();
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
    addEventListener(Event.ENTER_FRAME, onEnterFrame);
  }

  private function onResize(event:Event):Void {
    bitmap.width = window.width;
    bitmap.height = window.height;

    stage.invalidate();
  }

  private function createColorLUT():BitmapData {
    final colorLUT = palette.toColorLUT();
    novaShader.data.colorLUT.input = colorLUT;

    return colorLUT;
  }

  private function initHeightPalette():Void {
    palette = HeightPalette.createRandom();
  }

  private function setShaderUniforms():Void {
    novaShader.data.heightQuantity.value = [palette.getPairsCount()];
    novaShader.data.heightsLower.value = palette.toLowerHeightsMat4();
    novaShader.data.heightsHigher.value = palette.toHigherHeightsMat4();
    novaShader.data.actualColors.input = palette.toColorLUT();
  }

  private function onEnterFrame(event:Event):Void {
    final delta = 0.010;

    palette.incrementHeights(delta);
    novaShader.data.colorLUT.input = palette.toColorLUT();
    setShaderUniforms();
    bitmap.filters = [new ShaderFilter(novaShader)];
    bitmap.invalidate();
  }
}

