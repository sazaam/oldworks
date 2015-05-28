package saz.helpers.sprites 
{
	import flash.display.Sprite;
	import saz.helpers.core.Props;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Smart extends Sprite
	{
		private var _props:Object ;
		public function get properties():Object { return _props; }
		public function set properties(value:Object):void 
		{	_props = value ; }
		////////////////////////////////////////////////CTOR
		public function Smart(_coreProps:Object = null) 
		{
			_props = _coreProps ;
		}
	}
}