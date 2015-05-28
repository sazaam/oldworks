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
	 * Asserts that two ByteArrays are equal. If they are not
	 * an AssertionFailedError is thrown with the given message.
	 */
	public function assertByteArrayEquals(expected:ByteArray, actual:ByteArray, message:String=""):void
	{
		if (expected == null && actual == null) {
			return;
		}
		if (expected != null && (expected.length == actual.length)) {
			var len:uint = expected.length;
			var index:uint = 0;
			for (; index < len; ++index) {
				if (actual[index] != expected[index]) {
					break;
				}
			}
			if (index == len) {
				return;
			}
		}
		failNotEquals(byteArray2HexString(expected), byteArray2HexString(actual), message);
	}
}

import flash.utils.ByteArray;

function byteArray2HexString(bytes:ByteArray):String
{
	var hex:String = "0123456789abcdef";
	var hexString:String = "0x";
	for (var i:uint = 0; i < bytes.length; ++i) {
		var n:uint = bytes[i];
		hexString += hex.charAt((n >> 4) & 0xf) + hex.charAt(n & 0xf);
	}
	return hexString;
}