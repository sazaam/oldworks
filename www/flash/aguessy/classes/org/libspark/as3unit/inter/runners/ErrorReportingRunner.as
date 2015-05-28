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
	import org.libspark.as3unit.runner.Description;
	import org.libspark.as3unit.runner.Runner;
	import org.libspark.as3unit.runner.notification.RunNotifier;
	
	public class ErrorReportingRunner extends Runner
	{
		private var _description:Description;
		private var cause:Object;
		
		public function ErrorReportingRunner(description:Description, cause:Object):void
		{
			_description = description;
			this.cause = cause;
		}
		
		public override function get description():Description
		{
			return _description;
		}
		
		public override function run(notifier:RunNotifier):void
		{
			notifier.testAborted(_description, cause);
		}
	}
}