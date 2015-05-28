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


package org.libspark.utils 
{

/**
 * Boolean のためのユーティリティクラスです
 */
public class BooleanUtil 
{
    /**
     * true 判定が n 個以上であるかを判定します
     * @param	n 比較対象となる数
     * @param	...params
     * @return
     */
    public static function more(n:uint, ...params):Boolean
    {
        var len:uint = params.length;
        var count:uint = 0;
        for (var i:uint = 0; i < len;i++ ) {
            if (params[i]) {
                count++;
                if (count == n) return true;
            }
        }
        return false;
    }
    
    /**
     * true 判定が n 個かどうかを判定します
     * @param	n 比較対象となる数
     * @param	...params
     * @return
     */
    public static function equal(n:uint, ...params):Boolean
    {
        var len:uint = params.length;
        var count:uint = 0;
        for (var i:uint = 0; i < len;i++ ) {
            if (params[i]) count++;
        }
        if (count == n) return true;
        return false;
    }
    
    /**
     * true 判定が n 個未満であるかを判定します
     * @param	n 比較対象となる数
     * @param	...params
     * @return
     */
    public static function fewer(n:uint, ...params):Boolean
    {
        var len:uint = params.length;
        var count:uint = 0;
        for (var i:uint = 0; i < len;i++ ) {
            if (params[i]) {
                count++;
                if (count == n) return false;
            }
        }
        if (count < n) return true;
        return false;
    }
    
}

}