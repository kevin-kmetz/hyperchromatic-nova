/*
 * hyperchromatic-nova/Source/Main.hx
 */

package;

import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.filters.ShaderFilter;
import openfl.utils.ByteArray;

import hcnova.NovaShader;

class Main extends Sprite {
  private final window = Lib.current.stage.window;

  public function new() {
    super();

    displayVisuals();
  }

  private function displayVisuals():Void {
    final data = new BitmapData(1, 1, false, 0x00FFAA55);
    final bitmap = new Bitmap(data);

    bitmap.width = window.width;
    bitmap.height = window.height;

    final custom = new NovaShader();
    bitmap.filters = [new ShaderFilter(custom)];

    addChild(bitmap);
  }
}

