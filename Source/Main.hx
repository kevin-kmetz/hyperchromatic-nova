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

import hcnova.NovaShader;

class Main extends Sprite {
  private final window = Lib.current.stage.window;

  private var bitmap:Bitmap;
  private var novaShader:NovaShader;

  public function new() {
    super();

    initBitmapShader();
    registerEventHandlers();
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
}

