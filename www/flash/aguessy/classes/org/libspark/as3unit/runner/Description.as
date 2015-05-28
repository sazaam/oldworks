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
	import flash.utils.getQualifiedClassName;
	
	/**
	 * A <code>Description</code> describes a test which is to be run or has been run.
	 * <code>Descriptions</code> can be atomic (a single test) or compound (containing 
	 * children tests). <code>Descrptions</code> are used to provide feedback about the
	 * tests that are about to run (for example, the tree view visible in many IDEs) or
	 * tests that have been run (for example, the failure view).
	 * <code>Descriptions</code> are implemented as a single class rather than a Composite
	 * because they are enterely infomational. They contain no logic aside from counting
	 * ther tests.
	 * In the past, we used the raw <code>asunit.framework.TestCase</code> and
	 * <code>asunit.framework.TestSuite</code>s to display the tree of tests. This was no
	 * longer visible in AS3Unit because atomic tests no longer have a superclass below
	 * <code>Object</code>.
	 * We needed a way to pass a class and name together. Description emeged from this.
	 * 
	 * @see org.libspark.as3unit.runner.Request
	 * @see org.libspark.as3unit.runner.Runner
	 */
	public class Description
	{
		/**
		 * Create a <code>Descritpion</code> named <code>name</code>.
		 * Generaly, you will add children to this <code>Description</code>.
		 * @param name The name of the <code>Decription</code>
		 * @return A <code>Description</code> named <code>name</code>
		 */
		public static function createSuiteDescription(name:String):Description
		{
			return new Description(name);
		}
		
		/**
		 * Create a <code>Description</code> of a single test named <code>name</code>
		 * in the class <code>clazz</code>.
		 * Generaly, this will be leaf <code>Description</code>.
		 * @param clazz The class of the test
		 * @param name The name of the test (a method name for test declared with <code>test</code>)
		 * @return A <code>Description</code> named <code>name</code>
		 */
		public static function createTestDescription(clazz:Class, name:String):Description
		{
			return new Description(name + "(" + getQualifiedClassName(clazz) + ")");
		}
		
		/**
		 * Create a generice <code>Descritpion</code> that says there are tests in <code>testClass</code>.
		 * This is used as a last resort when you cannot precisely describe the individual tests in the class.
		 * @param testClass A <code>Class</code> containing tests
		 * @param A <code>Description</code> or <code>testClass</code>
		 */
		public static function createTestSuiteDescription(testClass:Class):Description
		{
			return new Description(getQualifiedClassName(testClass));
		}
		
		public static var EMPTY:Description = new Description("No Tests");
		public static var TEST_MECHANISM:Description = new Description("Test mechanism");
        
		private var fChildren:Array;
		private var fDisplayName:String;
		
		public function Description(displayName:String)
		{
			fChildren = new Array();
			fDisplayName = displayName;
		}
		
		/**
		 * @return a user-understandable label
		 */
		public function get displayName():String
		{
			return fDisplayName;
		}
		
		/**
		 * Add <code>description</code> as a child of the reciver.
		 * @param description The soon-to-be child.
		 */
		public function addChild(description:Description):void
		{
			children.push(description);
		}
		
		/**
		 * @return the reciver's children, if any
		 */
		public function get children():Array
		{
			return fChildren;
		}
		
		/**
		 * @return true if the receiver is a suite
		 */
		public function get isSuite():Boolean
		{
			return !isTest;
		}
		
		/**
		 * @return true if the receiver is an atomic test
		 */
		public function get isTest():Boolean
		{
			return children.length == 0;
		}
		
		/**
		 * @returns the total number of atomic tests in the receiver
		 */
		public function get testCount():uint
		{
			if (isTest) {
				return 1;
			}
			var result:uint = 0;
			for each (var child:Description in children) {
				result += child.testCount;
			}
			return result;
		}
		
		public function equals(obj:*):Boolean
		{
			if (!(obj is Description)) {
				return false;
			}
			var d:Description = Description(obj);
			if (displayName != d.displayName) {
				return false;
			}
			var c1:Array = children;
			var c2:Array = d.children;
			if (c1.length != c2.length) {
				return false;
			}
			var len:uint = c1.length;
			for (var i:uint = 0; i < len; ++i) {
				if (!(Description(c1[i]).equals(c2[i]))) {
					return false;
				}
			}
			return true;
		}
		
		public function toString():String
		{
			return displayName;
		}
	}
}