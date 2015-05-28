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
    import flash.utils.getQualifiedClassName;
    
    public function format(message:String, expected:Object, actual:Object):String
    {
        var formatted:String = "";
        if (message != null && message != "") {
            formatted = message + " ";
        }
        var expectedString:String = String(expected);
        var actualString:String = String(actual);
        if (expectedString == actualString) {
            return formatted + "expected: " + getQualifiedClassName(expected) + "<" + expectedString + "> but was: " + getQualifiedClassName(actual) + "<" + actualString + ">";
        }
        else {
            return formatted + "expected:<" + expectedString + "> but was:<" + actualString + ">";
        }
    }
}