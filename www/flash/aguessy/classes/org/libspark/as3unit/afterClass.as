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
	 * If you allocate expensive external resources in a <code>beforeClass</code> method you need to release them
	 * after all the tests in the class have run. Declaring a <code>static void</code> method
	 * with <code>afterClass</code> namespace that method to be run after all the tests in the class have been run.
	 * All <code>afterClass</code> methods are guaranteed to run even if a <code>beforeClass</code> method thrown an
	 * exception.
	 * 
	 * For example:
	 * 
	 * <code>
	 * public class Example {
	 *     var bitmap:BitmapData;
	 *     beforeClass static function allocate():void {
	 *         bitmap = new BitmapData(200, 200);
	 *     }
	 *     test function something():void {
	 *     }
	 *     afterClass static function dispose():void {
	 *         bitmap.dispose();
	 *     }
	 * }
	 * </code>
	 * 
	 * @see org.libspark.as3unit.beforeClass
	 */
	public namespace afterClass = 'http://as3unit.libspark.org/afterClass';
}