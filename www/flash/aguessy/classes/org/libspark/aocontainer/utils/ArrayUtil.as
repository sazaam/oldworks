/*
 * Copyright(c) 2006-2007 the Spark project.
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

package org.libspark.aocontainer.utils
{
    /**
     * Utility for Array.
     *
     * @author yossy
     */
    public class ArrayUtil
    {
        public static function addElement(element:*, source:Array):*
        {
            source.push(element);
            return element;
        }
        
        public static function addElementAt(element:*, index:int, source:Array):*
        {
            if (source.length < index) {
                throw new RangeError('index');
            }
            
            source.splice(index, 0, element);
            
            return element;
        }
        
        public static function getElementAt(index:int, source:Array):*
        {
            if (index < 0) {
                index += source.length;
            }
            
            if (source.length <= index) {
                throw new RangeError('index');
            }
            
            return source[index];
        }
        
        public static function getElementIndex(element:*, source:Array):int
        {
            return source.indexOf(element);
        }
        
        public static function removeElement(element:*, source:Array):*
        {
            var index:int = source.indexOf(element);
            if (index < 0) {
                throw new ArgumentError('element');
            }
            
            source.splice(index, 1);
            
            return element;
        }
        
        public static function removeElementAt(index:int, source:Array):*
        {
            if (source.length <= index) {
                throw new RangeError('index');
            }
            
            return source.splice(index, 1)[0];
        }
        
        public static function setElementIndex(element:*, index:int, source:Array):void
        {
            if (source.length <= index) {
                throw new RangeError('index');
            }
            
            var oldIndex:int = source.indexOf(element);
            if (oldIndex < 0) {
                throw new ArgumentError('element');
            }
            
            source.splice(oldIndex, 1);
            source.splice(index, 0, element);
        }
        
        public static function swapElements(element1:*, element2:*, source:Array):void
        {
            var index1:int = source.indexOf(element1);
            if (index1 < 0) {
                throw new ArgumentError('element1');
            }
            
            var index2:int = source.indexOf(element2);
            if (index2 < 0) {
                throw new ArgumentError('element2');
            }
            
            source[index1] = element2;
            source[index2] = element1;
        }
        
        public static function swapElementsAt(index1:int, index2:int, source:Array):void
        {
            if (index1 < 0) {
                index1 += source.length;
            }
            if (source.length <= index1) {
                throw new RangeError('index1');
            }
            
            if (index2 < 0) {
                index2 += source.length;
            }
            if (source.length <= index2) {
                throw new RangeError('index2');
            }
            
            var temp:* = source[index1];
            source[index1] = source[index2];
            source[index2] = temp;
        }
    }
}