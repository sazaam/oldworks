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
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.net.FileReference;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.net.navigateToURL;
import flash.net.sendToURL;

/**
 * URLRequest 関連のユーティリティクラスです
 */
public class RequestUtil 
{
    
    public static var navigateEnabled:Boolean = true;
    
    
    /**
     * Flash Player のコンテナを含むアプリケーション (通常はブラウザ) でウィンドウを開くか、置き換えます。
	 * 
     * @param	url 移動先の URL
     * @param	target 指定されたドキュメントを表示するブラウザウィンドウまたは HTML フレームです。
	 * @author  michi at seyself.com
     */
    public static function link( url:String, target:String=null ):void
    {
        if ( navigateEnabled ) {
            if ( !target || target=="_self" ) {
                navigateToURL( new URLRequest(url) );
            } else {
                navigateToURL( new URLRequest(url), target );
            }
        } else {
            trace("[Link.ref url=\""+url+"\" target=\""+target+"\"]");
        }
    }
    
    /**
     * 渡されたオブジェクトの値から、 Flash Player のコンテナを含むアプリケーション (通常はブラウザ) でウィンドウを開くか、置き換えます。
	 * 
     * @param	param リンク情報を持つオブジェクト
	 * @author  michi at seyself.com
     */
    public static function linkObject( param:Object ):void
    {
        var url:String, target:String;
        if ( param.hasOwnProperty("url") )    url = param.url;
        if ( param.hasOwnProperty("href") )   url = param.href;
        if ( param.hasOwnProperty("window") ) target = param.window;
        if ( param.hasOwnProperty("target") ) target = param.target;
        link( url, target );
    }
    
    /**
     * 渡された XML の値から、 Flash Player のコンテナを含むアプリケーション (通常はブラウザ) でウィンドウを開くか、置き換えます。
	 * 
     * @param	xml リンク情報を持つ XML エレメント
	 * @author  michi at seyself.com
     */
    public static function linkXML( xml:XML ):void
    {
        var url:String, target:String;
        if ( xml.attribute("url") )    url = xml.url;
        if ( xml.attribute("href") )   url = xml.href;
        if ( xml.attribute("window") ) target = xml.window;
        if ( xml.attribute("target") ) target = xml.target;
        link( url, target );
    }
    
    /**
     * URL リクエストをサーバーに送信し、データを受信する URLLoader オブジェクトを取得します。
	 * 
     * @param	url データの送受信を行う URL
     * @param	params 送信するデータ
     * @param	method HTTP フォーム送信メソッドが GET または POST のどちらの操作であるかを制御します。
     * @param	dataFormat ダウンロードしたデータが text, binary, variables のいずれであるかを制御します。
     * @return  送信に使われた URLLoader オブジェクト
	 * @author  michi at seyself.com
     */
    public static function request(url:String, params:Object = null,
        method:String="POST", dataFormat:String="text"):URLLoader
    {
        var request:URLRequest = new URLRequest( url );
        var vars:URLVariables = new URLVariables();
        if( params ){
            for (var val:String in params) vars[val] = params[val];
        }
        request.data = vars;
        request.method = method;
        var loader:URLLoader = new URLLoader();
        loader.dataFormat = dataFormat;
        loader.load( request );
        return loader;
    }
    
    /**
     * 指定された URL からデータをロードします。
	 * 
     * @param	url データを受け取る URL
     * @param	dataFormat ダウンロードしたデータが text, binary, variables のいずれであるかを制御します。
     * @return  送信に使われた URLLoader オブジェクト
	 * @author  michi at seyself.com
     */
    public static function load(url:String, dataFormat:String="text"):URLLoader
    {
        var request:URLRequest = new URLRequest( url );
        var loader:URLLoader = new URLLoader();
        loader.dataFormat = dataFormat;
        loader.load( request );
        return loader;
    }
    
    /**
     * URL リクエストをサーバーに送信しますが、応答は無視します。
	 * 
     * @param	url データの送信先の URL
     * @param	params 送信するデータ
     * @param	method HTTP フォーム送信メソッドが GET または POST のどちらの操作であるかを制御します。
	 * @author  michi at seyself.com
     */
    public static function send(url:String, params:Object=null, method:String="POST"):void
    {
        var request:URLRequest = new URLRequest( url );
        var vars:URLVariables = new URLVariables();
        if( params ){
            for (var val:String in params) vars[val] = params[val];
        }
        request.method = method;
        request.data = vars;
        sendToURL( request );
    }
    
    
}

}