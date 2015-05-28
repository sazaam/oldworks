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
	import org.libspark.as3unit.runner.Request;
	import org.libspark.as3unit.runner.Runner;
	import org.libspark.as3unit.runner.manipulation.Filter;
	import org.libspark.as3unit.runner.manipulation.NoTestsRemainException;
	
	public class FilterRequest extends Request
	{
		private var request:Request;
		private var filter:Filter;
		
		public function FilterRequest(classRequest:Request, filter:Filter)
		{
			request = classRequest;
			this.filter = filter;
		}
		
		public override function getRunner():Runner
		{
			try {
				var runner:Runner = request.getRunner();
				filter.apply(runner);
				return runner;
			}
			catch (e:NoTestsRemainException) {
				return Request.errorReport(Filter, new Error('No tests found matching ' + 
					filter.describe + ' from ' + request)).getRunner();
			}
			return null;
		}
	}
}