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
	import org.libspark.as3unit.runner.manipulation.Filter;
	import org.libspark.as3unit.runner.manipulation.Filterable;
	import org.libspark.as3unit.runner.manipulation.NoTestsRemainException;
	import org.libspark.as3unit.runner.manipulation.Sortable;
	import org.libspark.as3unit.runner.manipulation.Sorter;
	import org.libspark.as3unit.runner.notification.RunNotifier;
	
	public class CompositeRunner extends Runner implements Filterable, Sortable
	{
		private var fRunners:Array;
		private var fName:String;
		
		public function CompositeRunner(name:String)
		{
			fRunners = new Array();
			fName = name;
		}
		
		public override function run(notifier:RunNotifier):void
		{
			for each (var runner:Runner in fRunners) {
				runner.run(notifier);
			}
		}
		
		public override function get description():Description
		{
			var spec:Description = Description.createSuiteDescription(fName);
			for each (var runner:Runner in fRunners) {
				spec.addChild(runner.description);
			}
			return spec;
		}
		
		public function get runners():Array
		{
			return fRunners;
		}
		
		public function addAll(runners:Array):void
		{
			fRunners = fRunners.concat(runners);
		}
		
		public function add(runner:Runner):void
		{
			fRunners.push(runner);
		}
		
		public function filter(filter:Filter):void
		{
			for (var i:uint = 0; i < fRunners.length; ++i) {
				var runner:Runner = Runner(fRunners[i]);
				if (filter.shouldRun(runner.description)) {
					filter.apply(runner);
				}
				else {
					fRunners.splice(i, 1);
				}
			}
		}
		
		protected function get name():String
		{
			return fName;
		}
		
		public function sort(sorter:Sorter):void
		{
			fRunners.sort(function(o1:Runner, o2:Runner):int {
				return sorter.compare(o1.description, o2.description);
			});
			for each (var runner:Runner in fRunners) {
				sorter.apply(runner);
			}
		}
	}
}