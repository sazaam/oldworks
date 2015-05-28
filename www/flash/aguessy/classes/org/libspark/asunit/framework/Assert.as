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

 package org.libspark.asunit.framework
 {
 	import flash.utils.ByteArray;
 	
 	/**
 	 * A set of asserft methods. Messages are only displayed when an assert fails.
 	 */
 	public class Assert
 	{
 		/**
 		 * Asserts that a condition is true. If it isn't it throws
 		 * an AssertionFailedError with the given message.
 		 */
 		static public function assertTrue(condition:Boolean, message:String=""):void
 		{
 			if (!condition) {
 				fail(message);
 			}
 		}
 		
 		/**
 		 * Asserts that a condition is false. If it isn't it throws
 		 * an AssertionFailedError with the given message.
 		 */
 		static public function assertFalse(condition:Boolean, message:String=""):void
 		{
 			assertTrue(!condition, message);
 		}
 		
 		/**
 		 * Fails a test with the given message.
 		 */
 		static public function fail(message:String=""):void
 		{
 			throw new AssertionFailedError(message);
 		}
 		
 		/**
 		 * Asserts that two objects are equal. If they are not
 		 * an AssertionFailedError is thrown with the given message.
 		 */
 		static public function assertEquals(expected:*, actual:*, message:String=""):void
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
					assertArrayEquals(expected, actual, message);
					return;
				}
				if ('equals' in expected && expected.equals(actual)) {
					return;
				}
			}
 			failNotEquals(expected, actual, message);
 		}
	 	
		/**
		 * Asserts that two objects refer to the same object. If they are not
		 * an AssertionFailedError is thrown with the given message.
		 * This method uses Strict Equality Operator (===) for comparation.
		 */
		static public function assertSame(expected:*, actual:*, message:String=""):void
		{
			if (expected === actual) {
				return;
			}
			failNotSame(expected, actual, message);
		}
 		
		/**
		 * Asserts that two objects do not refer to the same object. If they are not
		 * an AssertionFailedError is thrown with the given message.
		 * This method uses Strict Equality Operator (===) for comparation.
		 */
		static public function assertNotSame(expected:*, actual:*, message:String=""):void
		{
			if (expected === actual) {
				failSame(message);
			}
		}
		
 		/**
 		 * Asserts that an object isn't null. If it is
 		 * an AssertionFailedError is thrown with the given message.
 		 */
 		static public function assertNotNull(object:*, message:String=""):void
 		{
 			assertTrue(object != null, message);
 		}
 		
 		/**
 		 * Asserts that an object is null. If it is not
 		 * an AssertionFailedError is thrown with the given message.
 		 */
 		static public function assertNull(object:*, message:String=""):void
 		{
 			assertTrue(object == null, message);
 		}
 		
		/**
		 * Asserts that two arrays are equal. If they are not
		 * an AssertionFailedError is thrown with the given message.
		 */
		static public function assertArrayEquals(expected:Array, actual:Array, message:String=""):void
		{
			if (expected == actual) {
				return;
			}
			
			var header:String = message == "" ? "" : message + ": ";
			
			if (expected == null) {
				fail(header + "expected array was null");
			}
			if (actual == null) {
				fail(header + "actual array was null");
			}
			if (expected.length != actual.length) {
				fail(header + "array lengths differed, expected.length=" + expected.length + " actual.length=" + actual.length);
			}
			
			var len:uint = expected.length;
			for (var index:uint = 0; index < len; ++index) {
				
				var expectedObject:* = expected[index];
				var actualObject:* = actual[index];
				
				if (expectedObject is Array && actualObject is Array) {
					assertArrayEquals(expectedObject, actualObject, header + "arrays first differed at element " + index + ";");
				}
				else {
					assertEquals(expectedObject, actualObject, header + "arrays first differed at element [" + index + "];");
				}
			}
		}
 		
 		/**
 		 * Asserts that two ByteArrays are equal. If they are not
 		 * an AssertionFailedError is thrown with the given message.
 		 */
 		static public function assertByteArrayEquals(expected:ByteArray, actual:ByteArray, message:String=""):void
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
 		
 		static private function byteArray2HexString(bytes:ByteArray):String
 		{
 			var hex:String = "0123456789abcdef";
 			var hexString:String = "0x";
 			for (var i:uint = 0; i < bytes.length; ++i) {
 				var n:uint = bytes[i];
 				hexString += hex.charAt((n >> 4) & 0xf) + hex.charAt(n & 0xf);
 			}
 			return hexString;
 		}
 		
 		static private function failNotEquals(expected:*, actual:*, message:String):void
 		{
 			fail((message != "" ? message + " " : "") + "expected:<" + expected + "> but was:<" + actual + ">");
 		}
 		
		static private function failSame(message:String):void
		{
			if (message != '') {
				message += ' ';
			}
			fail(message + 'expected not same');
		}
		
		static private function failNotSame(expected:*, actual:*, message:String):void
		{
			if (message != '') {
				message += ' ';
			}
			fail(message + 'expected same:<' + expected + '> was not:<' + actual + '>');
		}
 	}
 }