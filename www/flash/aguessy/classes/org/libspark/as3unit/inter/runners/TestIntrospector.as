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
	import org.libspark.as3unit.before;
	import org.libspark.as3unit.beforeClass;
	import org.libspark.as3unit.ignore;
	import org.libspark.as3unit.test;
	import org.libspark.as3unit.test_expected;
	
	public class TestIntrospector
	{
		private var testClass:Class;
		
		public function TestIntrospector(testClass:Class)
		{
			this.testClass = testClass;
		}
		
		public function getTestMethods(annotationNamespace:Namespace):Array
		{
			var results:Array = new Array();
			var annotationURI:String = annotationNamespace.uri;
			
			for each (var method:Method in Method.getDeclaredMethods(testClass)) {
				if (method.namespace.uri == annotationURI) {
					results.push(method);
				}
			}
			
			if (runTopToBottom(annotationNamespace)) {
				results.reverse();
			}
			
			return results;
		}
		
		public function isIgnored(eachMethod:Method):Boolean
		{
			try {
				eachMethod.declaringClass.ignore::[eachMethod.name];
				return true;
			}
			catch (e:ReferenceError) {
			}
			return false;
		}
		
		private function runTopToBottom(annotation:Namespace):Boolean
		{
			return (annotation.uri == before.uri) || (annotation.uri == beforeClass.uri);
		}
		
		internal function getTimeout(method:Method):uint
		{
			return 0;
		}
		
		internal function expectedException(method:Method):Class
		{
			try {
				return method.declaringClass.test_expected::[method.name];
			}
			catch (e:ReferenceError) {
			}
			return null;
		}
	}
}