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
	import org.libspark.as3unit.before;
	import org.libspark.as3unit.assert.AssertionFailedError;
	import org.libspark.as3unit.runner.Description;
	import org.libspark.as3unit.runner.notification.RunNotifier;
	import org.libspark.as3unit.runner.notification.Failure;
	
	import flash.utils.getQualifiedClassName;
	
	public class TestMethodRunner extends BeforeAndAfterRunner
	{
		private var test:Object;
		private var method:Method;
		private var notifier:RunNotifier;
		private var testIntrospector:TestIntrospector;
		private var description:Description;
		
		public function TestMethodRunner(test:Object, method:Method, notifier:RunNotifier, description:Description)
		{
			super(test.constructor, before, after, test);
			this.test = test;
			this.method = method;
			this.notifier = notifier;
			testIntrospector = new TestIntrospector(test.constructor);
			this.description = description;
		}
		
		public function run():void
		{
			if (testIntrospector.isIgnored(method)) {
				notifier.fireTestIgnored(description);
				return;
			}
			notifier.fireTestStarted(description);
			try {
				runMethod();
			}
			finally {
				notifier.fireTestFinished(description);
			}
		}
		
		private function runMethod():void
		{
			runProtected();
		}
		
		protected override function runUnprotected():void
		{
			try {
				executeMethodBody();
				if (exceptsException) {
					addFailure(new AssertionFailedError('Expected exception: ' + getQualifiedClassName(expectedException)));
				}
			}
			catch (e:Object) {
				if (!exceptsException) {
					addFailure(e);
				}
				else if (isUnexpected(e)) {
					addFailure(new Error('Unexpected exception, expected<' + getQualifiedClassName(expectedException) + '> but was<' + getQualifiedClassName(e) + '>'));
				}
			}
		}
		
		protected function executeMethodBody():void
		{
			method.invoke(test);
		}
		
		protected override function addFailure(e:Object):void
		{
			notifier.fireTestFailure(new Failure(description, e));
		}
		
		private function get exceptsException():Boolean
		{
			return expectedException != null;
		}
		
		private function get expectedException():Class
		{
			return testIntrospector.expectedException(method);
		}
		
		private function isUnexpected(exception:Object):Boolean
		{
			return !(exception is expectedException);
		}
	}
}