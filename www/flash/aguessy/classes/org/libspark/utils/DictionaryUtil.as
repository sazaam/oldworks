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
	import flash.utils.Dictionary;
	
	/**
	 * Dictionary クラスのためのユーティリティクラスです
	 */
	public class DictionaryUtil
	{
		
		/**
		 * 
		 * @param	d
		 * @param	value
		 * @return
		 * @author  michi at seyself.com
		 */
		public static function getKey(d:Dictionary, value:*):*
		{
			for (var key:Object in d)
				if (d[key] == value) return key;
			return null;
		}
		
		/**
		 * 
		 * @param	d
		 * @return
		 * @author  michi at seyself.com
		 */
		public static function getKeys(d:Dictionary):Array
		{
			var a:Array = new Array();
			for (var key:Object in d) a.push(key);
			return a;
		}
		
		/**
		 * 
		 * @param	d
		 * @return
		 * @author  michi at seyself.com
		 */
		public static function getValues(d:Dictionary):Array
		{
			var a:Array = new Array();
			for each (var value:Object in d) a.push(value);
			return a;
		}
		
		/**
		 * 
		 * @param	d
		 * @param	keys
		 * @return
		 * @author  michi at seyself.com
		 */
		public static function getValuesOfKeys(d:Dictionary, keys:Array):Array
		{
			var a:Array = new Array();
			var n:uint = keys.length;
			for (var i:uint = 0; i < n; i++) a.push(d[keys[i]]);
			return a;
		}
		
		/**
		 * 
		 * @param	d
		 * @return
		 * @author  michi at seyself.com
		 */
		public static function length(d:Dictionary):uint
		{
			var a:Array = new Array();
			for (var key:Object in d) a.push(key);
			return a.length;
		}
		
		
	}
}