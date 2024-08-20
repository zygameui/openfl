package openfl.display;

import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class MultiTextureShader extends Shader
{
    @:glVertexHeader("attribute float openfl_Alpha;
		attribute vec4 openfl_ColorMultiplier;
		attribute vec4 openfl_ColorOffset;
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		attribute float openfl_TextureId;

		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;
		varying float openfl_TextureIdv;

		uniform mat4 openfl_Matrix;
		uniform bool openfl_HasColorTransform;
		uniform vec2 openfl_TextureSize;")
    @:glVertexBody("openfl_Alphav = openfl_Alpha;
		openfl_TextureCoordv = openfl_TextureCoord;

		if (openfl_HasColorTransform) {

			openfl_ColorMultiplierv = openfl_ColorMultiplier;
			openfl_ColorOffsetv = openfl_ColorOffset / 255.0;

		}

		openfl_TextureIdv = openfl_TextureId;

		gl_Position = openfl_Matrix * openfl_Position;")
    @:glVertexSource("#pragma header

		void main(void) {

			#pragma body

		}")
    @:glFragmentHeader("varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;
		varying float openfl_TextureIdv;

		uniform bool openfl_HasColorTransform;
		//uniform sampler2D uSamplers[16];
		uniform sampler2D uSampler0;
		uniform sampler2D uSampler1;
		uniform sampler2D uSampler2;
		uniform sampler2D uSampler3;
		uniform sampler2D uSampler4;
		uniform sampler2D uSampler5;
		uniform sampler2D uSampler6;
		uniform sampler2D uSampler7;
		uniform sampler2D uSampler8;
		uniform sampler2D uSampler9;
		uniform sampler2D uSampler10;
		uniform sampler2D uSampler11;
		uniform sampler2D uSampler12;
		uniform sampler2D uSampler13;
		uniform sampler2D uSampler14;
		uniform sampler2D uSampler15;
		uniform vec2 openfl_TextureSize;")
    @:glFragmentBody("
        vec4 color;
		//vec4 color = texture2D (openfl_Texture, openfl_TextureCoordv);
		float vTextureId = openfl_TextureIdv;
		/*if (vTextureId < 0.5) {
			color = texture2D(uSamplers[0], openfl_TextureCoordv);
		} else if (vTextureId < 1.5) {
			color = texture2D(uSamplers[1], openfl_TextureCoordv);
		} else if (vTextureId < 2.5) {
			color = texture2D(uSamplers[2], openfl_TextureCoordv);
		} else if (vTextureId < 3.5) {
			color = texture2D(uSamplers[3], openfl_TextureCoordv);
		} else if (vTextureId < 4.5) {
			color = texture2D(uSamplers[4], openfl_TextureCoordv);
		} else if (vTextureId < 5.5) {
			color = texture2D(uSamplers[5], openfl_TextureCoordv);
		} else if (vTextureId < 6.5) {
			color = texture2D(uSamplers[6], openfl_TextureCoordv);
		} else if (vTextureId < 7.5) {
			color = texture2D(uSamplers[7], openfl_TextureCoordv);
		} else if (vTextureId < 8.5) {
			color = texture2D(uSamplers[8], openfl_TextureCoordv);
		} else if (vTextureId < 9.5) {
			color = texture2D(uSamplers[9], openfl_TextureCoordv);
		} else if (vTextureId < 10.5) {
			color = texture2D(uSamplers[10], openfl_TextureCoordv);
		} else if (vTextureId < 11.5) {
			color = texture2D(uSamplers[11], openfl_TextureCoordv);
		} else if (vTextureId < 12.5) {
			color = texture2D(uSamplers[12], openfl_TextureCoordv);
		} else if (vTextureId < 13.5) {
			color = texture2D(uSamplers[13], openfl_TextureCoordv);
		} else if (vTextureId < 14.5) {
			color = texture2D(uSamplers[14], openfl_TextureCoordv);
		} else {
			color = texture2D(uSamplers[15], openfl_TextureCoordv);
		}*/

		if (vTextureId < 0.5) {
			color = texture2D(uSampler0, openfl_TextureCoordv);
		} else if (vTextureId < 1.5) {
			color = texture2D(uSampler1, openfl_TextureCoordv);
		} else if (vTextureId < 2.5) {
			color = texture2D(uSampler2, openfl_TextureCoordv);
		} else if (vTextureId < 3.5) {
			color = texture2D(uSampler3, openfl_TextureCoordv);
		} else if (vTextureId < 4.5) {
			color = texture2D(uSampler4, openfl_TextureCoordv);
		} else if (vTextureId < 5.5) {
			color = texture2D(uSampler5, openfl_TextureCoordv);
		} else if (vTextureId < 6.5) {
			color = texture2D(uSampler6, openfl_TextureCoordv);
		} else if (vTextureId < 7.5) {
			color = texture2D(uSampler7, openfl_TextureCoordv);
		} else if (vTextureId < 8.5) {
			color = texture2D(uSampler8, openfl_TextureCoordv);
		} else if (vTextureId < 9.5) {
			color = texture2D(uSampler9, openfl_TextureCoordv);
		} else if (vTextureId < 10.5) {
			color = texture2D(uSampler10, openfl_TextureCoordv);
		} else if (vTextureId < 11.5) {
			color = texture2D(uSampler11, openfl_TextureCoordv);
		} else if (vTextureId < 12.5) {
			color = texture2D(uSampler12, openfl_TextureCoordv);
		} else if (vTextureId < 13.5) {
			color = texture2D(uSampler13, openfl_TextureCoordv);
		} else if (vTextureId < 14.5) {
			color = texture2D(uSampler14, openfl_TextureCoordv);
		} else {
			color = texture2D(uSampler15, openfl_TextureCoordv);
		}

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

		}")
    #if emscripten
	@:glFragmentSource("#pragma header

		void main(void) {

			#pragma body

			gl_FragColor = gl_FragColor.bgra;

		}")
	#else
    @:glFragmentSource("#pragma header

		void main(void) {

			#pragma body

		}")
    #end
    public function new(code:ByteArray = null)
    {
        super(code);
    }
}
