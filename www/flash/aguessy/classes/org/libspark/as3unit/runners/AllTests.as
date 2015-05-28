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

package org.libspark.as3unit.runners
{
	import org.libspark.asunit.framework.Test;
	import org.libspark.as3unit.inter.runners.OldTestClassRunner;
	
	/**
	 * Runner for use with ASUnit-style AllTests classes
	 * (those that only implement a static <code>suite()</code>
	 * method). For example:
	 * <code>
	 * public class ProductTests {
	 *     public static const RunWith:Class = AllTests;
	 *     public statc function suite():org.libspark.asunit.framework.Test {
	 *         ...
	 *     }
	 * }
	 * </code>
	 */
	public class AllTests extends OldTestClassRunner
	{
		public function AllTests(klass:Class)
		{
			super(testFromSuiteMethod(klass));
		}
        
        public static function testFromSuiteMethod(klass:Class):Test
        {
            var suite:Test = null;
            try {
                suite = klass["suite"]();
            }
            catch (e:Error) {
                throw new Error("Can not invoke " + klass + ".suite()");
            }
            return suite;
        }
	}
}