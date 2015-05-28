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

package org.libspark.as3unit
{
	/**
	 * Sometimes several tests need to share computationally expensive setup
	 * (like logging int oa database). While this compromise the independence of
	 * tests, sometimes it is a necessary optimization. Declaring a <code>static void</code> no-arg method
	 * with <code>beforeClass</code> namespace it to be run once before any of
	 * the test method in the class.
	 * 
	 * For example:
	 * 
	 * <code>
	 * public class Example {
	 *     beforeClass static function onlyOnce():void {
	 *         ...
	 *     }
	 *     test function tests():void {
	 *         ...
	 *     }
	 * }
	 * </code>
	 * 
	 * @see org.libspark.as3unit.afterClass
	 */
	public namespace beforeClass = 'http://as3unit.libspark.org/beforeClass';
}