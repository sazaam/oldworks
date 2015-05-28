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

public class RegExpUtil 
{
    /**
     * メールアドレスを検索する正規表現
     */
    public static const MAIL:RegExp 
	= /[a-zA-Z0-9!$&*.=^`|~#%'+\/?_{}-]+@([\w_-]+\.)+[a-zA-Z]{2,4}/;
    
	/**
	 * URL 文字列を検索する正規表現
	 */
    public static const URL:RegExp 
	= /(https?|ftp|svn)(:\/\/[\w-_.:;!?~*\'()\/\@&=+\$,%#]+)/;
    
	/**
	 * ダブルクォーテーション、もしくはシングルクォーテーションで挟まれた文字列を検索する正規表現
	 */
	public static const QUOTATION:RegExp 
	= /("|')(.+)?\1/;
    
	/**
	 * 
	 */
	public static const TAG_SHORT:RegExp 
	= /<(\w+)(\s[^>]+)?>[^\1]+?<\/\1>/s;
    
	/**
	 * 
	 */
	public static const TAG_LONG:RegExp 
	= /<(\w+)(\s[^>]+)?>(.+)<\/\1>/s;
    
	/**
	 * タグを検索する正規表現
	 */
	public static const TAG:RegExp 
	= /<\/?(\w+)([^>]+)?>/;
    
	/**
	 * #000000 から #FFFFFF の間の色指定を検索する正規表現
	 */
	public static const WEB_COLOR:RegExp 
	= /#([0-9a-fA-F]{6}|[0-9a-fA-F]{3})/;
    
	
	
	/**
	 * 複数の正規表現を結合して 1 つの新しい正規表現を作成します。
	 * フラグは削除されます。
	 * @param	...regexp
	 * @return
	 */
	public static function concat(...regexp):RegExp
	{
		var newCode:String = "";
		regexp.forEach(
			function(...$):void
			{
				if ($[0] is RegExp) newCode += $[0].source;
			}
		);
		return new RegExp(newCode, "");
	}
	
	/**
	 * 正規表現のパターン部分（source） に対して置換処理を行い、新しい正規表現を作成します。
	 * @param	regexp 
	 * @param	pattern 
	 * @param	repl 
	 * @return
	 */
	public static function replace(regexp:RegExp, pattern:*, repl:Object ):RegExp
	{
		return new RegExp(
			regexp.source.replace(pattern, repl),
			getFlags(regexp));
	}
	
	/**
	 * 正規表現を先頭に一致するようにします。
	 * @param	regexp
	 * @return
	 */
	public static function addCaret(regexp:RegExp):RegExp
	{
		return new RegExp("^" + regexp.source, getFlags(regexp));
	}
	
	/**
	 * 正規表現を末尾に一致するようにします。
	 * @param	regexp
	 * @return
	 */
	public static function addDollar(regexp:RegExp):RegExp
	{
		return new RegExp(regexp.source + "$", getFlags(regexp));
	}
	
	/**
	 * 正規表現を先頭文字から末尾文字まで含むものに一致するようにします。
	 * @param	regexp
	 * @return
	 */
	public static function addCaretAndDollar(regexp:RegExp):RegExp
	{
		return new RegExp("^" + regexp.source + "$", getFlags(regexp));
	}
	
	/**
	 * 正規表現にフラグ(g、i、m、s、x) を追加します。
	 * @param	regexp
	 * @param	flag
	 * @return
	 */
	public static function addFlags(regexp:RegExp, flag:String="gimsx"):RegExp
	{
		var _flag:String = "";
		if (regexp.dotall     || flag.match("s")) _flag += "s";
		if (regexp.extended   || flag.match("x")) _flag += "x";
		if (regexp.global     || flag.match("g")) _flag += "g";
		if (regexp.ignoreCase || flag.match("i")) _flag += "i";
		if (regexp.multiline  || flag.match("m")) _flag += "m";
		return new RegExp(regexp.source, _flag);
	}
	
	
	/**
	 * 正規表現に設定されているフラグ(g、i、m、s、x) を取得します。
	 * @param	regexp
	 * @return
	 */
	public static function getFlags(regexp:RegExp):String
	{
		var flag:String = "";
		if (regexp.dotall)     flag += "s";
		if (regexp.extended)   flag += "x";
		if (regexp.global)     flag += "g";
		if (regexp.ignoreCase) flag += "i";
		if (regexp.multiline)  flag += "m";
		return flag;
	}
	
}

}