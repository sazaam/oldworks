package modules.coreData
{
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	import modules.foundation.Type;
	import modules.patterns.AbstractFactory;

	public class DataInitializer extends AbstractFactory implements Module
	{
		/**
		 * 
		 * @param	source
		 */
		public function DataInitializer(source:Object=null)
		{
			//register ModuleInitializer Factory in AbstractFactory internal map 
			AbstractFactory.register(this, "build"); 
			//default initialisation
			setup(source || getInitializer());
			//concrete factory
			super(true);
		}
		
		/**
		 * 
		 * @param	instance
		 * @param	parameters
		 * @return
		 */
		public static function build(instance:Object, parameters:Object):DataInitializer
		{
			switch(parameters) {
				case parameters is XML:	
				case parameters is Array:	
				case parameters is Function:
				default:
					return new DataInitializer({instance:instance, parameters:parameters});		
			}
		}
		
		/**
		 * 
		 * @param	source
		 * @return
		 */
		public function clone(source:Object=null):Object
		{
			if (source != null)
				return Type.getInstance.apply(null, [this, source]); 
			return Type.clone(this);
		}
		
		/**
		 * 
		 * @param	o
		 * @return
		 */
		public function equals(T:Object):Boolean
		{
			if (T == this)
				return true;
    		if (!(T is DataInitializer))
    			return false;
			var module:DataInitializer = T as DataInitializer;
			return module.hashCode() == hashCode();
		}
		
		/**
		 * 
		 * @param	source
		 */
		public function finalize(source:Object=null):void
		{
			//default initialisation
			setup(source || getInitializer());
		}
		
		/**
		 * 
		 * @return
		 */
		public function getClass():Type
		{
			return Type.getDefinition(this);
		}
		
		/**
		 * 
		 * @return
		 */
		public function hashCode():int
		{
			return getClass().defaultHashCode;
		}
		
		/**
		 * 
		 * @param	input
		 */
		public function readExternal(input:IDataInput):void
		{
			var members:Array = getClass().accessors;	
			members.forEach(function(el:*, i:int, arr:Array):void {
				this[el.name] = input.readFloat();
			}, this);
		}
		
		/**
		 * 
		 * @return
		 */
		public function toSource():String
		{
			return Type.toXml(this).toString();
		}
		
		/**
		 * 
		 * @return
		 */
		override public function toString():String 
		{
			return Type.format(this);
		}
		
		/**
		 * 
		 * @return
		 */
		public function valueOf():Object
		{
			return this;
		}
		
		/**
		 * 
		 * @param	output
		 */
		public function writeExternal(output:IDataOutput):void
		{
			var members:Array = getClass().accessors;	
			members.forEach(function(el:*, i:int, arr:Array):void {
				output.writeFloat(this[el.name]);
			}, this);	
		}
		
		/**
		 * 
		 * @return
		 */
		protected function getInitializer():Object
		{
			return null;
		}
		
		protected function hasAccess(access:String):Boolean
		{
			return access == Type.READWRITE;
		}
		
		/**
		 * 
		 * @param	source
		 */
		protected function setup(source:Object):void
		{
			if (source is Object) {	
				if (source.instance != null && source.parameters != null) {	
					var T:Class = Type.getClass(source.instance);
					var accessors:Array = Type.getDefinition(source.instance).accessors;
					var field:String;	
					if (source.parameters is XML) {	
						var xml:XML = source.parameters as XML;
						accessors.forEach(function(el:*, i:int, arr:Array):void {
							field = el.name;
							if (xml..@[field].length() && hasAccess(el.access))
								source.instance[field] = xml..@[field];				
						});	
					} else if (source.parameters is T) {	
						accessors.forEach(function(el:*, i:int, arr:Array):void {
							field = el.name;
							if (source.parameters[field] != null && hasAccess(el.access))
								source.instance[field] = source.parameters[field];
						});					
					} else if (source.parameters is Array) {
						accessors.forEach(function(el:*, i:int, arr:Array):void {
							field = el.name;
							if (source.parameters.length && hasAccess(el.access))
								source.instance[field] = source.parameters[i];
						});	
					} else if (source.parameters is Function) {
						source.parameters();//custom init
					} else if (source.parameters is Object) {
						accessors.forEach(function(el:*, i:int, arr:Array):void {
							field = el.name;
							if (source.parameters[field] != null && hasAccess(el.access))
								source.instance[field] = source.parameters[field];
						});				
					} else {
						throw new TypeError();
					}	
				}				
			} else {
				throw new ArgumentError();
			}
			_initializer = this;
		}
		
		private var _initializer:DataInitializer;
	}
}