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
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.ui.Keyboard;
import openfl.utils.ByteArray;

import hcnova.parameters.HeightPalette;
import hcnova.shaders.NovaShader;

import hcnova.NovaRenderer;

class Main extends Sprite {
  private final window = Lib.current.stage.window;
  private var textUI:TextField = new TextField();
  private var textFormatUI:TextFormat = new TextFormat(
    "helvetica", 20, 0xFFFFFF
  );

  private var bitmap:Bitmap;
  private var novaShader:NovaShader;
  private var palette:HeightPalette;

  private var simulatedTime:Float = Lib.getTimer() / 60.0;
  private var lastFrameTime:Float = Lib.getTimer() / 60.0;
  private var heightDelta:Float = 0.0175;

  private var timeReversed:Bool = false;

  private var shiftIsPressed:Bool = false;

  public function new() {
    super();

    initBitmapShader();
    registerEventHandlers();
    initHeightPalette();
    createColorLUT();
    setShaderUniforms();

    initializeUI();
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
    stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
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

    updateUI();
  }

  private function onKeyDown(event:KeyboardEvent):Void {
    switch (event.keyCode) {
      case Keyboard.R: timeReversed = !timeReversed;
      case Keyboard.C: palette.randomizeColors();
      case Keyboard.H: palette.randomizeHeightsAndColors();
      case Keyboard.O:
        final currentOctaves = novaShader.data.octaves.value[0];
        novaShader.data.octaves.value[0] =
          shiftIsPressed ? currentOctaves - 1 : currentOctaves + 1;
      case Keyboard.MINUS:
        palette.renormalizeHeights(heightDelta, simulatedTime);
        heightDelta -= 0.0025;
        simulatedTime = 0.0;
      case Keyboard.EQUAL:
        palette.renormalizeHeights(heightDelta, simulatedTime);
        heightDelta += 0.0025;
        simulatedTime = 0.0;
      case Keyboard.SHIFT: shiftIsPressed = true;
      // The following is a temporary keybinding for visual testing and debugging.
      case Keyboard.T: new NovaRenderer()._listProperties();
    }
  }

  private function onKeyUp(event:KeyboardEvent):Void {
    switch (event.keyCode) {
      case Keyboard.SHIFT: shiftIsPressed = false;
    }
  }

  private function initializeUI():Void {
    textUI.defaultTextFormat = textFormatUI;
    textUI.text = 'Time elapsed: ${truncateLowFloat(Lib.getTimer() / 60.0)}';
    textUI.width = 240;
    textUI.x = window.width - textUI.width - 5;
    textUI.y = 5;
    textUI.background = true;
    textUI.backgroundColor = 0x9999FF;

    addChild(textUI);
  }

  private function updateUI():Void {
    final intendedPositionX = window.width - textUI.width - 5;
    final intendedPositionY = 5;

    textUI.text = 'Time elapsed: ${truncateLowFloat(Lib.getTimer() / 60.0)}';

    if (textUI.x != intendedPositionX || textUI.y != intendedPositionY) {
      textUI.x = intendedPositionX;
      textUI.y = intendedPositionY;
    }
  }

  // This is hacky, but I really don't want to have to import a third-party
  // library just to make a float cleanly printable, and I don't see any
  // included printf/sprintf-style functions in the Haxe documentation.
  //
  private function truncateLowFloat(f:Float):Float {
    return Math.ffloor(f * 100.0) / 100.00;
  }
}

