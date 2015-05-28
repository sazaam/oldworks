/**
 * @author biendo@fullsix.com 
 */
package modules.foundation.io 
{
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;	
	import flash.utils.IExternalizable;
	
	/**
	 * @author biendo@fullsix.com
	 */	
	public interface Serializable extends IExternalizable
	{
		/*
		 * Serializability of a class is enabled by the class implementing the module.io.Serializable interface. 
		 * Classes that do not implement this interface will not have any of their state serialized or deserialized. 
		 * All subtypes of a serializable class are themselves serializable. 
		 * The serialization interface has no methods or fields and serves only to identify the semantics of being serializable. 
		 */
	}
	
}