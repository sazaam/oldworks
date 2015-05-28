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
	import org.libspark.as3unit.runner.Request;
	import org.libspark.as3unit.runner.Runner;
	
	public class ClassesRequest extends Request
	{
		private var classes:Array;
		private var name:String;
		
		public function ClassesRequest(name:String, classes:Array)
		{
			this.classes = classes;
			this.name = name;
		}
		
		public override function getRunner():Runner
		{
			var runner:CompositeRunner = new CompositeRunner(name);
			for each (var eachClass:Class in classes) {
				var childRunner:Runner = Request.aClass(eachClass).getRunner();
				if (childRunner != null) {
					runner.add(childRunner);
				}
			}
			return runner;
		}
	}
}