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
	import org.libspark.as3unit.test;
	import org.libspark.as3unit.runner.Description;
	import org.libspark.as3unit.runner.Runner;
	import org.libspark.as3unit.runner.manipulation.Filter;
	import org.libspark.as3unit.runner.manipulation.Filterable;
	import org.libspark.as3unit.runner.manipulation.NoTestsRemainException;
	import org.libspark.as3unit.runner.manipulation.Sortable;
	import org.libspark.as3unit.runner.manipulation.Sorter;
	import org.libspark.as3unit.runner.notification.RunNotifier;
	
	import flash.utils.getQualifiedClassName;
	
	public class TestClassMethodsRunner extends Runner implements Filterable, Sortable
	{
		private var testMethods:Array;
		private var fTestClass:Class;
		
		public function TestClassMethodsRunner(klass:Class)
		{
			fTestClass = klass;
			testMethods = (new TestIntrospector(testClass).getTestMethods(test));
		}
		
		public override function run(notifier:RunNotifier):void
		{
			if (testMethods.length == 0) {
				notifier.testAborted(description, new Error("No runnable methods"));
			}
			for each (var method:Method in testMethods) {
				invokeTestMethod(method, notifier);
			}
		}
		
		public override function get description():Description
		{
			var spec:Description = Description.createSuiteDescription(name);
			for each (var method:Method in testMethods) {
				spec.addChild(methodDescription(method));
			}
			return spec;
		}
		
		protected function get name():String
		{
			return getQualifiedClassName(testClass);
		}
		
		protected function createTest():Object
		{
			return (new testClass());
		}
		
		protected function invokeTestMethod(method:Method, notifier:RunNotifier):void
		{
			var test:Object;
			try {
				test = createTest();
			}
			catch (e:Error) {
				notifier.testAborted(methodDescription(method), e);
				return;
			}
			createMethodRunner(test, method, notifier).run();
		}
		
		protected function createMethodRunner(test:Object, method:Method, notifier:RunNotifier):TestMethodRunner
		{
			return new TestMethodRunner(test, method, notifier, methodDescription(method));
		}
		
		protected function testName(method:Method):String
		{
			return method.name;
		}
		
		protected function methodDescription(method:Method):Description
		{
			return Description.createTestDescription(testClass, testName(method));
		}
		
		public function filter(filter:Filter):void
		{
			for (var i:uint = 0; i < testMethods.length;) {
				var method:Method = Method(testMethods[i]);
				if (!filter.shouldRun(methodDescription(method))) {
					testMethods.splice(i, 1);
				}
				else {
					++i;
				}
			}
			if (testMethods.length == 0) {
				throw new NoTestsRemainException();
			}
		}
		
		public function sort(sorter:Sorter):void
		{
			testMethods.sort(function(o1:Method, o2:Method):int {
				return sorter.compare(methodDescription(o1), methodDescription(o2));
			});
		}
		
		protected function get testClass():Class
		{
			return fTestClass;
		}
	}
}