package saz.geeks.graphix.deco 
{
	import caurina.transitions.*
	import caurina.transitions.properties.*
	import flash.display.*
	
	/**
	 * ...
	 * @author saz
	 */
	public class Drops 
	{
		private var target:DisplayObjectContainer;
		public var FilterContainer:Sprite;
		public var FilterContainer2:Sprite;
		
		public function Drops() 
		{
			SpecialPropertiesDefault.init()
			FilterShortcuts.init()
		}
		
		public function init(_tg:DisplayObject)
		{
			target = _tg is DisplayObjectContainer ? _tg as DisplayObjectContainer : _tg.parent as DisplayObjectContainer;
			FilterContainer = new Sprite();
			FilterContainer2 = new Sprite();
			target.addChild(FilterContainer);
			target.addChild(FilterContainer2);
		}
		public function draw(maxCircleW:int,numDrops:int)
		{
			var shape:Shape = new Shape()
			FilterContainer.addChild(shape)
			
			for (var i:int = 0; i < numDrops ;i++ )
			{
				var variable:Number = Math.random()*maxCircleW
				var X:Number = Math.random() * target.width
				var Y:Number = Math.random() * target.height
				
				shape.graphics.lineStyle(variable,0xFFFFFF, 1)
				shape.graphics.moveTo(X, Y)
				shape.graphics.lineTo(X+((Math.random()*maxCircleW)/10),Y)
			}
			shape.graphics.endFill()
			
			
			var bmp:Bitmap = new Bitmap(new BitmapData(shape.width, shape.height,true,0x000000FF));
			bmp.bitmapData.draw(FilterContainer)
			FilterContainer2.addChild(bmp)
			Tweener.addTween(FilterContainer,{_DropShadow_alpha:.4,_DropShadow_angle:60,_DropShadow_strength:1,_DropShadow_quality:3,_DropShadow_color:0xFFFFFF,_DropShadow_blurX:maxCircleW/2.5,_DropShadow_blurY:maxCircleW/2.5,_DropShadow_distance:maxCircleW/5,_DropShadow_hideObject:true,_DropShadow_inner:true,time:0})
			Tweener.addTween(FilterContainer2,{_DropShadow_alpha:.4,_DropShadow_angle:-160,_DropShadow_strength:1,_DropShadow_quality:3,_DropShadow_color:0x00,_DropShadow_blurX:2,_DropShadow_blurY:2,_DropShadow_distance:1,_DropShadow_hideObject:true,_DropShadow_inner:true,time:0})
			
			//Tweener.addTween(FilterContainer2,{_DropShadow_alpha:1,_DropShadow_angle:-120,_DropShadow_strength:5,_DropShadow_quality:3,_DropShadow_color:0x0,_DropShadow_blurX:2,_DropShadow_blurY:2,_DropShadow_distance:-2,_DropShadow_knockout:true,_DropShadow_inner:true,time:0})
			//FilterContainer.blendMode = BlendMode.LIGHTEN
			//FilterContainer.alpha =.9
		}
	}
	
}