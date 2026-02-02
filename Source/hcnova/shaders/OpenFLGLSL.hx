/*
 * hyperchromatic-nova/Source/hcnova/shaders/OpenFLGLSL.hx
 *
 * Contains the GLSL code snippets copied from the metadata annotations in the
 * DisplayObjectShader class source code. Specifically, the code from the
 * glVertexheader, glFragmentHeader, and glFragmentBody metadata was copied.
 *
 * The original intent was to merely have the NovaShader extend the OpenFL
 * DisplayObjectShader class, but due to the fact that the NovaShader's
 * glFragmentSource text was going to be substantial and complex, a desire
 * was had to split the different parts of the fragment shader GLSL into
 * different files, to be constructed once upon the loading of the module,
 * and then shared among all instances of NovaShader.
 */

/*
================================================================================
The following license is for OpenFL.
Sourced from: https://github.com/openfl/openfl
Original class: https://github.com/openfl/openfl/blob/develop/src/openfl/display/DisplayObjectShader.hx
--------------------------------------------------------------------------------
MIT License

Copyright (c) 2013-2025 Joshua Granick and other OpenFL contributors

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
================================================================================
*/

package hcnova.shaders;

final vertexSource = "
  attribute float openfl_Alpha;
  attribute vec4 openfl_ColorMultiplier;
  attribute vec4 openfl_ColorOffset;
  attribute vec4 openfl_Position;
  attribute vec2 openfl_TextureCoord;

  varying float openfl_Alphav;
  varying vec4 openfl_ColorMultiplierv;
  varying vec4 openfl_ColorOffsetv;
  varying vec2 openfl_TextureCoordv;

  uniform mat4 openfl_Matrix;
  uniform bool openfl_HasColorTransform;
  uniform vec2 openfl_TextureSize;

  void main(void) {
    openfl_Alphav = openfl_Alpha;
    openfl_TextureCoordv = openfl_TextureCoord;

    if (openfl_HasColorTransform) {
      openfl_ColorMultiplierv = openfl_ColorMultiplier;
      openfl_ColorOffsetv = openfl_ColorOffset / 255.0;
    }

    gl_Position = openfl_Matrix * openfl_Position;
  }
";

final fragmentHeader = "
  varying float openfl_Alphav;
  varying vec4 openfl_ColorMultiplierv;
  varying vec4 openfl_ColorOffsetv;
  varying vec2 openfl_TextureCoordv;

  uniform bool openfl_HasColorTransform;
  uniform sampler2D openfl_Texture;
  uniform vec2 openfl_TextureSize;
";

final fragmentBody = "
  vec4 color = texture2D (openfl_Texture, openfl_TextureCoordv);

  if (color.a == 0.0) {
    gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
  } else if (openfl_HasColorTransform) {
    color = vec4 (color.rgb / color.a, color.a);

    mat4 colorMultiplier = mat4 (0);
    colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
    colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
    colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
    colorMultiplier[3][3] = 1.0; // openfl_ColorMultiplierv.w;

    color = clamp (openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);

    if (color.a > 0.0) {
      gl_FragColor = vec4 (color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
    } else {
      gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
    }
  } else {
    gl_FragColor = color * openfl_Alphav;
  }
";

