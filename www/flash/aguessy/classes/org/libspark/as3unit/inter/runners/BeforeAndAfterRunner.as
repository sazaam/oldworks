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
	public class BeforeAndAfterRunner
	{
		private var beforeAnnotation:Namespace;
		private var afterAnnotation:Namespace;
		private var testIntrospector:TestIntrospector;
		private var test:Object;
		
		public function BeforeAndAfterRunner(testClass:Class, 
			beforeAnnotation:Namespace, 
			afterAnnotation:Namespace, 
			test:Object)
		{
			this.beforeAnnotation = beforeAnnotation;
			this.afterAnnotation = afterAnnotation;
			testIntrospector = new TestIntrospector(testClass);
			this.test = test;
		}
		
		public function runProtected():void
		{
			try {
				runBefores();
				runUnprotected();
			}
			catch (e:FailedBefore) {
			}
			finally {
				runAfters();
			}
		}
		
		protected function runUnprotected():void
		{
			throw new DefinitionError('Subclass must override this method.');
		}
		
		protected function addFailure(targetException:Object):void
		{
			throw new DefinitionError('Subclass must override this method.');
		}
		
		private function runBefores():void
		{
			try {
				var befores:Array = testIntrospector.getTestMethods(beforeAnnotation);
				for each (var before:Method in befores) {
					invokeMethod(before);
				}
			}
			catch (e:Object) {
				addFailure(e);
				throw new FailedBefore();
			}
		}
		
		private function runAfters():void
		{
			var afters:Array = testIntrospector.getTestMethods(afterAnnotation);
			for each (var after:Method in afters) {
				try {
					invokeMethod(after);
				}
				catch (e:Object) {
					addFailure(e);
				}
			}
		}
		
		private function invokeMethod(method:Method):void
		{
			method.invoke(test);
		}
	}
}

class FailedBefore extends Error
{
}