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
	import org.libspark.asunit.framework.Test;
	import org.libspark.asunit.framework.TestResult;
	
	/**
	 * A Decorator that runs a test repeatedly.
	 */
	public class RepeatedTest extends TestDecorator
	{
		private var timesRepeat:uint;
		
		public function RepeatedTest(test:Test, repeat:uint)
		{
			super(test);
			timesRepeat = repeat;
		}
		
		public override function countTestCases():int
		{
			return super.countTestCases() * timesRepeat;
		}
		
		public override function run(result:TestResult):void
		{
			for (var i:uint = 0; i < timesRepeat; ++i) {
				if (result.shouldStop) {
					break;
				}
				super.run(result);
			}
		}
		
		public override function toString():String
		{
			return super.toString() + '(repeated)';
		}
	}
}