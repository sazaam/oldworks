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
	import org.libspark.as3unit.after;
	import org.libspark.as3unit.afterClass;
	import org.libspark.as3unit.before;
	import org.libspark.as3unit.beforeClass;
	import org.libspark.as3unit.test;
	
	import flash.utils.describeType;
	
	public class MethodValidator
	{
		private var introspector:TestIntrospector;
		private var errors:Array;
		private var testClass:Class;
		
		public function MethodValidator(testClass:Class)
		{
			this.testClass = testClass;
			introspector = new TestIntrospector(testClass);
			errors = new Array();
		}
		
		public function validateInstanceMethods():void
		{
			validateTestMethods(after, false);
			validateTestMethods(before, false);
			validateTestMethods(test, false);
		}
		
		public function validateStaticMethods():void
		{
			validateTestMethods(beforeClass, true);
			validateTestMethods(afterClass, true);
		}
		
		public function validateMethodsForDefaultRunner():Array
		{
			validateNoArgConstructor();
			validateStaticMethods();
			validateInstanceMethods();
			return errors;
		}
		
		public function assertValid():void
		{
			if (errors.length > 0) {
				throw new InitializationError(errors);
			}
		}
		
		public function validateNoArgConstructor():void
		{
			var constructor:XMLList = describeType(testClass).factory.constructor;
			if (constructor != null) {
				if (constructor.parameter.length() > 0) {
					errors.push(new Error('Test class should have public zero-argument constructor'));
				}
			}
		}
		
		private function validateTestMethods(annotation:Namespace, isStatic:Boolean):void
		{
			var methods:Array = introspector.getTestMethods(annotation);
			for each (var each:Method in methods) {
				if (each.isStatic != isStatic) {
					errors.push(new Error('Method ' + each.name + '() ' + (isStatic ? 'should' : 'should not') + ' be static'));
				}
				if (each.returnType != 'void') {
					errors.push(new Error('Method ' + each.name + '() should be void'));
				}
				if (each.parameters.length != 0) {
					errors.push(new Error('Method ' + each.name + '() should have no parameters'));
				}
			}
		}
	}
}