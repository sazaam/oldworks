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

 package org.libspark.asunit.runner
 {
 	import org.libspark.asunit.framework.*;
 	
 	/**
 	 * Base class for all test runners.
 	 */
 	public class BaseTestRunner implements TestListener
 	{
 		public static const SUITE_METHOD:String = "suite";
 		
 		public function startTest(test:Test):void
 		{
 			testStarted(String(test));
 		}
 		
 		public function endTest (test:Test):void
 		{
 			testEnded(String(test));
 		}
 		
 		public function addError(test:Test, error:Object):void
 		{
 			testFailed(TestRunListenerStatus.ERROR, test, error);
 		}
 		
 		public function addFailure(test:Test, error:AssertionFailedError):void
 		{
 			testFailed(TestRunListenerStatus.FAILURE, test, error);
 		}
 		
 		// TestRunListener implementation
 		public function testStarted(testName:String):void
 		{
 		}
 		public function testEnded(testName:String):void
 		{
 		}
 		public function testFailed(status:uint, test:Test, error:Object):void
 		{
 		}
 		
 		/**
 		 * Returns the Test corresponding to the given suite. This is
 		 * a template method, subclasses override runFailed(), clearStatus().
 		 */
 		public function getTest(suiteClassName:String):Test
 		{
 			if (suiteClassName.length == 0) {
 				clearStatus();
 				return null;
 			}
 			var testClass:Class = null;
 			try {
 				testClass = loadSuiteClass(suiteClassName);
 			}
 			catch (e:ReferenceError) {
 				runFailed("Class not found \"" + e.message + "\"");
 				return null;
 			}
 			catch (e:Error) {
 				runFailed("Error: " + e.toString());
 				return null;
 			}
 			
 			var suiteMethod:Function = null;
 			try {
 				suiteMethod = testClass[SUITE_METHOD];
 			}
 			catch (e:Error) {
 				clearStatus();
 				return new TestSuite(testClass);
 			}
 			
 			var test:Test = null;
 			try {
 				test = suiteMethod();
 				if (test == null) {
 					return test;
 				}
 			}
 			catch (e:Error) {
 				runFailed("Failed to invoke suite(); " + e.toString());
 			}
 			
 			clearStatus();
 			return test;
 		}
 		
 		/**
 		 * Override to defined how to handle a failed loading of
 		 * a test suite.
 		 */
 		protected function runFailed(message:String):void
 		{
 		}
 		
 		/**
 		 * Retun the loaded Class for a suite name
 		 */
 		protected function loadSuiteClass(suiteClassName:String):Class
 		{
 			return getLoader().load(suiteClassName);
 		}
 		
 		/**
 		 * Clear the status message.
 		 */
 		protected function clearStatus():void
 		{
 		}
 		
 		/**
 		 * Returns the loader to be used.
 		 */
 		public function getLoader():TestSuiteLoader
 		{
 			return new StandardTestSuiteLoader();
 		}
 	}
 }