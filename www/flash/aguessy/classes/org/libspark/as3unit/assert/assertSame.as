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

package org.libspark.as3unit.assert
{
	/**
	 * Asserts that two objects refer to the same object. If they are not
	 * an AssertionFailedError is thrown with the given message.
	 * This method uses Strict Equality Operator (===) for comparation.
	 */
	public function assertSame(expected:*, actual:*, message:String=""):void
	{
		if (expected === actual) {
			return;
		}
		failNotSame(expected, actual, message);
	}
}