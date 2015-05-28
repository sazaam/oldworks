package org.libspark.asunit.framework 
{
	
	/**
	 * ...
	 * @author saz
	 */
	
	import org.libspark.asunit.framework.Protectable;
	import org.libspark.asunit.framework.TestCase;

	public class TestProtect implements Protectable
	{
		private var test:TestCase;
		
		public function TestProtect(test:TestCase)
		{
			this.test = test;
		}
		public function protect():void
		{
			test.runBare();
		}
	}
	
}