/*
 * hyperchromatic-nova/Source/hcnova/NovaShader.hx
 */

package hcnova;

import openfl.display.Shader;

final novaFragmentBody = "
  float noise_val = snoise(openfl_TextureCoordv);

  gl_FragColor = vec4(
    noise_val,
    0.0,
    noise_val,
    1.0
  );
";

final novaFragmentSource =
  OpenFLGLSL.fragmentHeader +
  SimplexGLSL.fragmentHeader +
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

