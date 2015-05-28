package enhancefro 
{
	import enhancefro.dns.enhance_fro_local;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	import frocessing.core.F5Graphics2D;
	import frocessing.core.F5Graphics3D;
	/**
	 * ...
	 * @author ...
	 */
	public class FroEnhancer extends Proxy
	{
		use namespace flash_proxy ;
		private static const FORMATTED:RegExp = /__[\w\d]+__/i ;
		private var __view:BaseView ;
		private var __fg3D:F5Graphics3D ;
		private var __fg2D:F5Graphics2D ;
		private var __rest:Array ;
		
		public function FroEnhancer() 
		{
			__view = new BaseView() ;
		}
		///////////////////////////////////////////////////////////	2D
		private function init2D(tg:Sprite):void
		{
			__fg2D = __view.prepare2D(tg) ;
		}
		public function draw2D(...rest:Array):void
		{
			__fg2D.beginDraw() ;
			__fg2D.endDraw() ;
		}
		
		///////////////////////////////////////////////////////////	3D
		private function init3D(tg:Sprite):void
		{
			__fg3D = __view.prepare3D(tg) ;
		}
		
		public function set3D(closure:Function, ...rest:Array):void
		{
			closure.apply(this, [].concat(rest)) ;
		}
		public function setup(closure:Function, ...rest:Array):void
		{
			closure.apply(this, [].concat(rest)) ;
		}
		public function draw3D(closure:Function, ...rest:Array):void
		{
			__view.renderer.beginDraw();
			closure.apply(this , [].concat(rest)) ;
			__view.renderer.endDraw();
		}
		
		public function init(__target:Sprite, context:String = '3D', closure:Function = null, ...rest:Array):FroEnhancer
		{
			__view.init(__target.stage, __target) ;
			
			if (Boolean(closure)) {
				__target.stage.addEventListener(Event.RESIZE, function(e:Event):void {
					set3D.apply(this, [closure].concat(rest)) ;
				}) ;
				set3D.apply(this, [closure].concat(rest)) ;
			}
			if (context == BaseView.TRIDIMENSIONAL) {
				init3D(__target) ;
			}else {
				init2D(__target) ;
			}
			return this ;
		}
		
		public function resetParams():void
		{
			__view.__params__ = { } ;
		}
				
		public function get view():BaseView { return __view }
		
		////////////////////////////////////////////////////////////// PROXY
		override flash_proxy function callProperty (name:*, ...rest) : *
		{
			if (Object(__view).hasOwnProperty(name)) {
				return __view[name].apply(this, [].concat(rest)) ;
			}else if (Object(__view.renderer).hasOwnProperty(name)) {
				return __view.renderer[name].apply(this, [].concat(rest)) ;
			}else if (__view.__params__[name] is Function) {
				return __view.__params__[name].apply(this, [].concat(rest)) ;
			}else if(this[name] is Function){
				return this[name].apply(this, [].concat(rest)) ;
			}
			//throw(new ReferenceError('Variable ' + name + ' is not a function...')) ;
		}

		/// Overrides the request to delete a property.
		enhance_fro_local function deleteProperty (name:*) : Boolean
		{
			
		}
		
		/// Overrides the use of the descendant operator.
		enhance_fro_local function getDescendants (name:*) : * 
		{
			
		}
		
		/// Overrides any request for a property's value.
		override flash_proxy function getProperty (name:*) : *
		{
			if (Object(__view.__params__).hasOwnProperty(name)) {
				return __view.__params__[name] ;
			}else if(Object(__view).hasOwnProperty(name)){
				return __view[name] ;
			}else if(Object(__view.renderer).hasOwnProperty(name)){
				return __view.renderer[name] ;
			}else if (name.toString() == '__params__') {
				return __view['__params__'] ;
			}
			
			//throw(new ReferenceError('Variable ' + name + ' is undefined in __params__')) ;
		}

		/// Overrides a request to check whether an object has a particular property by name.
		override flash_proxy function hasProperty (name:*) : Boolean
		{
			return Boolean(Object(__view).hasOwnProperty(name)) ;
		}

		/// Checks whether a supplied QName is also marked as an attribute.
		enhance_fro_local function isAttribute (name:*) : Boolean
		{
			
		}

		/// Allows enumeration of the proxied object's properties by index number to retrieve property names.
		enhance_fro_local function nextName (index:int) : String
		{
			
		}

		/// Allows enumeration of the proxied object's properties by index number.
		enhance_fro_local function nextNameIndex (index:int): int
		{
			
		}
		

		/// Allows enumeration of the proxied object's properties by index number to retrieve property values.
		enhance_fro_local function nextValue (index:int) : * {
			
		}

		/// Overrides a call to change a property's value.
		override flash_proxy function setProperty (name:*, value:*) : void {
			
			if(Object(__view).hasOwnProperty(name)){
				__view[name] = value ;
			}else if (Object(__view.renderer).hasOwnProperty(name)) {
				__view.renderer[name] = value ;
			}else{
				if (name.toString() == '__params__') {
					__view.__params__ = merge(value) ;
					treatParams() ;
				}else {
					__view.__params__[name] = value ;
				}
			}
		}
		
		private function merge(o):Object
		{
			var p:Object = __view.__params__ ;
			for (var i:String in o) {
				p[i] = o[i] ;
			}
			return p ;
		}
		
		private function treatParams():void
		{
			var p:Object = __view.__params__ ;
			for (var i:String in p) {
				if (Object(__view).hasOwnProperty(i)) __view[i] = p[i] ;
			}
		}
	}
}
