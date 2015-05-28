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
	import flash.utils.getQualifiedClassName;
	
	/**
	 * A test case defines the fixture to run multiple tests. To define a test case
	 * <ol>
	 * <li>implement a subclass of TestCase</li>
	 * <li>define instance variables that store the state of the fixture</li>
	 * <li>initialize the fixture state by overriding <code>setUp</code></li>
	 * <li>clean-up after a test by overriding <code>tearDown</code></li>
	 * </ol>
	 * Each test runs in its own fixture so there
	 * can be no side effects among test runs.
	 * Here is an example:
	 * <pre>
	 * public class MathTest extends TestCase
	 * {
	 *     protected var fValue1:Number;
	 *     protected var fValue2:Number;
	 * 
	 *     protected override function setUp():void
	 *     {
	 *         fValue1 = 2.0;
	 *         fValue2 = 3.0;
	 *     }
	 * }
	 * </pre>
	 * 
	 * For each test implement a method which interacts
	 * with the fixture. Verify the expected results with assertions specified
	 * by calling <code>assertTrue</code> with a boolean.
	 * <pre>
	 *     public function testAdd():void
	 *     {
	 *          var result:Number = fValue1 + fValue2;
	 *          assertTrue(result == 5.0);
	 *      }
	 * </pre>
	 * Once the methods are defined you can run them. The framework supports
	 * both a static type safe and more dynamic way to run a test.
	 * In the static way you override the <code>runTest</code> method and define the
	 * method to be invoked.
	 * The dynamic way uses reflection to implement <code>runTest</code>. It dynamically finds
	 * and invokes a method.
	 * In this case the name of the test case has to correspond to the test method
	 * to be run.
	 * <pre>
	 * var test:TestCase = new MathTest("testAdd");
	 * test.run();
	 * </pre>
	 * The tests to be run can be collected into a TestSuite. ASUnit provides
	 * different <i>test runners<i> which can run a test suite and collect the results.
	 * A test runner either expects a static method <code>suite</code> as the entry
	 * point to get a test to run or it will extract the suite automatically.
	 * <pre>
	 * static public function suite():Test
	 * {
	 *     suite.addTest(new MathTest("testAdd"));
	 *     suite.addTest(new MathTest("testDivideByZero"));
	 *     return suite;
	 * }
	 * </pre>
	 * @see TestResult
	 * @see TestSuite
	 */
	public class TestCase extends Assert implements Test
	{
		/**
		 * the name of test case
		 */
		private var name:String;
		
		/**
		 * Construct a test case with the five name.
		 */
		public function TestCase(name:String=null)
		{
			this.name = name;
		}
		
		/**
		 * Counts the number of test cases executed by run method.
		 */
		public function countTestCases():int
		{
			return 1;
		}
		
		/**
		 * A convenience method to run this test, collecting the results with a
		 * default TestResult object.
		 * 
		 * @see TestResult
		 */
		public function runDefault():TestResult
		{
			var result:TestResult = new TestResult();
			run(result);
			return result;
		}
		
		/**
		 * Runs the test case and collects the results in TestResult.
		 */
		public function run(result:TestResult):void
		{
			result.run(this);
		}
		
		/**
		 * Runs the bare test sequence.
		 */
		public function runBare():void
		{
			setUp();
			try {
				runTest();
			}
			finally {
				tearDown();
			}
		}
		
		/**
		 * Override to run the test and assert its state.
		 */
		protected function runTest():void
		{
			assertNotNull(name);
			
			try {
				if (this[name] is Function) {
					this[name]();
				}
				else {
					fail(name + " is not method.");
				}
			}
			catch (e:ReferenceError) {
				fail('Method "' + name + '" not found');
			}
		}
		
		/**
		 * Sets up the fixture, for example, open a network connection.
		 * This method is called before a test is executed.
		 */
		protected function setUp():void
		{
		}
		
		/**
		 * Tears down the fixture, for example, close a network connection.
		 * This method is called after a test is executed.
		 */
		protected function tearDown():void
		{
		}
		
		/**
		 * Returns a string representation of the test case.
		 */
		public function toString():String
		{
			return getName() + '(' + getQualifiedClassName(this) + ')';
		}
		
		/**
		 * Gets the name of a TestCase
		 * @return returns a String
		 */
		public function getName():String
		{
			return name;
		}
		
		/**
		 * Sets the name of a TestCase
		 * @param name The name to set
		 */
		public function setName(name:String):void
		{
			this.name = name;
		}
	}
}
