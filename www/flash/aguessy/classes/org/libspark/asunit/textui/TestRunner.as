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

 package org.libspark.asunit.textui
 {
 	import org.libspark.asunit.framework.*;
 	import org.libspark.asunit.runner.*;
 	
 	import flash.utils.getTimer;
 	
 	public class TestRunner extends BaseTestRunner
 	{
 		private var printer:ResultPrinter;
 		
 		public function TestRunner()
 		{
 			printer = new ResultPrinter();
 		}
 		
 		/**
 		 * Runs a suite extracted from a TestCase subclass.
 		 */
 		static public function runSuite(testClass:Class):void
 		{
 			run(new TestSuite(testClass));
 		}
 		
 		/**
 		 * Runs a single test and collects its results.
 		 * This method can be used to start a test run
 		 * from your program.
 		 */
 		static public function run(test:Test):TestResult
 		{
 			var runner:TestRunner = new TestRunner();
 			return runner.doRun(test);
 		}
 		
 		public function doRun(suite:Test):TestResult
 		{
 			var result:TestResult = new TestResult();
 			result.addListener(printer);
 			var startTime:Number = getTimer();
 			suite.run(result);
 			var endTime:Number = getTimer();
 			var runTime:Number = endTime - startTime;
 			printer.print(result, runTime);
 			return result;
 		}
 	}
 }