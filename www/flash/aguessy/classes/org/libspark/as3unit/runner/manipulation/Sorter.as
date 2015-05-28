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
	 * A <code>Sorter</code> orders tests. In general you will not need to use
	 * a <code>Sorter</code> directly. Instead, use <code>Request.sortWith(Comparator)</code>.
	 */
	public class Sorter implements Comparator
	{
		private var fComparator:Comparator;
		
		public function Sorter(comparator:Comparator)
		{
			fComparator = comparator;
		}
		
		public function apply(runner:Runner):void
		{
			if (runner is Sortable) {
				var sortable:Sortable = Sortable(runner);
				sortable.sort(this);
			}
		}
		
		public function compare(o1:Description, o2:Description):int
		{
			return fComparator.compare(o1, o2);
		}
	}
}