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

package org.libspark.asunit.framework
{
	import org.libspark.as3unit.runner.Description;
	import org.libspark.as3unit.runner.notification.RunListener;
	import org.libspark.as3unit.runner.notification.RunNotifier;
	import org.libspark.as3unit.runner.notification.Failure;
	import org.libspark.asunit.framework.AS3UnitTestAdapterCache;
	
	public class AS3UnitTestAdapterCache
	{
		private static var instance:AS3UnitTestAdapterCache = new AS3UnitTestAdapterCache();
		
		private var map:Object;
		
		public function AS3UnitTestAdapterCache()
		{
			map = new Object();
		}
		
		public function put(description:Description, test:Test):void
		{
			map[description.displayName] = test;
		}
		
		public function get(description:Description):Test
		{
			return map[description.displayName];
		}
		
		public function containsKey(description:Description):Boolean
		{
			return (description.displayName in map);
		}
		
		public static function getDefault():AS3UnitTestAdapterCache
		{
			return instance;
		}
		
		public function asTest(description:Description):Test
		{
			if (description.isSuite) {
				return createTest(description);
			}
			else {
				if (!containsKey(description)) {
					put(description, createTest(description));
				}
				return get(description);
			}
		}
		
		internal function createTest(description:Description):Test
		{
			if (description.isTest) {
				return new AS3UnitTestCaseFacade(description);
			}
			else {
				var suite:TestSuite = new TestSuite(null, description.displayName);
				for each (var child:Description in description.children) {
					suite.addTest(asTest(child));
				}
				return suite;
			}
		}
		
		public function getNotifier(result:TestResult, adapter:AS3UnitTestAdapter):RunNotifier
		{
			var notifier:RunNotifier = new RunNotifier();
			notifier.addListener(new RunListenerAdapter(this, result));
			return notifier;
		}
		
		public function asTestList(description:Description):Array
		{
			if (description.isTest) {
				return [asTest(description)];
			}
			else {
				var returnThis:Array = new Array();
				for each (var child:Description in description.children) {
					returnThis.push(asTest(child));
				}
				return returnThis;
			}
		}
	}
}

import org.libspark.asunit.framework.TestResult;
import org.libspark.asunit.framework.AS3UnitTestAdapterCache;
import org.libspark.as3unit.runner.notification.RunListener;
import org.libspark.as3unit.runner.notification.Failure;
import org.libspark.as3unit.runner.Description;

class RunListenerAdapter extends RunListener
{
	private var adapterCache:AS3UnitTestAdapterCache;
	private var result:TestResult;
	
	public function RunListenerAdapter(adapterCache:AS3UnitTestAdapterCache, 
		result:TestResult)
	{
		this.adapterCache = adapterCache;
		this.result = result
	}
	
	public override function testFailure(failure:Failure):void
	{
		result.addError(adapterCache.asTest(failure.description), failure.exception);
	}
	
	public override function testFinished(description:Description):void
	{
		result.endTest(adapterCache.asTest(description));
	}
	
	public override function testStarted(description:Description):void
	{
		result.startTest(adapterCache.asTest(description));
	}
}