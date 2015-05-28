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
	import flash.utils.ByteArray;
	
	/**
	 * Asserts that two objects are equal. If they are not
	 * an AssertionFailedError is thrown with the given message.
	 */
	public function assertEquals(expected:*, actual:*, message:String = ""):void
	{
		if (expected == null && actual == null) {
			return;
		}
		if (expected != null) {
			if (expected == actual) {
				return;
			}
			if (expected is Array && actual is Array) {
				assertArrayEquals(expected, actual, message);
				return;
			}
			if (expected is ByteArray && actual is ByteArray) {
				assertByteArrayEquals(expected, actual, message);
				return;
			}
			if ('equals' in expected && expected.equals(actual)) {
				return;
			}
		}
        if (expected is String && actual is String) {
            throw new ComparsionFailure(message, expected, actual);
        }
		failNotEquals(expected, actual, message);
	}
}