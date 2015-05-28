/**
 * @author biendo@fullsix.com 
 */
package modules.coreData
{
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	import modules.foundation.ADT;
	import modules.foundation.Type;
	
	public class CoreData implements Module
	{
		public function CoreData(source:Object=null)
		{
			super();
			//abstract data type declaration
			ADT.assertAbstractTypeError(this, CoreData);
			//default initialisation
			setup(source || getInitializer());
		}

		public function clone(source:Object=null):Object
		{
			if (source != null)
				return Type.getInstance.apply(null, [this, source]); 
			return Type.clone(this);
		}
								
		public function equals(T:Object):Boolean
		{
			if (T == this)
				return true;
			if(!(T is CoreData))
				return false;
			var module:CoreData = T as CoreData;
			return hashCode() ==  module.hashCode();
		}
		
		public function finalize(source:Object=null):void
		{
			//default initialisation
			setup(source || getInitializer());
		}
				
		public function getClass():Type
		{
			if (_definition == null)
				_definition = Type.getDefinition(this);
			return _definition;
		}
		
		public function hashCode():int
		{
			return getClass().defaultHashCode;
		}
		
		public function readExternal(input:IDataInput):void
		{	
			getClass().accessors.forEach(function(el:*, i:int, arr:Array):void {				
				if (el.access != Type.READONLY) {					
					switch(el.type) {
						case "Boolean":
							this[el.name] = input.readBoolean();
							break;						
						case "int":
							this[el.name] = input.readInt();
							break;
						case "Number":
							this[el.name] = input.readFloat();
							break;
						case "String":
							this[el.name] = input.readUTF();
							break;
						case "uint":
							this[el.name] = input.readUnsignedInt();
							break;
						default:
							this[el.name] = input.readObject();
							break;
					}
				}
			}, this);
		}
				
		public function toString():String
		{
			return Type.format(this);
		}
		
		public function toSource():String
		{
			return Type.toXml(this).toString();
		}
		
		public function valueOf():Object
		{
			return this;
		}
		
		public function writeExternal(output:IDataOutput):void
		{			
			getClass().accessors.forEach(function(el:*, i:int, arr:Array):void {
				if (el.access != Type.READONLY) {
					switch(el.type) {
						case "Boolean":
							output.writeBoolean(this[el.name]);
							break;						
						case "int":
							output.writeInt(this[el.name]);
							break;
						case "Number":
							output.writeFloat(this[el.name]);
							break;
						case "String":
							output.writeUTF(this[el.name]);
							break;
						case "uint":
							output.writeUnsignedInt(this[el.name]);
							break;
						default:
							output.writeObject(this[el.name]);
							break;
					}
				}
			}, this);	
		}
		
		protected function setup(source:Object):void
		{		
			_initializer = DataInitializer.build(this, source);	
		}
		
		protected function getInitializer():Object
		{
			//abstract method
			ADT.assertAbstractTypeError(this, CoreData);
			return null;
		}
		
		protected var _initializer:DataInitializer;
		protected var _definition:Type;
	}
}