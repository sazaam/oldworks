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
	import org.libspark.asunit.framework.Assert;
	import org.libspark.asunit.framework.Test;
	import org.libspark.asunit.framework.TestResult;
	
	/**
	 * A Decorator for Tests. Use TestDecorator as the base class for defining new
	 * test decorators. Test decorator subclasses can be introduced to add behaviour
	 * before or after a test is run.
	 */
	public class TestDecorator extends Assert implements Test
	{
		protected var fTest:Test;
		
		public function TestDecorator(test:Test)
		{
			fTest = test;
		}
		
		/**
		 * The basic run behaviour
		 */
		public function basicRun(result:TestResult):void
		{
			fTest.run(result);
		}
		
		public function countTestCases():int
		{
			return fTest.countTestCases();
		}
		
		public function run(result:TestResult):void
		{
			basicRun(result);
		}
		
		public function toString():String
		{
			return String(fTest);
		}
		
		public function get test():Test
		{
			return fTest;
		}
	}
}