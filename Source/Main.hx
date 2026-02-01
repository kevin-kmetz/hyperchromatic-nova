/*
 * hyperchromatic-nova/Source/Main.hx
 */

package;

import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.filters.ShaderFilter;
import openfl.ui.Keyboard;
import openfl.utils.ByteArray;

import hcnova.HeightPalette;
import hcnova.NovaShader;

class Main extends Sprite {
  private final window = Lib.current.stage.window;

  private var bitmap:Bitmap;
  private var novaShader:NovaShader;
  private var palette:HeightPalette;

  private var simulatedTime:Float = Lib.getTimer() / 60.0;
  private var lastFrameTime:Float = Lib.getTimer() / 60.0;
  private var heightDelta:Float = 0.0175;

  private var timeReversed:Bool = false;

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
    stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
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

    novaShader.data.offset_x.value = [200000.0];
    novaShader.data.offset_y.value = [-76000.0];
  }

  private function onEnterFrame(event:Event):Void {
    final currentFrameTime = Lib.getTimer() / 60.0;
    final frameDelta = currentFrameTime - lastFrameTime;
    lastFrameTime = currentFrameTime;

    simulatedTime += (timeReversed ? -frameDelta : frameDelta);

    palette.update(heightDelta, simulatedTime);
    novaShader.data.colorLUT.input = palette.toColorLUT();
    setShaderUniforms();
    bitmap.filters = [new ShaderFilter(novaShader)];
    bitmap.invalidate();
  }

  private function onKeyDown(event:KeyboardEvent):Void {
    switch (event.keyCode) {
      case Keyboard.R: timeReversed = !timeReversed;
    }
  }
}

