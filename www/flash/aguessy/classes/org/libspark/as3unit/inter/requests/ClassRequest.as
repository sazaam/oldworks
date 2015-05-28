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
    import org.libspark.as3unit.ignore;
    import org.libspark.as3unit.inter.runners.InitializationError;
	import org.libspark.as3unit.inter.runners.OldTestClassRunner;
	import org.libspark.as3unit.inter.runners.TestClassRunner;
	import org.libspark.as3unit.runner.Request;
	import org.libspark.as3unit.runner.Runner;
    import org.libspark.as3unit.runners.AllTests;
	import org.libspark.asunit.framework.TestCase;
	
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	public class ClassRequest extends Request
	{
		private var testClass:Class;
        private var canUseSuiteMethod:Boolean;
		
		public function ClassRequest(testClass:Class, canUseSuiteMethod:Boolean = true)
		{
			this.testClass = testClass;
            this.canUseSuiteMethod = canUseSuiteMethod;
		}
		
		public override function getRunner():Runner
		{
            return buildRunner(getRunnerClass(testClass));
        }
        
        public function buildRunner(runnerClass:Class):Runner
        {
			try {
				return new runnerClass(testClass);
			}
			catch (e:Error) {
				return Request.errorReport(testClass, e).getRunner();
			}
			return null;
		}
		
		internal function getRunnerClass(testClass:Class):Class
		{
            if ('Ignore' in testClass) {
                return IgnoredClassRunner;
            }
			if ('RunWith' in testClass) {
				return testClass.RunWith;
			}
            else if (hasSuiteMethod() && canUseSuiteMethod) {
                return AllTests;
            }
			else if (isPre4Test(testClass)) {
				return OldTestClassRunner;
			}
			else {
				return TestClassRunner;
			}
		}
        
        public function hasSuiteMethod():Boolean
        {
            if ('suite' in testClass) {
                return true;
            }
            return false;
        }
		
		internal function isPre4Test(testClass:Class):Boolean
		{
			const type:String = getQualifiedClassName(TestCase);
			for each (var ex:XML in describeType(testClass).factory.extendsClass) {
				if (ex.@type == type) {
					return true;
				}
			}
			return false;
		}
	}
}