package saz.helpers.layout.rects 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author saz
	 */
	public class ScrollRecter
	{
		////////////////////////////////////////////////////////////////GETTERS & SETTERS
		public function get rectangle():Rectangle {return _base ;}
		public function set rectangle(_val:Rectangle):void
		{_base = _val ;}
		//////////////////////////////////////////////////X
		public function get x():Number { return _base.x ; }
		public function set x(_val:Number):void 
		{  _base.x = _val ; applyRect() }
		//////////////////////////////////////////////////Y
		public function get y():Number {return _base.y ;}
		public function set y(_val:Number):void  
		{_base.y = _val ; applyRect() }
		//////////////////////////////////////////////////WIDTH
		public function get width():Number {return _base.width ;}
		public function set width(_val:Number):void 
		{ _base.width = _val ; applyRect() }
		//////////////////////////////////////////////////HEIGHT
		public function get height():Number {return _base.height ;}
		public function set height(_val:Number):void 
		{_base.height = _val ; applyRect() }
		//////////////////////////////////////////////////LEFT
		/// The x coordinate of the top-left corner of the rectangle.
		public function get left():Number {return _base.left ;}
		public function set left(_val:Number):void  
		{_base.left = _val ; applyRect() }
		//////////////////////////////////////////////////RIGHT
		/// The sum of the x and width properties.
		public function get right():Number {return _base.right ;}
		public function set right(_val:Number):void 
		{_base.right = _val ; applyRect() }
		//////////////////////////////////////////////////TOP
		/// The y coordinate of the top-left corner of the rectangle.
		public function get top():Number {return _base.top ;}
		public function set top(_val:Number):void 
		{_base.top = _val ; applyRect() }
		//////////////////////////////////////////////////BOTTOM
		/// The sum of the y and height properties.
		public function get bottom():Number {return _base.bottom ;}
		public function set bottom(_val:Number):void 
		{_base.bottom = _val ; applyRect() }
		//////////////////////////////////////////////////TOPLEFT
		/// The location of the Rectangle object's top-left corner, determined by the x and y coordinates of the point.
		public function get topLeft():Point {return _base.topLeft ;}
		public function set topLeft(_val:Point):void 
		{_base.topLeft = _val ; applyRect() }
		//////////////////////////////////////////////////TOPRIGHT
		/// The location of the Rectangle object's bottom-right corner, determined by the values of the right and bottom properties.
		public function get bottomRight():Point {return _base.bottomRight ;}
		public function set bottomRight(_val:Point):void 
		{_base.bottomRight = _val ; applyRect() }
		//////////////////////////////////////////////////SIZE
		/// The size of the Rectangle object, expressed as a Point object with the values of the width and height properties.
		public function get size():Point {return _base.size ;}
		public function set size(_val:Point):void 
		{_base.size = _val ; applyRect() }	
		
		
		
		////////////////////////////////////////////////////////////////VARS
		internal var _topLeft:Point, _bottomRight:Point, _size:Point ;
		internal var _base:Rectangle ;
		
		
		public var target:DisplayObject ;
		////////////////////////////////////////////////////////////////CTOR
		public function ScrollRecter(_tg:DisplayObject,_rectangle:Rectangle = null) 
		{
			target = _tg ;
			_base = _rectangle || new Rectangle(0,0,_tg.width,_tg.height) ;
			applyRect() ;
		}
		////////////////////////////////////////////////////////////////APPLY RECTANGLE
		public function applyRect(_rect:Rectangle = null)
		{
			if (_rect)  _base = _rect ;
			target.scrollRect = _base ;
		}
	}
}