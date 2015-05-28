package cv.exec 
{
	import cv.deposit.Deposit;
	import cv.grafix.Graphix;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import saz.helpers.layout.layers.Layer;
	import saz.helpers.layout.layers.LayerSystem;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Executer 
	{
		///////////////////////////////////////////////////STATICS
		static public function init(_tg:Sprite):Executer
		{ return new Executer(_tg).init()  }
		static public function launch(_xml:XML):void
		{ _instance.launch(_xml)  }
		static private var inited:Boolean = false;
		static private var _instance:Executer;
		static public function get instance():Executer { return _instance; }
		static public function get target():Sprite { return _instance._main; }
		static public function get controller():Controller { return _instance._controller; }
		static public function get deposit():Deposit { return _instance._deposit; }
		static public function get graphix():Graphix { return _instance._graphix; }
		
		
		private var _main:Sprite;
		private var _controller:Controller;
		private var _deposit:Deposit;
		private var _graphix:Graphix;
		private var Layers:LayerSystem;
		///////////////////////////////////////////////////CTOR
		public function Executer(_tg:Sprite) 
		{
			if (!inited) {
				_instance = this ;
				_instance._main = _tg ;
			}else {
				throw(new Error("Trying to reinstanciate Executer",1))
			}
		}
		///////////////////////////////////////////////////INIT
		public function init():Executer
		{
			_controller = new Controller() ;
			_deposit = new Deposit() ;
			_graphix = new Graphix() ;
			_controller.init() ;
			inited = true ;
			return this ;
		}
		///////////////////////////////////////////////////LAUNCH
		public function launch(_xml:XML):void
		{
			Deposit.XML_SECTIONS =  _xml ;
			_controller.start() ;
			_controller.launch() ;
			
			//Layers = new LayerSystem([new Layer("sazaam",new Sprite()), new Layer("ornorm", new Sprite())], 0x333333, .8) ;
			//Layers.show("ornorm") ;
			//Layers.getLayerById("ornorm").addEventListener(MouseEvent.CLICK,onClick)
		}
		
		private function onClick(e:MouseEvent):void 
		{
			Layers.hide() ;
		}
	}
}