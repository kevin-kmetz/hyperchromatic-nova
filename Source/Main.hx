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

    bitmap.width = 600;
    bitmap.height = 600;

    final custom = new NovaShader();
    custom.data.octaves.value = [6];
    bitmap.filters = [new ShaderFilter(custom)];

    addChild(bitmap);
  }
}

