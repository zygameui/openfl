package openfl.display._internal;

#if !flash
import openfl.display.Bitmap;
import openfl.display.OpenGLRenderer;
import openfl.display3D.VertexBuffer3D;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml(' tags="haxe,release" ')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Shader)
@:access(openfl.display.Stage)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@SuppressWarnings("checkstyle:FieldDocComment")
class Context3DBitmap
{
	public static function render(bitmap:Bitmap, renderer:OpenGLRenderer):Void
	{
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0) return;

		if (bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid)
		{
			#if openfl_experimental_multitexture
			var allowedToMultiRender:Bool = eligableForMultiTexture(bitmap, renderer);
			if(allowedToMultiRender)
			{
				renderer.__bitmapRenderPool.push(bitmap);
			}else #end {
				renderer.begin();

				var context = renderer.__context3D;
				flush(bitmap, renderer);
			}

		}
	}

	#if openfl_experimental_multitexture
	public static inline function eligableForMultiTexture(bitmap:Bitmap, renderer:OpenGLRenderer):Bool
	{
		return bitmap.__worldShader == null && bitmap.__mask == null && bitmap.__scrollRect == null && bitmap.__blendMode == NORMAL;
	}
	#end

	private static function flush(bitmap:Bitmap, renderer:OpenGLRenderer #if openfl_experimental_multitexture, vertexBuffer:VertexBuffer3D = null, multiTextureShader:MultiTextureShader = null, bitmapRenderPool:Array<Bitmap> = null, textureId:Int = 0 #end):Void
	{
		var context = renderer.__context3D;
		//renderer.begin();

		var isMultiTexture:Bool = #if openfl_experimental_multitexture bitmapRenderPool != null #else false #end;
		if(!isMultiTexture)
		{
			renderer.__setBlendMode(bitmap.__worldBlendMode);
			renderer.__pushMaskObject(bitmap);
		}
		// renderer.filterManager.pushObject (bitmap);

		var worldShader = bitmap.__worldShader;
		#if openfl_experimental_multitexture
		if(worldShader == null)
		{
			worldShader = multiTextureShader;
		}
		#end

        var shader = renderer.__initDisplayShader(cast worldShader);
        renderer.setShader(shader);
        renderer.applyBitmapData(bitmap.__bitmapData, renderer.__allowSmoothing && (bitmap.smoothing || renderer.__upscaled));
        renderer.applyMatrix(renderer.__getMatrix(bitmap.__renderTransform, bitmap.pixelSnapping));
		renderer.applyAlpha(bitmap.__worldAlpha);
        renderer.applyColorTransform(bitmap.__worldColorTransform);
		#if openfl_experimental_multitexture
		renderer.applyTextureId(textureId);
		#end
        renderer.updateShader();
		#if openfl_experimental_multitexture
		if(isMultiTexture)
		{
			var length:Int = Std.int(Math.min(bitmapRenderPool.length, context.__quadIndexBufferElements));

			if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_2); // 0x00 - 0x02
			if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 2, FLOAT_2); // 0x03 - 0x04
			if (shader.__textureId != null) context.setVertexBufferAt(shader.__textureId.index, vertexBuffer, 4, FLOAT_1);
			if (shader.__alpha != null) context.setVertexBufferAt(shader.__alpha.index, vertexBuffer, 5, FLOAT_1); // 0x03 - 0x04
			if (shader.__multiTextureColorTransform != null) context.setVertexBufferAt(shader.__multiTextureColorTransform.index, vertexBuffer, 6, FLOAT_1);
			if (shader.__colorMultiplier != null) context.setVertexBufferAt(shader.__colorMultiplier.index, vertexBuffer, 7, FLOAT_4);
			if (shader.__colorOffset != null) context.setVertexBufferAt(shader.__colorOffset.index, vertexBuffer, 11, FLOAT_4);
			if (shader.__matrixRow0 != null) context.setVertexBufferAt(shader.__matrixRow0.index, vertexBuffer, 15, FLOAT_4);
			if (shader.__matrixRow1 != null) context.setVertexBufferAt(shader.__matrixRow1.index, vertexBuffer, 19, FLOAT_4);
			if (shader.__matrixRow2 != null) context.setVertexBufferAt(shader.__matrixRow2.index, vertexBuffer, 23, FLOAT_4);
			if (shader.__matrixRow3 != null) context.setVertexBufferAt(shader.__matrixRow3.index, vertexBuffer, 27, FLOAT_4);

			context.drawTriangles(context.__quadIndexBuffer, 0, length * 2);
		}else #end {
			#if !openfl_experimental_multitexture var #end vertexBuffer = bitmap.__bitmapData.getVertexBuffer(context);
            if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
            if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
            var indexBuffer = bitmap.__bitmapData.getIndexBuffer(context);
            context.drawTriangles(indexBuffer);
		}


		#if gl_stats
		Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
		#end

		renderer.__clearShader();

		// renderer.filterManager.popObject (bitmap);

		if(!isMultiTexture)
		{
			renderer.__popMaskObject(bitmap);
		}
	}

	public static function renderDrawable(bitmap:Bitmap, renderer:OpenGLRenderer):Void
	{
		var cacheUpdated:Bool = renderer.__updateCacheBitmap(bitmap, false);

		if (bitmap.__bitmapData != null && bitmap.__bitmapData.image != null)
		{
			bitmap.__imageVersion = bitmap.__bitmapData.image.version;
		}

		if (bitmap.__cacheBitmap != null && !bitmap.__isCacheBitmapRender)
		{
			Context3DBitmap.render(bitmap.__cacheBitmap, renderer);
		}
		else
		{
			Context3DDisplayObject.render(bitmap, renderer, false);
			Context3DBitmap.render(bitmap, renderer);
		}

		if(false)
			renderer.begin();

		renderer.__renderEvent(bitmap);
	}

	public static function renderDrawableMask(bitmap:Bitmap, renderer:OpenGLRenderer):Void
	{
		Context3DBitmap.renderMask(bitmap, renderer);
	}

	public static function renderMask(bitmap:Bitmap, renderer:OpenGLRenderer):Void
	{
		if (bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid)
		{
			var context = renderer.__context3D;

			var shader = renderer.__maskShader;
			renderer.setShader(shader);
			renderer.applyBitmapData(Context3DMaskShader.opaqueBitmapData, true);
			renderer.applyMatrix(renderer.__getMatrix(bitmap.__renderTransform, bitmap.pixelSnapping));
			renderer.updateShader();

			var vertexBuffer = bitmap.__bitmapData.getVertexBuffer(context);
			if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
			if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
			var indexBuffer = bitmap.__bitmapData.getIndexBuffer(context);
			context.drawTriangles(indexBuffer);

			#if gl_stats
			Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
			#end

			renderer.__clearShader();
		}
	}
}
#end
