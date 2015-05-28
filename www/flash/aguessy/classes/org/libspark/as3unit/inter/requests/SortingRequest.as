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
	import org.libspark.as3unit.runner.Description;
	import org.libspark.as3unit.runner.Request;
	import org.libspark.as3unit.runner.Runner;
	import org.libspark.as3unit.runner.manipulation.Sorter;
	import org.libspark.as3unit.runner.manipulation.Comparator;
	
	public class SortingRequest extends Request
	{
		private var request:Request;
		private var comparator:Comparator;
		
		public function SortingRequest(request:Request, comparator:Comparator)
		{
			this.request = request;
			this.comparator = comparator;
		}
		
		public override function getRunner():Runner
		{
			var runner:Runner = request.getRunner();
			new Sorter(comparator).apply(runner);
			return runner;
		}
	}
}