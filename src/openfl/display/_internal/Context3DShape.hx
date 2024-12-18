package openfl.display._internal;

#if !flash
import openfl.display.DisplayObject;
import openfl.display.OpenGLRenderer;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
import openfl.geom.Matrix;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.display.Shader)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@SuppressWarnings("checkstyle:FieldDocComment")
class Context3DShape
{
	public static function render(shape:DisplayObject, renderer:OpenGLRenderer):Void
	{
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;

		var graphics = shape.__graphics;

		if (graphics != null)
		{
			renderer.__setBlendMode(shape.__worldBlendMode);
			renderer.__pushMaskObject(shape);
			// renderer.filterManager.pushObject (shape);

			Context3DGraphics.render(graphics, renderer);

			if (graphics.__bitmap != null && graphics.__visible)
			{
				var context = renderer.__context3D;
				var scale9Grid = shape.__worldScale9Grid;

				//trace("RENDER SHAPE");
				//renderer.begin();

				var matrix = new Matrix();
                matrix.scale(1 / graphics.__bitmapScale, 1 / graphics.__bitmapScale);
                matrix.concat(graphics.__worldTransform);

				var bitmap = new Bitmap(graphics.__bitmap);
				bitmap.pixelSnapping = PixelSnapping.AUTO;
				bitmap.__scrollRect = shape.__scrollRect;
				bitmap.__renderTransform = matrix;
				bitmap.__worldTransform = graphics.__worldTransform;
				bitmap.__worldAlpha = shape.__worldAlpha;
				bitmap.__worldColorTransform = shape.__worldColorTransform;
				bitmap.__worldShader = shape.__worldShader;
				bitmap.__worldBlendMode = shape.__worldBlendMode;
				bitmap.__renderable = shape.__renderable;

				Context3DBitmap.render(bitmap, renderer);
			}

			// renderer.filterManager.popObject (shape);
			renderer.__popMaskObject(shape);
		}
	}

	public static function renderMask(shape:DisplayObject, renderer:OpenGLRenderer):Void
	{
		var graphics = shape.__graphics;

		if (graphics != null)
		{
			// TODO: Support invisible shapes

			Context3DGraphics.renderMask(graphics, renderer);

			if (graphics.__bitmap != null)
			{
				var context = renderer.__context3D;

				var shader = renderer.__maskShader;
				renderer.setShader(shader);
				renderer.applyBitmapData(graphics.__bitmap, true);
				renderer.applyMatrix(renderer.__getMatrix(graphics.__worldTransform, AUTO));
				renderer.updateShader();

				var vertexBuffer = graphics.__bitmap.getVertexBuffer(context);
				if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
				if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
				var indexBuffer = graphics.__bitmap.getIndexBuffer(context);
				context.drawTriangles(indexBuffer);

				#if gl_stats
				Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
				#end

				renderer.__clearShader();
			}
		}
	}
}
#end
