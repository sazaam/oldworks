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

package org.libspark.as3unit.inter.runners
{
	import org.libspark.as3unit.runner.OldTestClassAdaptingListener
	import org.libspark.asunit.extensions.TestDecorator;
	import org.libspark.asunit.framework.AssertionFailedError;
	import org.libspark.asunit.framework.AS3UnitTestAdapter;
	import org.libspark.asunit.framework.AS3UnitTestCaseFacade;
	import org.libspark.asunit.framework.Test;
	import org.libspark.asunit.framework.TestCase;
	import org.libspark.asunit.framework.TestListener;
	import org.libspark.asunit.framework.TestResult
	import org.libspark.asunit.framework.TestSuite;
	import org.libspark.as3unit.runner.Description;
	import org.libspark.as3unit.runner.Runner;
	import org.libspark.as3unit.runner.notification.RunNotifier;
	import org.libspark.as3unit.runner.notification.Failure;
	import org.libspark.as3unit.inter.runners.OldTestClassRunner;
	import org.libspark.as3unit.inter.runners.OldTestClassRunner;
	import org.libspark.asunit.framework.TestSuite;
	import org.libspark.as3unit.runner.notification.Failure;
	
	import flash.utils.getQualifiedClassName;
	
	public class OldTestClassRunner extends Runner
	{
		private var test:Test;
		
		public function OldTestClassRunner(test:*)
		{
			if (test is Class) {
				this.test = new TestSuite(test);
			}
			else if (test is Test) {
				this.test = test;
			}
			else {
				throw new TypeError();
			}
		}
		
		public override function run(notifier:RunNotifier):void
		{
			var result:TestResult = new TestResult();
			result.addListener(createAdaptingListener(notifier));
			test.run(result);
		}
		
		public static function createAdaptingListener(notifier:RunNotifier):TestListener
		{
			return new OldTestClassAdaptingListener(notifier);
		}
		
		public override function get description():Description
		{
			return makeDescription(test);
		}
		
		private function makeDescription(test:Test):Description
		{
			if (test is TestCase) {
				var tc:TestCase = TestCase(test);
				return Description.createTestDescription(getClass(tc), tc.getName());
			}
			else if (test is TestSuite) {
				var ts:TestSuite = TestSuite(test);
				var description:Description = Description.createSuiteDescription(ts.name);
				var n:uint = ts.testCount;
				for (var i:uint = 0; i < n; ++i) {
					description.addChild(makeDescription(ts.testAt(i)));
				}
				return description;
			}
			else if (test is AS3UnitTestAdapter) {
				return AS3UnitTestAdapter(test).description;
			}
			else if (test is TestDecorator) {
				return makeDescription(TestDecorator(test).test);
			}
			else {
				return Description.createSuiteDescription(getQualifiedClassName(getClass(test)));
			}
		}
		
		private function getClass(instance:Object):Class
		{
			return instance.constructor;
		}
	}
}

