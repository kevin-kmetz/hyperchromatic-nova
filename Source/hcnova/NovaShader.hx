/*
 * hyperchromatic-nova/Source/hcnova/NovaShader.hx
 */

package hcnova;

import openfl.display.Shader;

final novaFragmentBody = "
  int octaves = 6;
  float persistence = 1.5;
  float lacunarity = 1.3;

  float totalNoise = 0.0;
  float currentFrequency = 1.0;
  float currentAmplitude = 1.0;
  float summedAmplitudes = 1.0;

  // The following works on desktop targets, but not on the HTML5 target.
  // On the HTML5 target, it claims that a non-constant can not be part of
  // the comparison fo the loop. Replacing it with a fixed number works.
  // Going to see if variables passed in as uniforms rectify this.
  //
  for (int i = 0; i < octaves; ++i) {
    totalNoise += snoise(openfl_TextureCoordv * currentFrequency)
                  * currentAmplitude;
    summedAmplitudes += currentAmplitude;
    currentAmplitude *= persistence;
    currentFrequency *= lacunarity;
  }

  float outputNoise = totalNoise / summedAmplitudes;

  gl_FragColor = vec4(
    outputNoise,
    0.0,
    outputNoise,
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

