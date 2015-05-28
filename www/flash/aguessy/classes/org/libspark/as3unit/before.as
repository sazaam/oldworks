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
	 * When writing tests, it is common to find that serveral tests need similar
	 * objects created before they can run. Declaring a <code>void</code> method
	 * with <code>before</code> namespace that method to be run before the <code>test</code> method.
	 * 
	 * For exapmle:
	 * 
	 * <code>
	 * public class Example {
	 *     private var empty:Array;
	 *     before static function initialize():void {
	 *         empty = new Array();
	 *     }
	 *     test function size():void {
	 *         ...
	 *     }
	 * }
	 * </code>
	 * 
	 * @see org.libspark.as3unit.beforeClass
	 * @see org.libspark.as3unit.after
	 */
	public namespace before = 'http://as3unit.libspark.org/before';
}