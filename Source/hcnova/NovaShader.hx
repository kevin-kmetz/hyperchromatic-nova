/*
 * hyperchromatic-nova/Source/hcnova/NovaShader.hx
 */

package hcnova;

import openfl.display.Shader;

final novaFragmentHeader = "
  uniform int octaves;  // [1, 10] allowable
                        // [3, 7] ideal
";

final novaFragmentBody = "
  vec2 adjustment = openfl_TextureSize / 600.0;

  const int OCTAVES_LIMIT = 10;
  float persistence = 0.54;  // [0.25, 1.25] allowable
                            // [0.35, 0.70] organic
                            // [0.95, 1.15] etched (detail-dominated)
                            // [0.45, 0.60] balanced
  float lacunarity = 1.70;  // [1.2, 2.3] allowable
                           // [1.6, 2.0] organic
                           // [1.2, 1.7] etched
                           // [1.8, 2.1] standard
                           // <= 1.0, > 3.0 absolute bounds
  float frequency = 1.00;  // [0.25, 24] allowable
                          // [0.5, 12] standard
                          // Should be inversely related to octaves.

  float totalNoise = 0.0;
  float currentFrequency = frequency;
  float currentAmplitude = 1.0;
  float summedAmplitudes = 0.0;

  // The hard-limit early-break pattern must be used for this to work
  // on every platform, as some platforms require shader loops to be
  // more easily observed as deterministic / terminating.
  //
  for (int i = 0; i < OCTAVES_LIMIT; ++i) {
    if (i >= octaves)
      break;

    totalNoise += snoise(openfl_TextureCoordv * adjustment * currentFrequency)
                  * currentAmplitude;
    summedAmplitudes += currentAmplitude;
    currentAmplitude *= persistence;
    currentFrequency *= lacunarity;
  }

  float outputNoise = totalNoise / summedAmplitudes;
  outputNoise = (outputNoise / 2.0) + 0.5;

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
  novaFragmentHeader +
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

