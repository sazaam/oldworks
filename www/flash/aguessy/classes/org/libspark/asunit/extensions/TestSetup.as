/*
 * Copyright(c) 2006 the Spark project.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */

package org.libspark.asunit.extensions
{
	import org.libspark.asunit.framework.Protectable;
	import org.libspark.asunit.framework.Test;
	import org.libspark.asunit.framework.TestResult;
	
	/**
	 * A Decorator to set up and tear down additional fixture state. Subclass
	 * TestSetup and insert it into your tests when you want to set up additional
	 * state once before the tests are run.
	 */
	public class TestSetup extends TestDecorator
	{
		public function TestSetup(test:Test)
		{
			super(test);
		}
		
		public override function run(result:TestResult):void
		{
			var p:Protectable = new ProtectableClosure(function():void
			{
				setUp();
				basicRun(result);
				tearDown();
			});
			result.runProtected(this, p);
		}
		
		/**
		 * Sets up the fixture. Override to set up additional fixture state.
		 */
		protected function setUp():void
		{
		}
		
		/**
		 * Tears down the fixture. Override to tear down the additional fixture
		 * state.
		 */
		protected function tearDown():void
		{
		}
	}
}

import org.libspark.asunit.framework.Protectable;

class ProtectableClosure implements Protectable
{
	private var func:Function;
	
	public function ProtectableClosure(f:Function)
	{
		func = f;
	}
	
	public function protect():void
	{
		func();
	}
}