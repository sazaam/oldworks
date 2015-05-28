package pro 
{

	import naja.model.XModel;
	import naja.model.XModule;
	
	/**
	 * ...
	 * @author saz
	 */
	public class SazConfig extends XModule
	{
		public function SazConfig() 
		{
			super() ;
		}
		override public function initialize(model:XModel):XModule
		{
			// Important to always initialize from super, in order to benefit af all Naja prerequired...
			super.initialize(model) ;
			// Here is free to Initialize any Class or Object for future use...
			return this ;
		}
		override public function load():void
		{
			super.load() ;
		}
		override public function open():void
		{
			super.open() ;
		}
	}
}