package tools.geom 
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Cyclic 
	{
		//////////////////////////////////////////////////////// VARS
		private var __center:Point;
		private var __baseDiameter:Number;
		private var __angle:Object ;
		private var __angleDegrees:Number ;
		private var __angleRadians:Number ;
		private var __startingAngle:Object;
		private var __baseTrajectory:Array;
		//////////////////////////////////////////////////////// CTOR
		public function Cyclic(_baseDiameter:Number = 50,_center:Point = null, _startingAngle:Object = null) 
		{
			__baseDiameter = _baseDiameter ;
			__center = _center || new Point() ;
			__startingAngle = setAngle(_startingAngle) ;
			__baseTrajectory = buildTrajectory() ;
		}
		
		public function buildTrajectory(diameter:Number = NaN, _startingAngle:Object = null):Array
		{
			var d:Number = (isNaN(diameter)) ? __baseDiameter :  diameter ;
			var a:Number = _startingAngle ? setAngle(_startingAngle).degrees : setAngle(0).degrees ;
			var arr:Array = [ ] , l:int = int((d) ) ;
			for (var i:int = 0 ; i < l ; i++ ) {
				var divid:Number = (i/l * 360)+a ;
				arr.push(new Point(xPos(divid , diameter), yPos(divid , diameter))) ;
			}
			return arr ;
		}
		
		private function setAngle(a:Object = null):Object
		{
			var o:Object ;
			if (a == null) 
				o =  {degrees:0, radians:0 } ;
			else if (a is Number)
				o = {degrees:Number(a) , radians:degreesToRadians(Number(a)) } ; 
			else if (a.radians != undefined)
				o = { degrees: radiansToDegrees(a.radians) , radians:a.radians } ;
			else if (a.degrees != undefined)
				o = { degrees:a.degrees , radians:degreesToRadians(a.degrees) } ;
			return o ;
		}
		
		public function pos(deg:Object, diameter:Number = NaN):Point
		{
			var x:Number = xPos(deg,diameter) ;
			var y:Number = yPos(deg,diameter) ;
			return new Point(x,y) ;
		}
		
		public function xPos(deg:Object, diameter:Number = NaN):Number
		{
			var n:Number ;
			if (deg is Number) 
				n = coordX(degreesToRadians(Number(deg)+ __startingAngle.degrees), diameter) ;
			else if (deg.radians != undefined)
				n = coordX(deg.radians + __startingAngle.radians, diameter)
			else if(deg.degrees != undefined)
				n = coordX(degreesToRadians(deg.degrees + __startingAngle.degrees ), diameter) ;
			return n ;
		}
		public function yPos(deg:Object, diameter:Number = NaN):Number
		{
			var n:Number ;
			if (deg is Number)
				n = coordY(degreesToRadians(Number(deg) + __startingAngle.degrees), diameter) ;
			else if (deg.radians != undefined)
				n = coordY(deg.radians + __startingAngle.radians, diameter) ;
			else if(deg.degrees != undefined)
				n = coordY(degreesToRadians(deg.degrees + __startingAngle.degrees ), diameter)  ; 
			return n ;
		}
		
		public function coordX(rad:Number, diameter:Number = NaN):Number
		{
			var d:Number = isNaN(diameter) ? __baseDiameter : diameter ;
			return (Math.cos(rad) * d ) + __center.x ;
		}
		public function coordY(rad:Number, diameter:Number = NaN):Number
		{
			var d:Number = isNaN(diameter) ? __baseDiameter : diameter ;
			return (Math.sin(rad) * d)  + __center.y ;
		}
		
		private function rotate():void
		{
			
		}
		///////////////////////////////////////////////////////////////////////////////// STATICS
		static public function degreesToRadians(n:Number,percent:Boolean = false):Number
		{
			return percent ? n * Math.PI * 2 : n * Math.PI / 180 ;
		}
		static public function radiansToDegrees(n:Number, percent:Boolean = false):Number
		{
			return percent ? degreesToPercent(Math.PI * 180 / n) : Math.PI * 180 / n ;
		}
		static public function percentToDegrees(n:Number):Number 
		{
			return n * 360 ;
		}
		static public function degreesToPercent(n:Number):Number 
		{
			return n / 360 ;
		}
		///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get angle():Object { return __angle }
		public function set angle( value:Object ):void 
		{  __angle = setAngle(value) }
		
		public function get trajectory():Array { return __baseTrajectory }
	}
}