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

package org.libspark.as3unit.inter.requests
{
	import org.libspark.as3unit.inter.runners.CompositeRunner;
	import org.libspark.as3unit.inter.runners.ErrorReportingRunner;
	import org.libspark.as3unit.inter.runners.InitializationError;
	import org.libspark.as3unit.runner.Description;
	import org.libspark.as3unit.runner.Request;
	import org.libspark.as3unit.runner.Runner;
	
	import flash.utils.getQualifiedClassName;
	
	public class ErrorReportingRequest extends Request
	{
		private var fClass:Class;
		private var fCause:Object;
		
		public function ErrorReportingRequest(klass:Class, cause:Object)
		{
			fClass = klass;
			fCause = cause;
		}
		
		public override function getRunner():Runner
		{
			var goofs:Array = getCauses(fCause);
			var runner:CompositeRunner = new CompositeRunner(getQualifiedClassName(fClass));
			for (var i:uint = 0; i < goofs.length; ++i) {
				var description:Description = Description.createTestDescription(fClass, "initializationError" + i);
				var error:Object = goofs[i];
				runner.add(new ErrorReportingRunner(description, error));
			}
			return runner;
		}
		
		private function getCauses(cause:Object):Array
		{
			if (cause is InitializationError) {
				return InitializationError(cause).causes;
			}
			return [cause];
		}
	}
}