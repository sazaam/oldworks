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

package org.libspark.as3unit.runner
{
	import org.libspark.as3unit.inter.requests.ClassRequest;
	import org.libspark.as3unit.inter.requests.ClassesRequest;
	import org.libspark.as3unit.inter.requests.ErrorReportingRequest;
	import org.libspark.as3unit.inter.requests.FilterRequest;
	import org.libspark.as3unit.inter.requests.SortingRequest;
	import org.libspark.as3unit.runner.manipulation.Filter;
	import org.libspark.as3unit.runner.manipulation.Comparator;
	import org.libspark.as3unit.runner.Description;
	import org.libspark.as3unit.runner.Description;
	import org.libspark.as3unit.runner.Description;
	
	/**
	 * A <code>Request</code> is an abstract description of tests to be run. Older version of
	 * AS3Unit did not need such a concept-tests to be run were desribed either by classes containing
	 * tests or a tree of <code>Tests</code>. Howerver, we want to support filtering and sorting.
	 * so we need a more abstract specification then the tests themselves and a richer
	 * specification then just the classes.
	 * 
	 * The flow when AS3Unit runs tests is tat a <code>Request</code> specifies some tests to be run ->
	 * a <code>Runner</code> is created for each class implled by the <code>Request</code> ->
	 * the <code>Runner</code> retruns a detailed <code>Description</code> which is a tree structure of
	 * the tests to be run.
	 */
	public class Request
	{
		/**
		 * Create a <code>Request</code> that, when processed, will run a single test.
		 * This is done by filtering out all other tests. This method is used to support returning
		 * single tests.
		 * @param clazz the class of the test
		 * @param methodName the name of the test
		 * @return a <code>Request</code> that will cause a single test be run
		 */
		public static function method(clazz:Class, methodName:String):Request
		{
			var method:Description = Description.createTestDescription(clazz, methodName);
			return Request.aClass(clazz).filterWithDescription(method);
		}
		
		/**
		 * Create a <code>Request</code> that, when processed, will run all the tests
		 * in a class. The odd name is necessary because <code>class</code> is a reserved word.
		 * @param clazz the class containg the tests
		 * @return a <code>Request</code> that will cause all tests in the class to be run
		 */
		public static function aClass(clazz:Class):Request
		{
			return new ClassRequest(clazz);
		}
		
		/**
		 * Create a <code>Request</code> that, when processed, will run all the tests
		 * in a set of classes.
		 * @param collectionName a name to identify this suite of tests
		 * @param classes the classes containing the tests
		 * @return a <code>Request</code> that will cause all tests in the classes to be run
		 */
		public static function classes(collectionName:String, classes:Array):Request
		{
			return new ClassesRequest(collectionName, classes);
		}
		
		public static function errorReport(klass:Class, cause:Object):Request
		{
			return new ErrorReportingRequest(klass, cause);
		}
		
		public function getRunner():Runner
		{
			throw new SyntaxError('You must override this method.');
			return null;
		}
		
		public function filterWith(filter:Filter):Request
		{
			return new FilterRequest(this, filter);
		}
		
		public function filterWithDescription(desiredDescription:Description):Request
		{
			return filterWith(new DescriptionFilter(desiredDescription));
		}
		
		public function sortWith(comparator:Comparator):Request
		{
			return new SortingRequest(this, comparator);
		}
        
        public static function classWithoutSuiteMethod(newTestClass:Class):Request
        {
            return new ClassRequest(newTestClass, false);
        }
	}
}

import org.libspark.as3unit.runner.manipulation.Filter;
import org.libspark.as3unit.runner.Description;

class DescriptionFilter extends Filter
{
	private var desiredDescription:Description;
	
	public function DescriptionFilter(description:Description)
	{
		desiredDescription = description;
	}
	
	public override function shouldRun(description:Description):Boolean
	{
		if (description.isTest) {
			return desiredDescription.equals(description);
		}
		for each (var child:Description in description.children) {
			if (shouldRun(child)) {
				return true;
			}
		}
		return false;
	}
	
	public override function get describe():String
	{
		return "Method " + desiredDescription.displayName;
	}
}