package saz.geeks.graphix.deco 
{
	import caurina.transitions.Tweener;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.IBitmapDrawable;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author saz
	 */
	public class ReflectFade 
	{
		
		public function ReflectFade(_tg:Sprite) 
		{
			var clip:Sprite = _tg as Sprite
			var title:Sprite = clip.getChildByName("SECTION_TITLE")as Sprite
			var image:Sprite = clip.getChildByName("SECTION_IMAGE")as Sprite
			//for (var i = 0 ; i < clip.numChildren ;  i++)
				//trace(title)
			var dims:Rectangle = new Rectangle(0, 0, clip.width,clip.height)
			var bmpWithReflection:BitmapData = new BitmapData(dims.width, dims.height, true, 0x00000000);
			var mat:Matrix = new Matrix
			mat.translate(dims.width/2, 0)
			
			// draw a copy of the image
			bmpWithReflection.draw(clip, mat);
			title.visible = false
			//image.visible = false
			
			// draw the reflection, flipped
			var alpha:Number = .3;
			var colorMultiplier:Number = 1
			var flippedMatrix:Matrix = new Matrix(1, 0, 0, -1, 1, 1);
			//clip.alpha = .3 
			bmpWithReflection.draw( clip, flippedMatrix, new ColorTransform(colorMultiplier, colorMultiplier, colorMultiplier, alpha, 0, 0, 0, 0) );         			
			var refl:Sprite = _tg.addChild(new Sprite()) as Sprite
			//var reflection:Sprite = _tg.addChild(new Sprite()) as Sprite
			var lastBitmap:Bitmap = new Bitmap(bmpWithReflection, "auto", true)
			//trace("height : "+clip.height)
			refl.addChild(lastBitmap)
			//trace("newheight : "+clip.height)
			refl.name='REFLECT'
			refl.x = -refl.width / 2
			refl.blendMode = BlendMode.ADD
			refl.alpha = .1
			image.blendMode = BlendMode.HARDLIGHT
			//clip.blendMode = BlendMode.LIGHTEN
			//trace(clip)
			//Tweener.addTween(image, { _Blur_blurX:3, _Blur_blurY:3, _Blur_quality:3 } )
			Tweener.addTween(clip, { _DropShadow_alpha:100, _DropShadow_blurX:5, _DropShadow_blurY:5, _DropShadow_color:0x000000, _DropShadow_quality:3, _DropShadow_distance:5, _DropShadow_angle:90 } )
			//clip.cacheAsBitmap = true
			//trace(clip.filters)
		}
		
	}
	
}