/**
 * net.unbland package
 * 
 * Copyright 2008 (c) muta
 * 
 * http://unbland.net/
 * http://unbland.net/blog/
 * 
 * Licensed under the MIT License
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package net.unbland.loaders
{
    public class FileFormat
    {
        /**
         * swf のファイル形式を定義します。
         */
        public static const SWF:String       = "swf";
        
        /**
         * png のファイル形式を定義します。
         */
        public static const PNG:String       = "png";
        
        /**
         * jpg のファイル形式を定義します。
         */
        public static const JPG:String       = "jpg";
        
        /**
         * jpeg のファイル形式を定義します。
         */
        public static const JPEG:String      = "jpeg";
        
        /**
         * gif のファイル形式を定義します。
         */
        public static const GIF:String       = "gif";
        
        /**
         * xml のファイル形式を定義します。
         */
        public static const XML:String       = "xml";
        
        /**
         * テキストデータのファイル形式を定義します。
         */
        public static const TEXT:String      = "text";
        
        /**
         * バイナリデータのファイル形式を定義します。
         */
        public static const BINARY:String    = "binary";
        
        /**
         * 変数（URLVariables）のファイル形式を定義します。
         */
        public static const VARIABLES:String = "variables";
        
        /**
         * @private
         */
        public function FileFormat():void
        {
            throw new ArgumentError("FileFormat は静的クラスのため、直接インスタンス化できません。");
        }
    }
}