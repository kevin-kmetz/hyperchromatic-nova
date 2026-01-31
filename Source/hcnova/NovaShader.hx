/*
 * hyperchromatic-nova/Source/hcnova/NovaShader.hx
 */

package hcnova;

import openfl.display.Shader;

private final novaFragHeaderUniforms = "
  uniform int octaves;  // [1, 10] allowable
                        // [3, 7] ideal

  uniform int heightQuantity;
  uniform mat4 heightsLower;
  uniform mat4 heightsHigher;
  uniform sampler2D actualColors;

  uniform float offset_x;
  uniform float offset_y;

  // Once I'm sure my shader is working, I will rename actualColors to colorLUT
  // and get rid of this sampler. It is merely here for testing reference
  // when I run the program.
  //
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

      vec2 offset = vec2(offset_x, offset_y) / 600.0;
      totalNoise += snoise((openfl_TextureCoordv + offset) * adjustment * currentFrequency)
                    * currentAmplitude;
      summedAmplitudes += currentAmplitude;
      currentAmplitude *= persistence;
      currentFrequency *= lacunarity;
    }

    float outputNoise = totalNoise / summedAmplitudes;

    return outputNoise = (outputNoise / 2.0) + 0.5;
  }
";

private final novaFragHeaderHeightResolve = "
  int indexToColumn(int index) {
    return index / 4;
  }

  int indexToRow(int index) {
    // So apparently WebGL 1.0 doesn't support the modulus operator on
    // int and int.
    //
    // return index % 4;

    return int(mod(float(index), 4.0));
  }

  // The following two functions are necessary because WebGL GLSL 1.0
  // does not allow indexing matrices with variables (the indices must be
  // constants). If it wasn't implemented in this manner, the shader would not
  // run in web browser.
  //
  float getLowerHeight(int column, int row, mat4 lower) {
    vec4 col;
    float height;

    if (column == 0) col = lower[0];
    else if (column == 1) col = lower[1];
    else if (column == 2) col = lower[2];
    else if (column == 3) col = lower[3];

    if (row == 0) height = col[0];
    else if (row == 1) height = col[1];
    else if (row == 2) height = col[2];
    else if (row == 3) height = col[3];

    return height;
  }

  float getHigherHeight(int column, int row, mat4 higher) {
    vec4 col;
    float height;

    if (column == 0) col = higher[0];
    else if (column == 1) col = higher[1];
    else if (column == 2) col = higher[2];
    else if (column == 3) col = higher[3];

    if (row == 0) height = col[0];
    else if (row == 1) height = col[1];
    else if (row == 2) height = col[2];
    else if (row == 3) height = col[3];

    return height;
  }

  // Yes, this function uses a linear search instead of a binary search.
  // The reality is, while binary search CAN be implemented in GLSL, it works
  // best when the thing being searched is a known fixed length. The
  // height-palette, while being passed in fixed-length, is not actually
  // fixed-length, which would complicate the algorithm. Still possible, but
  // until I see that linear search is failing me, I'm not going to prematurely
  // optimize the function.
  //
  int noiseToIndex(float noise, int heightQty, mat4 lower, mat4 higher) {
    int decidedIndex = 0;
    if (heightQty > 32) heightQty = 32;

    for (int i = 0; i < 32; ++i) {
      if (i == heightQty)
        break;

      if (i < 16) {
        int column = indexToColumn(i);
        int row = indexToRow(i);

        if (noise <= getLowerHeight(column, row, lower)) {
          decidedIndex = i;
          break;
        }
      } else if (i >= 16) {
        int adjustedIndex = i - 16;
        int column = indexToColumn(adjustedIndex);
        int row = indexToRow(adjustedIndex);

        if (noise <= getHigherHeight(column, row, higher)) {
          decidedIndex = i;
          break;
        }
      }
    }

    return decidedIndex;
  }

  vec4 indexToColor(int index, sampler2D colors) {
    float x =  (float(index) + 0.5) / 32.0;

    return texture2D(colors, vec2(x, 0.5));
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
  int index = noiseToIndex(noiseValue, heightQuantity, heightsLower, heightsHigher);
  vec4 heightColor = indexToColor(index, actualColors);

  /*gl_FragColor = vec4(
    noiseValue,
    0.0,
    noiseValue,
    1.0
  );*/

  gl_FragColor = heightColor;

  if (openfl_TextureCoordv.x < 0.25 && openfl_TextureCoordv.y > 0.85) {
    gl_FragColor = lutTexel(openfl_TextureCoordv.x * 4.0, colorLUT);
  }
";

// This will eventually be updated to use a string builder instead of string
// concatenation.
//
private final novaFragmentSource =
  OpenFLGLSL.fragmentHeader +
  SimplexGLSL.fragmentHeader +
  novaFragHeaderUniforms +
  novaFragHeaderLUT +
  novaFragHeaderFBM +
  novaFragHeaderHeightResolve +
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

