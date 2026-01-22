/*
 * hyperchromatic-nova/Source/hcnova/NovaShader.hx
 */

package hcnova;

import openfl.display.Shader;

private final novaFragHeaderUniforms = "
  uniform int octaves;  // [1, 10] allowable
                        // [3, 7] ideal

  uniform mat4 heightsLower;
  uniform mat4 heightsHigher;

  uniform sampler2D colorLUT;
";

private final novaFragHeaderLUT = "
  vec4 lutTexel(float i, sampler2D lut) {
    return texture2D(lut, vec2(i, 0.5));
  }
";

private final novaFragHeaderFBM = "
  float fbmNoise(
    int octaves, float persistence, float lacunarity, float frequency
  ) {
    vec2 adjustment = openfl_TextureSize / 600.0;
    const int OCTAVES_LIMIT = 10;

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

    return outputNoise = (outputNoise / 2.0) + 0.5;
  }
";

private final novaFragBody = "
  float persistence = 0.54;  // [0.25, 1.25] allowable
                             // [0.35, 0.70] organic
                             // [0.95, 1.15] etched (detail-dominated)
                             // [0.45, 0.60] balanced
  float lacunarity = 1.70;   // [1.2, 2.3] allowable
                             // [1.6, 2.0] organic
                             // [1.2, 1.7] etched
                             // [1.8, 2.1] standard
                             // <= 1.0, > 3.0 absolute bounds
  float frequency = 1.00;    // [0.25, 24] allowable
                             // [0.5, 12] standard
                             // Should be inversely related to octaves.

  float noiseValue = fbmNoise(octaves, persistence, lacunarity, frequency);

  gl_FragColor = vec4(
    noiseValue,
    0.0,
    noiseValue,
    1.0
  );

  if (openfl_TextureCoordv.x < 0.25) {
    gl_FragColor = lutTexel(openfl_TextureCoordv.x * 4.0, colorLUT);
  }
";

private final novaFragmentSource =
  OpenFLGLSL.fragmentHeader +
  SimplexGLSL.fragmentHeader +
  novaFragHeaderUniforms +
  novaFragHeaderLUT +
  novaFragHeaderFBM +
  "void main(void) {" +
  OpenFLGLSL.fragmentBody +
  novaFragBody +
  "}";

class NovaShader extends Shader {
  public function new() {
    super();

    glVertexSource = OpenFLGLSL.vertexSource;
    glFragmentSource = novaFragmentSource;
  }
}

