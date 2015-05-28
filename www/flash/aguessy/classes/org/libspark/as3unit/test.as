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
	 * The <code>test</code> namespace tells AS3Unit that the <code>void</code> method
	 * to which it is attached can be run as a test case. To run the method,
	 * AS3Unit first constructs a fresh instance of the class then invokes the
	 * <code>test</code> method. Any exception thrown by the test will be reported
	 * by AS3Unit as a failure. If no exceptions are thrown, the test is assumed
	 * to have succeeded.
	 * 
	 * A simple test looks like this:
	 * 
	 * <code>
	 * public class Example {
	 *     test function method():void {
	 *         trace('Hello');
	 *     }
	 * }
	 * </code>
	 */
	public namespace test = 'http://as3unit.libspark.org/test';
}