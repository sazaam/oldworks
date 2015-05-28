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
	import org.libspark.as3unit.afterClass;
	import org.libspark.as3unit.beforeClass;
	import org.libspark.as3unit.runner.Description;
	import org.libspark.as3unit.runner.Runner;
	import org.libspark.as3unit.runner.manipulation.Filter;
	import org.libspark.as3unit.runner.manipulation.Filterable;
	import org.libspark.as3unit.runner.manipulation.NoTestsRemainException;
	import org.libspark.as3unit.runner.manipulation.Sortable;
	import org.libspark.as3unit.runner.manipulation.Sorter;
	import org.libspark.as3unit.runner.notification.RunNotifier;
	import org.libspark.as3unit.runner.notification.Failure;
	import org.libspark.as3unit.runner.notification.RunNotifier;
	
	public class TestClassRunner extends Runner implements Filterable, Sortable
	{
		protected var enclosedRunner:Runner;
		private var fTestClass:Class;
		
		public function TestClassRunner(klass:Class, runner:Runner=null)
		{
			fTestClass = klass;
			if (runner == null) {
				runner = new TestClassMethodsRunner(klass);
			}
			enclosedRunner = runner;
			var methodValidator:MethodValidator = new MethodValidator(klass);
			validate(methodValidator);
			methodValidator.assertValid();
		}
		
		protected function validate(methodValidator:MethodValidator):void
		{
			methodValidator.validateMethodsForDefaultRunner();
		}
		
		public override function run(notifier:RunNotifier):void
		{
			var runner:BeforeAndAfterRunner = new BeforeClassAndAfterClassRunner(
				testClass, enclosedRunner, notifier, description);
			runner.runProtected();
		}
		
		public override function get description():Description
		{
			return enclosedRunner.description;
		}
		
		public function filter(filter:Filter):void
		{
			filter.apply(enclosedRunner);
		}
		
		public function sort(sorter:Sorter):void
		{
			sorter.apply(enclosedRunner);
		}
		
		protected function get testClass():Class
		{
			return fTestClass;
		}
	}
}

import org.libspark.as3unit.beforeClass;
import org.libspark.as3unit.afterClass;
import org.libspark.as3unit.inter.runners.BeforeAndAfterRunner;
import org.libspark.as3unit.runner.Runner;
import org.libspark.as3unit.runner.Description;
import org.libspark.as3unit.runner.notification.RunNotifier;
import org.libspark.as3unit.runner.notification.Failure;

class BeforeClassAndAfterClassRunner extends BeforeAndAfterRunner
{
	private var runner:Runner;
	private var notifier:RunNotifier;
	private var description:Description;
	
	public function BeforeClassAndAfterClassRunner(klass:Class, 
		runner:Runner, notifier:RunNotifier, description:Description)
	{
		super(klass, beforeClass, afterClass, null);
		this.runner = runner;
		this.notifier = notifier;
		this.description = description;
	}
	
	protected override function runUnprotected():void
	{
		runner.run(notifier);
	}
	
	protected override function addFailure(targetException:Object):void
	{
		notifier.fireTestFailure(new Failure(description, targetException));
	}
}