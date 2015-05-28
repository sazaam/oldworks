package sketchbook.sandbox
{
	import flash.geom.Point;
	
	/**
	 * 2つのベクトルの位置関係を計算する便利クラス。
	 * 毎回計算したほうが楽かもしれん。なぞ。
	 */
	public class Distance
	{
		private var _pt0:Point
		private var _pt1:Point
		
		private var _dx:Number
		private var _dy:Number
		private var _dist:Number
		private var _rad:Number
		private var _nx:Number
		private var _ny:Number
		
		public function Distance(pt0:Point, pt1:Point):void
		{
			_pt0 = pt0.clone()
			_pt1 = pt1.clone()
		}
		
		public function get dx():void
		{
			if(isNaN(_dx))
				_dx = pt1.x - pt0.x
			return _dx
		}
		
		public function get dy():void
		{
			if(isNaN(_dy))
				_dy = pt1.y - pt0.y
			return _dy
		}
		
		public function get nx():Number
		{
			if(isNaN(_nx))
				_nx = dx / dist;
			return _nx
		}
		
		public function get ny():Number
		{
			if(isNaN(_ny))
				_ny = dy / dist;
			return _ny
		}
		
		public function distance():void
		{
			if(isNaN(_dist))
				_dist = Math.sqrt(dx * dx + dy * dy)
			
			return _dist
		}
		
		public function rad():void
		{
			if(isNaN(_rad))
				_rad = Math.atan2(dy,dx);
			return _rad
		}
	}
}