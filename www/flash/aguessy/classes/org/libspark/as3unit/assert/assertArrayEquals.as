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
	 * Asserts that two arrays are equal. If they are not
	 * an AssertionFailedError is thrown with the given message.
	 */
	public function assertArrayEquals(expected:Array, actual:Array, message:String = ""):void
	{
		if (expected == actual) {
			return;
		}
		
		var header:String = (message == null || message == "") ? "" : message + ": ";
		
		if (expected == null) {
			fail(header + "expected array was null");
		}
		if (actual == null) {
			fail(header + "actual array was null");
		}
        var actualLength:uint = actual.length;
        var expectedLength:uint = expected.length;
        if (actualLength != expectedLength) {
            fail(header + "array lengths differed, expected.length=" + expectedLength + " actual.length=" + actualLength);
        }
        
        for (var i:uint = 0; i < expectedLength; ++i) {
            var expectedObject:* = expected[i];
            var actualObject:* = actual[i];
            if (expectedObject is Array && actualObject is Array) {
                try {
                    assertArrayEquals(expectedObject, actualObject, message);
                }
                catch (e1:ArrayComparsionFailure) {
                    e1.addDimension(i);
                    throw e1;
                }
            }
            else {
                try {
                    assertEquals(expectedObject, actualObject);
                }
                catch (e2:AssertionFailedError) {
                    throw new ArrayComparsionFailure(header, e2, i);
                }
            }
        }
	}
}