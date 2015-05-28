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
     * Thrown when two array elements differ.
     */
    public class ArrayComparsionFailure extends AssertionFailedError
    {
        /**
         * Construct a new <code>ArrayComparisonFailure</code> with an error text and the array's
         * dimension that was not equal
         * @param cause the exception that caused the array's content to fail the assertion test 
         * @param index the array position of the objects that are not equal.
         */
        public function ArrayComparsionFailure(message:String, cause:AssertionFailedError, index:uint)
        {
            super("");
            this.msg = message;
            this.cause = cause;
            addDimension(index);
            this.message = createMessage(message);
        }
        
        private var indices:Array = [];
        private var msg:String;
        private var cause:AssertionFailedError;
        
        public function addDimension(index:uint):void
        {
            indices.unshift(index);
            message = createMessage(msg);
        }
        
        private function createMessage(message:String):String
        {
            var result:String = "";
            if (message != null) {
                result += message;
            }
            result += "arrays first differed at element ";
            for each (var each:uint in indices) {
                result += "[" + each + "]";
            }
            result += "; ";
            result += cause.message;
            return result;
        }
    }
}