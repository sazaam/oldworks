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
     * Thrown when an assertEquals(String, String) failes.
     */
    public class ComparsionFailure extends AssertionFailedError
    {
        private static const MAX_CONTEXT_LENGTH:uint = 20;
        
        /**
         * Constructs a comparison failure.
         * @param message the identifying message or null
         * @param expected the expected string value
         * @param actual the actual string value
         */
        public function ComparsionFailure(message:String, expected:String, actual:String)
        {
            super(createMessage(expected, actual, message));
            _expected = expected;
            _actual = actual;
        }
        
        private var _expected:String;
        private var _actual:String;
        
        protected function createMessage(expected:String, actual:String, message:String):String
        {
            return new ComparsionCompactor(MAX_CONTEXT_LENGTH, expected, actual).compact(message);
        }
        
        /**
         * Returns the actual string value
         * @return the actual string value
         */
        public function get actual():String
        {
            return _actual;
        }
        
        /**
         * Returns the expected string value
         * @return the expected string value
         */
        public function get expected():String
        {
            return _expected;
        }
    }
}

import org.libspark.as3unit.assert.format;

class ComparsionCompactor
{
    private static const ELLIPSIS:String = "...";
    private static const DELTA_END:String = "]";
    private static const DELTA_START:String = "[";
    
    public function ComparsionCompactor(contextLength:uint, expected:String, actual:String)
    {
        this.contextLength = contextLength;
        this.expected = expected;
        this.actual = actual;
    }
    
    private var contextLength:uint;
    private var expected:String;
    private var actual:String;
    private var prefix:int;
    private var suffix:int;
    
    public function compact(message:String):String
    {
        if (expected == null || actual == null || areStringsEqual()) {
            return format(message, expected, actual);
        }
        
        findCommonPrefix();
        findCommonSuffix();
        
        var ex:String = compactString(expected);
        var ac:String = compactString(actual);
        return format(message, ex, ac);
    }
    
    private function compactString(source:String):String
    {
        var result:String = DELTA_START + source.substring(prefix, source.length - suffix + 1) + DELTA_END;
        if (prefix > 0) {
            result = computeCommonPrefix() + result;
        }
        if (suffix > 0) {
            result = result + computeCommonSuffix();
        }
        return result;
    }
    
    private function findCommonPrefix():void
    {
        prefix = 0;
        var end:int = Math.min(expected.length, actual.length);
        for (; prefix < end; ++prefix) {
            if (expected.charAt(prefix) != actual.charAt(prefix)) {
                break;
            }
        }
    }
    
    private function findCommonSuffix():void
    {
        var expectedSuffix:int = expected.length - 1;
        var actualSuffix:int = actual.length - 1;
        for (; actualSuffix >= prefix && expectedSuffix >= prefix; --actualSuffix, --expectedSuffix) {
            if (expected.charAt(expectedSuffix) != actual.charAt(actualSuffix)) {
                break;
            }
        }
        suffix = expected.length - expectedSuffix;
    }
    
    private function computeCommonPrefix():String
    {
        return (prefix > contextLength ? ELLIPSIS : "") + expected.substring(Math.max(0, prefix - contextLength), prefix);
    }
    
    private function computeCommonSuffix():String
    {
        var end:int = Math.min(expected.length - suffix + 1 + contextLength, expected.length);
        return expected.substring(expected.length - suffix + 1, end) + (expected.length - suffix + 1 < expected.length - contextLength ? ELLIPSIS : "");
    }
    
    private function areStringsEqual():Boolean
    {
        return expected === actual;
    }
}