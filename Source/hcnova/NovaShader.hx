/*
 * hyperchromatic-nova/Source/hcnova/NovaShader.hx
 */

package hcnova;

import openfl.display.Shader;

final novaFragmentBody = "
  gl_FragColor = vec4(
    openfl_TextureCoordv.y,
    0.0,
    openfl_TextureCoordv.x,
    1.0
  );
";

final novaFragmentSource =
  OpenFLGLSL.fragmentHeader +
  "void main(void) {" +
  OpenFLGLSL.fragmentBody +
  novaFragmentBody +
  "}";

class NovaShader extends Shader {
  public function new() {
    super();

    glVertexSource = OpenFLGLSL.vertexSource;
    glFragmentSource = novaFragmentSource;
  }
}

