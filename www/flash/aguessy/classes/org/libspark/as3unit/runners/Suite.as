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

package org.libspark.as3unit.runners
{
	import org.libspark.as3unit.inter.runners.InitializationError;
	import org.libspark.as3unit.inter.runners.TestClassRunner;
	import org.libspark.as3unit.runner.Request;
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Using <code>Suite</code> as a runner allows you to manually
	 * build a suite containing tests from many classes. It is the AS3Unit equivalent of the ASUnit
	 * <code>static org.libspark.asunit.framework.Test suite()</code> method. To use it, annotate
	 * class with <code>public static const RunWith:Class = Suite;</code> and
	 * <code>public static const SuiteClasses:Array = [TestClass1, ...];</code>.
	 * When you run this class, It will run all the tests in all the suite classes.
	 */
	public class Suite extends TestClassRunner
	{
		/**
		 * Internal use only.
		 */
		public function Suite(klass:Class, annotatedClasses:Array=null)
		{
			if (annotatedClasses == null) {
				annotatedClasses = getAnnotatedClasses(klass);
			}
			super(klass, Request.classes(getQualifiedClassName(klass), annotatedClasses).getRunner());
		}
		
		private static function getAnnotatedClasses(klass:Class):Array
		{
			if (!('SuiteClasses' in klass)) {
				throw InitializationError.createWithString("class '" + getQualifiedClassName(klass) + "' must have a SuiteClasses annotation");
			}
			if (!(klass.SuiteClasses is Array)) {
				throw InitializationError.createWithString("SuiteClasses annotation must be Array in class '" + getQualifiedClassName(klass) + "'");
			}
			return klass.SuiteClasses;
		}
	}
}