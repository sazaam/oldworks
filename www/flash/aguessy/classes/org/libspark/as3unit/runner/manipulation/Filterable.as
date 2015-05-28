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
	/**
	 * Runners that allow filtering should implements this interface. Implement <code>filter()</code>
	 * to remove tests that don't pass the filter.
	 */
	public interface Filterable
	{
		/**
		 * Remove tests that don't pass <code>filter</code>.
		 * @param filter the filter to apply
		 * @throws NoTestsRemainException if all tests are filtered out
		 */
		function filter(filter:Filter):void;
	}
}