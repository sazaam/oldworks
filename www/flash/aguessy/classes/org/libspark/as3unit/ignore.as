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
	 * Sometimes you want to temporarlly disable a test. Methods annotated with <code>test</code>
	 * that are also annotated with <code>ignore</code> will not be executed as tests. Native 
	 * AS3Unit test runners should report the number of ignored tests along with the number of
	 * tests that ran and the number of tests that failed.
	 * For example:
	 * <code>
	 * ignore static const something:String;
	 * test function something():void {
	 *     ...
	 * }
	 * </code>
	 * Please create <code>static const</code> property with same name as test method.
	 * If you want to record why a test is being ignored, set string constant.
	 * <code>
	 * ignore static const something:String = 'not ready yet';
	 * test function something():void {
	 *     ...
	 * }
	 * </code>
	 */
	public namespace ignore = 'http://as3unit.libspark.org/ignore';
}