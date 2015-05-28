package naja.model 
{
	import flash.utils.Dictionary;
	import naja.model.control.context.Context;
	import naja.model.data.loaders.LoadedData;
	import naja.model.data.lists.Gates ;
	
	/**
	 * ...
	 * @author saz
	 */
	dynamic public class XData 
	{
		private var __events:Gates 								= new Gates() ;
		private var __links:Object 								= { } ;
		private var __loaded:Dictionary 						= new Dictionary() ;
		private var __objects:Gates 							= new Gates() ;
//////////////////////////////////////////////////////// CTOR
		public function XData() 
		{
			trace("CTOR > " + this) ;
		}
		public function generate(xml:XML):void
		{
			this[xml.localName()] = createFromXML(xml) ;
		}
		
		public function createFromXML(xml:XML):Object
		{
			var o:Object = { } ;
			var localName:String = xml.localName() ;
			o.localName = function():String { return localName } ;
			
			for each(var child:XML in xml.*) {
				var ref:String = child.@id.toXMLString() || String(child.childIndex()) ;
				var p:Object = { } ;
				for each(var attr:XML in child.attributes()) {
					p[attr.localName()] = attr.toXMLString() ;
				}
				for each(var ch:XML in child.*) {
					var l:String = ch.localName() ;
					if (Boolean(p[l])) {
						trace("!!! Overwriting over an attribute...  "+this)
					}else {
						p[l] = ch.toXMLString() ;
					}
				}
				o[ref] = p ;
			}
			return o ;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get events():Gates { return __events }
		public function set events(value:Gates):void 
		{ __events = value }
		public function get loaded():Dictionary { return __loaded }
		public function set loaded(d:Dictionary) 
		{ __loaded = d }
		public function get objects():Gates { return __objects }
		public function set objects(value:Gates):void 
		{ __objects = value }
	}
}