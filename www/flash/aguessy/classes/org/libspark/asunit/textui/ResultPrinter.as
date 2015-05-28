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
 	import org.libspark.asunit.framework.AssertionFailedError;
 	import org.libspark.asunit.framework.Test;
 	import org.libspark.asunit.framework.TestFailure;
 	import org.libspark.asunit.framework.TestListener;
 	import org.libspark.asunit.framework.TestResult;
 	import org.libspark.asunit.runner.BaseTestRunner;
 	
 	public class ResultPrinter implements TestListener
 	{
 		private var buffer:String;
 		
 		public function ResultPrinter()
 		{
 			buffer = "";
 		}
 		
 		public function print(result:TestResult, runTime:Number):void
 		{
 			if (buffer != "") {
 				trace(buffer);
 			}
 			printHeader(runTime);
 			printErrors(result);
 			printFailures(result);
 			printFooter(result);
 		}
 		
 		protected function printHeader(runTime:Number):void
 		{
 			trace("");
 			trace("Time: " + (runTime / 1000));
 		}
 		
 		protected function printErrors(result:TestResult):void
 		{
 			printDefects(result.errors, result.errorCount, "error");
 		}
 		
 		protected function printFailures(result:TestResult):void
 		{
 			printDefects(result.failures, result.failureCount, "failure");
 		}
 		
 		protected function printDefects(booBoos:Array, count:uint, type:String):void
 		{
 			if (count == 0) return;
 			if (count == 1) {
 				trace("There was " + count + " " + type + ":");
 			}
 			else {
 				trace("There were " + count + " " + type + "s:");
 			}
 			for (var i:uint = 0; i < booBoos.length; ++i) {
 				printDefect(TestFailure(booBoos[i]), i);
 			}
 		}
 		
 		public function printDefect(booBoo:TestFailure, count:uint):void
 		{
 			printDefectHeader(booBoo, count);
 			printDefectTrace(booBoo);
 		}
 		
 		protected function printDefectHeader(booBoo:TestFailure, count:uint):void
 		{
 			trace(count + ") " + booBoo.failedTest);
 		}
 		
 		protected function printDefectTrace(booBoo:TestFailure):void
 		{
 			trace(booBoo.trace);
 		}
 		
 		protected function printFooter(result:TestResult):void
 		{
 			if (result.wasSuccessful) {
 				trace("");
 				trace("OK (" + result.runCount + "test" + (result.runCount == 1 ? "" : "s") + ")");
 			}
 			else {
 				trace("");
 				trace("FAILURES!!!");
 				trace("Tests run: " + result.runCount + ", Failures: " + result.failureCount + ", Errors: " + result.errorCount);
 			}
 			trace("");
 		}
 		
 		public function addError(test:Test, error:Object):void
 		{
 			bufferedTrace("E");
 		}
 		
 		public function addFailure(test:Test, error:AssertionFailedError):void
 		{
 			bufferedTrace("F");
 		}
 		
 		public function endTest(test:Test):void
 		{
 		}
 		
 		public function startTest(test:Test):void
 		{
 			bufferedTrace(".");
 		}
 		
 		private function bufferedTrace(message:String):void
 		{
 			buffer += message;
 			if (buffer.length >= 80) {
 				trace(buffer);
 				buffer = "";
 			}
 		}
 	}
 }