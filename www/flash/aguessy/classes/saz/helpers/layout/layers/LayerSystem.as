package saz.helpers.layout.layers 
{
	import asSist.$;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import mvc.structure.data.items.Item;
	import mvc.structure.data.lists.List;
	import saz.helpers.layout.layers.I.ILayer;
	
	/**
	 * ...
	 * @author saz
	 */
	public class LayerSystem 
	{
		static private var index:int = 0 ;
		static public var activeLayer:DefaultLayer ;
		
		private var _stage:Stage;
		
		public var LAYERS:List = new List() ;
		public var max:int = 0 ;
		public var length:int = 0 ;
		public var layers:BackgroundLayer;
		
		public function LayerSystem(_max:Object = -1,_backgroundColor:uint = 0,_backgroundAlpha:Number = .5,_backgroundRect:Rectangle = null) 
		{
			_stage = $()[0] as Stage ;
			layers = new BackgroundLayer(_backgroundColor, _backgroundAlpha, _backgroundRect) ;
			$(layers).attr({id:"LayerSystem_" + LayerSystem.index,name:"layers"})
			if (_max != -1) {
				if (_max is int) {
					max = int(_max) ;
					for (var i:int = 0; i < max;  i++ ) {
						add(new DefaultLayer(i)) ;
					}
				}else if (_max is Array) {
					var pmax:Array =  _max as Array ;
					max = pmax.length ;
					setArray(pmax) ;
				}
			}
			LayerSystem.index ++ ;
			layers.visible = false ;
			_stage.addChild(layers) ;
		}
		
		
//////////////////////////////////////////////////////////////////////////////////////SET ARRAY
		private function setArray(arr:Array):void
		{
			for (var j:int = 0, l:int = arr.length; j < l;  j++ ) {
				if (j > max ) return trace("max already reached");
				if(DisplayObject(arr[j])) add(DisplayObject(arr[j])) ;
			}
		}
//////////////////////////////////////////////////////////////////////////////////////SHOW & HIDE
		public function show(_layer:* = null,instantly:Boolean = true,tweenObj:Object = null):void
		{
			if (!_layer) return LayerSystem.show(this, instantly, tweenObj)  
			else {
				if(!layers.visible) layers.visible = true ;
				var layer:DefaultLayer = getLayer(_layer) ;
				layer.show(instantly, tweenObj) ;
				LayerSystem.activeLayer = layer ;
			}
		}
		
		public function hide(_layer:* = null,instantly:Boolean = true,tweenObj:Object = null):void
		{
			if (!_layer) return LayerSystem.hide(this, instantly, tweenObj) 
			else {
				//layers.visible = false ;
				var layer:DefaultLayer = getLayer(_layer) ;
				layer.hide(instantly, tweenObj) ;
				activeLayer = null ;
			}
		}
		public static function show(tg:LayerSystem,instantly:Boolean = true, tweenObj:Object = null ):void
		{
			tg.layers.show(instantly,tweenObj);
		}
		public static function hide(tg:LayerSystem,instantly:Boolean = true, tweenObj:Object = null ):void
		{
			tg.layers.hide(instantly,tweenObj);
		}
//////////////////////////////////////////////////////////////////////////////////////GET ELEMENT
		public function getLayerById(id:Object):DefaultLayer
		{
			var layer:DefaultLayer ;
			if (id is String) {
				layer = LAYERS.$id(String(id)).item ;
			}else if (id is int) {
				layer = LAYERS.$index(int(id)).item;
			}
			return layer;
		}
		public function getLayerByDO(id:Object):DefaultLayer
		{
			var layer:DefaultLayer ;
			if (id is DisplayObject) {
				var DO:DisplayObject = DisplayObject(id) ;
				var arr:Array = LAYERS.list.filter(function(el, i, arr):Boolean { return (el.item.content === DO) ; } )
				layer = arr[0].item ;
			}else {
				trace("Not A DisplayObject")
			}
			return layer ;
		}
		public function getLayer(id:Object):DefaultLayer
		{
			var layer:DefaultLayer ;
			if (id is DefaultLayer) {
				layer = DefaultLayer(id) ;
			}else if (id is String || id is int) {
				layer = getLayerById(id) ;
			}else if (id is DisplayObject) {
				layer = getLayerByDO(id) ;
			}
			return layer ;
		}
//////////////////////////////////////////////////////////////////////////////////////ADD & REMOVE
		public function add(_layer:*):DefaultLayer
		{
			var layer:DefaultLayer;
			if (_layer is DefaultLayer) {
				layer = DefaultLayer(_layer) ;
			}else if (_layer is DisplayObject) {
				layer = new DefaultLayer(length,_layer);
			}
			layer.hide();
			layers.addChild(DisplayObject(Item(LAYERS.add(layer)).item)) ;
			length ++ ;
			return layer ;
		}
		public function remove(_layer:* = null):DefaultLayer
		{
			var layer:DefaultLayer;
			if (!_layer) {
				layer = getLayer(length - 1) ;
			}
			else {
				layer = getLayer(_layer) ;
			}
			
			
			layers.removeChild(DisplayObject(Item(LAYERS.remove(layer)).item)) ;
			length -- ;
			return layer ;
		}
//////////////////////////////////////////////////////////////////////////////////////GETTERS & SETTERS
		public function get stage():Stage { return _stage; }
		
	}
	
}