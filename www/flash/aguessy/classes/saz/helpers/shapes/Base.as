package saz.helpers.shapes 
{
	import flash.display.Sprite;

	public class Base extends Sprite
	{
		private var _centered:Boolean;
		public function get centered():Boolean{return _centered;}
		public function set centered(value:Boolean):void
		{
			_centered = value;
			draw();
		}

		public var defaultCentered:Boolean = false;

		private var _color:uint;
		public function get color():uint{return _color;}
		public function set color(value:uint):void
		{
			_color = value;
			draw();
		}

		private var _width:Number;
		public override function get width():Number{return _width;}
		public override function set width(value:Number):void
		{
			_width = value;
			draw();
		}

		private var _height:Number;
		public override function get height():Number{return _height;}
		public override function set height(value:Number):void
		{
			_height = value;
			draw();
		}

		public function Base()
		{
			_color = 0xffffff;
			_width = _height = 10;
			_centered = defaultCentered;
			draw();
		}

		internal function draw():void
		{
			graphics.clear();

			graphics.beginFill(color);
			graphics.lineStyle(1, 0x000000);
			drawShape(_centered ? -_width / 2 : 0, _centered ? -_height / 2 : 0);
			graphics.endFill();
		}


		internal function drawShape(offsetX:Number, offsetY:Number):void
		{
		}
	}
}

