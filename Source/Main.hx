/*
 * hyperchromatic-nova/Source/Main.hx
 */

package;

import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObjectShader;
import openfl.display.Sprite;
import openfl.filters.ShaderFilter;

class CustomShader extends DisplayObjectShader {
  @:glFragmentBody("
    gl_FragColor = vec4(
      openfl_TextureCoordv.y,
      0.0,
      openfl_TextureCoordv.x,
      1.0
    );
  ")

  public function new() {
    super();
  }
}

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

    final custom = new CustomShader();
    bitmap.filters = [new ShaderFilter(custom)];

    addChild(bitmap);
  }
}

