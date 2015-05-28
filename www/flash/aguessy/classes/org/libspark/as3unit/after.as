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
	 * If you allocate external resources in a <code>before</code> method you need to release them
	 * after the test runs. Declaring a <code>void</code> method with <code>after</code> namespace
	 * that method to be run after the <code>test</code> method. All <code>after</code> methods are
	 * guaranteed to run even if a <code>before</code> or <code>test</code> method throws an exception.
	 * 
	 * For example:
	 * 
	 * <code>
	 * public class Example {
	 *     private var bitmap:BitmapData;
	 *     before function createBitmapData():void {
	 *         bitmap = new BitmapData(200, 200);
	 *     }
	 *     test function something():void {
	 *         ...
	 *     }
	 *     after function disposeBitmapData():void {
	 *         bitmap.dispose();
	 *     }
	 * }
	 * </code>
	 * 
	 * @see org.libspark.as3unit.before
	 */
	public namespace after = 'http://as3unit.libspark.org/after';
}