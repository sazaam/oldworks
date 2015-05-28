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

package org.libspark.as3unit.runner.manipulation
{
	import org.libspark.as3unit.runner.Description;
	import org.libspark.as3unit.runner.Runner;
	
	/**
	 * The canonical case of filtering is when you want to run a single test method in a class.
	 * Rather than introduce runner API just for that one case, AS3Unit provides a general
	 * filtering mechanism. If you want to filter the tests to be run, extend <code>Filter</code>
	 * and apply an instance of your filter to the <code>Request</code> before running it
	 * (see <code>AS3UnitCore.run(request:Request)</code>).
	 * Alternatively, apply a <code>Filter</code> to a <code>Runner</code> before running
	 * tests (for exapmle, in conjunction with <code>RunWith</code>
	 */
	public class Filter
	{
		/**
		 * A null <code>Filter</code> that presses all tests through.
		 */
		public static var ALL:Filter;
		
		/**
		 * @param description the description of the test to be run
		 * @return true if the test should be run
		 */
		public function shouldRun(description:Description):Boolean
		{
			throw new DefinitionError('You must override this method.');
			return true;
		}
		
		/**
		 * Invoke with a <code>Runner</code> to cause all thests it intends to run
		 * to first be checked with the filter. Only those that pass the filter will be run.
		 * @param runner the runner to be filtered by the reciver
		 * @throws NoTestsRemainException if the reciver removes all tests
		 */
		public function apply(runner:Runner):void
		{
			if (runner is Filterable) {
				var filterable:Filterable = Filterable(runner);
				filterable.filter(this);
			}
		}
		
		public function get describe():String
		{
			throw new DefinitionError('You must override this method.');
			return '';
		}
	}
}

import org.libspark.as3unit.runner.manipulation.Filter;
import org.libspark.as3unit.runner.Description;

class NullFilter extends Filter
{
	public override function shouldRun(description:Description):Boolean
	{
		return true;
	}
	
	public override function get describe():String
	{
		return 'all tests';
	}
	
	private static const initialize:* = staticInitializer();
	private static function staticInitializer():void
	{
		Filter.ALL = new NullFilter();
	}
}