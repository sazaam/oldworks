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
 	import flash.utils.describeType;
 	
 	/**
 	 * A <code>TestSuite</code> is a <code>Composite</code> of Tests.
 	 * It runs a collection of test cases. Here is an example using
 	 * the dynamic test definition.
 	 * <pre>
 	 * var suite:TestSuite = new TestSuite();
 	 * suite.addTest(new MathTest("testAdd"));
 	 * suite.addTest(new MathTest("testDivideByZero");
 	 * </pre>
 	 * Alternatively, a TestSuite can extract the tests to be run automatically.
 	 * To do so you pass the class of your TestCase class to the
 	 * TestSuite constructor.
 	 * <pre>
 	 * var suite:TestSuite = new TestSuite(MathTest);
 	 * </pre>
 	 * This constructor creates a suite with all the methods
 	 * starting with "test" that take no arguments.
 	 * 
 	 * @see Test
 	 */
 	public class TestSuite implements Test
{
 		private var tests_:Array;
 		private var name_:String;
 		
 		/**
 		 * Constructs a TestSuite from the given class with the given name.
 		 * Adds all the methods starting with "test" as test cases to the suite.
 		 */
 		public function TestSuite(theClass:Class=null, name:String=null)
 		{
 			tests_ = new Array();
 			
 			if (theClass != null) {
 				var names:Object = new Object();
 				for each (var method:XML in describeType(theClass).factory.method) {
 					addTestMethod(method, names, theClass);
 				}
 				if (tests_.length == 0) {
 					addTest(warning("No tests found in " + theClass));
 				}
 			}
 			if (name != null) {
 				this.name = name;;
 			}
 		}
 		
 		private function isTestMethod(method:XML):Boolean
 		{
 			var name:String = String(method.@name);
 			var parameters:XMLList = method.parameter;
 			var returnType:String = String(method.@returnType);
 			
 			return parameters.length() == 0 && name.substr(0, 4) == "test" && returnType == "void";
 		}
 		
 		private function addTestMethod(method:XML, names:Object, theClass:Class):void
 		{
 			var name:String = String(method.@name);
 			if (name in names) {
 				return;
 			}
 			if (!isTestMethod(method)) {
 				return;
 			}
 			names[name] = true;
 			addTest(createTest(theClass, name));
 		}
 		
 		static public function createTest(theClass:Class, name:String):Test
 		{
 			var constructor:XMLList = describeType(theClass).factory.constructor;
 			var test:Test;
 			
 			try {
	 			if (constructor == null || (constructor.parameter).length() == 0) {
	 				test = new theClass();
	 				if (test is TestCase) {
	 					TestCase(test).setName(name);
	 				}
	 			}
	 			else {
	 				test = new theClass(name);
	 			}
	 		}
	 		catch (e:TypeError) {
	 			return warning("Cannot instantiate test case: " + name + " (" + e.getStackTrace() + ")");
	 		}
 			
 			return test;
 		}
 		
 		/**
 		 * Adds a test to the suite.
 		 */
 		public function addTest(test:Test):void
 		{
 			tests_.push(test);
 		}
 		
 		/**
 		 * Adds the tests from the given class to the suite.
 		 */
 		public function addTestSuite(theClass:Class):void
 		{
 			addTest(new TestSuite(theClass));
 		}
 		
 		/**
 		 * Counts the number of test cases that will be run by this test.
 		 */
 		public function countTestCases():int
 		{
 			var total:uint = 0;
 			var tests_:Array = tests;
 			var count:uint = tests_.length;
 			for (var i:uint = 0; i < count; ++i) {
 				total += Test(tests_[i]).countTestCases();
 			}
 			return total;
 		}
 		
 		/**
 		 * Runs the tests and collects their result in a TestResult.
 		 */
 		public function run(result:TestResult):void
 		{
 			var tests_:Array = tests;
 			var count:uint = tests_.length;
 			for (var i:uint = 0; i < count; ++i) {
 				if (result.shouldStop) {
 					break;
 				}
 				runTest(Test(tests_[i]), result);
 			}
 		}
 		
 		public function runTest(test:Test, result:TestResult):void
 		{
 			test.run(result);
 		}
 		
 		/**
 		 * Returns the test at the given index.
 		 */
 		public function testAt(index:uint):Test
 		{
 			return Test(tests_[index]);
 		}
 		
 		/**
 		 * Returns the number of tests in this suite.
 		 */
 		public function get testCount():uint
 		{
 			return tests_.length;
 		}
 		
 		/**
 		 * Returns the tests as an array.
 		 */
 		public function get tests():Array
 		{
 			return tests_;
 		}
 		
 		public function toString():String
 		{
 			if (name != null) {
 				return name;
 			}
 			return super.toString();
 		}
 		
 		/**
 		 * Sets the name of the suite.
 		 * @param name The name to set
 		 */
 		public function set name(name:String):void
 		{
 			name_ = name;
 		}
 		
 		/**
 		 * Returns the name of the suite. Not all
 		 * tes tsuites have a name and this method
 		 * can return null.
 		 */
 		public function get name():String
 		{
 			return name_;
 		}
 		
 		/**
 		 * Returns the which will fail and log a warning message.
 		 */
 		private static function warning(message:String):Test
 		{
 			return new Warning(message);
 		}
 	}
 }
 
 import org.libspark.asunit.framework.TestCase;
 
 class Warning extends TestCase
 {
 	private var message:String;
 	
 	public function Warning(message:String)
 	{
 		super("warning");
 		this.message = message;
 	}
 	protected override function runTest():void
 	{
 		fail(message);
 	}
 }