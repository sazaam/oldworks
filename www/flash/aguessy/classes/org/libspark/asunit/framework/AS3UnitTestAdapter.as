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
	import org.libspark.as3unit.runner.Request;
	import org.libspark.as3unit.runner.Runner;
	
	import flash.utils.getQualifiedClassName;
	
	public class AS3UnitTestAdapter implements Test
	{
		private var newTestClass:Class;
		private var runner:Runner;
		private var cache:AS3UnitTestAdapterCache;
		
		public function AS3UnitTestAdapter(newTestClass:Class, cache:AS3UnitTestAdapterCache=null)
		{
			if (cache == null) {
				cache = AS3UnitTestAdapterCache.getDefault();
			}
			this.cache = cache;
			this.newTestClass = newTestClass;
			runner = Request.aClass(newTestClass).getRunner();
		}
		
		public function countTestCases():int
		{
			return runner.testCount;
		}
		
		public function run(result:TestResult):void
		{
			runner.run(cache.getNotifier(result, this));
		}
		
		public function get tests():Array
		{
			return cache.asTestList(description);
		}
		
		public function get testClass():Class
		{
			return newTestClass;
		}
		
		public function get description():Description
		{
			return runner.description;
		}
		
		public function toString():String
		{
			return getQualifiedClassName(newTestClass);
		}
	}
}