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
	import org.libspark.as3unit.inter.runners.CompositeRunner;
	import org.libspark.as3unit.inter.runners.MethodValidator;
	import org.libspark.as3unit.inter.runners.TestClassMethodsRunner;
	import org.libspark.as3unit.inter.runners.TestClassRunner;
	import org.libspark.as3unit.inter.runners.TestClassRunner;
	import org.libspark.as3unit.inter.runners.InitializationError;
	
	/**
	 * The custom runner <code>Parameterized</code> implements parameterized
	 * tests. When running a parameterizaed test class, instance are created for the
	 * cross-product of the test methods and the test data elements.
	 * 
	 * For example, to test a Fibonacci function, write
	 * <code>
	 * public class FibonnaciTest {
	 *     public static const RunWith:Class = Parameterized;
	 *     parameters static function date():Array {
	 *         return [[0, 0], [1, 2], [2, 1], [3, 2], [4, 3], [5, 5], [6, 8]];
	 *     }
	 *     private var input:uint;
	 *     private var expected:uint;
	 *     parameters_injection function initialize(input:uint, expected:uint) {
	 *         this.input = input;
	 *         this.expected = expected;
	 *     }
	 *     test function test():void {
	 *         assertEquals(expected, Fibonacci.compute(input));
	 *     }
	 * }
	 * </code>
	 * Each instance of <code>FibonacciTest</code> will be constructed using
	 * two-argument <code>parameter_injection</code> method and the date values in
	 * <code>parameters</code> method.
	 */
	public class Parameterized extends TestClassRunner
	{
		public static function eachOne(...params:Array):Array
		{
			var results:Array = new Array();
			for each (var param:Object in params) {
				results.push([param]);
			}
			return results;
		}
		
		public function Parameterized(klass:Class)
		{
			super(klass, new RunAllParameterMethods(klass));
		}
		
		protected override function validate(methodValidator:MethodValidator):void
		{
			methodValidator.validateStaticMethods();
			methodValidator.validateInstanceMethods();
		}
	}
}

import org.libspark.as3unit.inter.runners.TestClassMethodsRunner;
import org.libspark.as3unit.inter.runners.Method;
import org.libspark.as3unit.inter.runners.CompositeRunner;
import org.libspark.as3unit.assert.fail;

import org.libspark.as3unit.runners.parameters;
import org.libspark.as3unit.runners.parameters_injection;

import flash.utils.getQualifiedClassName;

class TestClassRunnerForParameters extends TestClassMethodsRunner
{
	private var parameters:Array;
	private var parameterSetNumber:uint;
	private var injectMethod:Method;
	
	public function TestClassRunnerForParameters(klass:Class, parameters:Array, i:uint)
	{
		super(klass);
		this.parameters = parameters;
		this.parameterSetNumber = i;
		injectMethod = getInjectMethod();
	}
	
	protected override function createTest():Object
	{
		var test:Object = super.createTest();
		injectMethod.invoke(test, parameters);
		return test;
	}
	
	protected override function get name():String
	{
		return '[' + parameterSetNumber + ']';
	}
	
	protected override function testName(method:Method):String
	{
		return method.name + '[' + parameterSetNumber + ']';
	}
	
	private function getInjectMethod():Method
	{
		for each (var method:Method in Method.getDeclaredMethods(testClass)) {
			if (method.namespace.uri == parameters_injection.uri) {
				return method;
			}
		}
		throw new Error('No parameter injection method on class ' + getQualifiedClassName(testClass));
	}
}

class RunAllParameterMethods extends CompositeRunner
{
	private var klass:Class;
	
	public function RunAllParameterMethods(klass:Class)
	{
		super(getQualifiedClassName(klass));
		this.klass = klass;
		var i:uint = 0;
		for each (var parameters:Array in getParametersList()) {
			super.add(new TestClassRunnerForParameters(klass, parameters, i++));
		}
	}
	
	private function getParametersList():Array
	{
		return getParametersMethod().invoke(null);
	}
	
	private function getParametersMethod():Method
	{
		for each (var method:Method in Method.getDeclaredMethods(klass)) {
			if (method.isStatic) {
				if (method.namespace.uri == parameters.uri) {
					return method;
				}
			}
		}
		throw new Error('No public static parameters method on class ' + name);
	}
}