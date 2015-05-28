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
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;


/**
 * イベント系のユーティリティクラスです
 */
public class EventUtil 
{
    
	/**
	 * EventUtil クラスのクラスメソッドを使用した場合の useCapture のデフォルト値になります.
	 * リスナーが、キャプチャ段階、またはターゲットおよびバブリング段階で動作するかどうかを判断します。
	 */
	public static var useCapture:Boolean = false;
	
	/**
	 * EventUtil クラスのクラスメソッドを使用した場合の priority のデフォルト値になります.
	 * イベントリスナーの優先度レベルです。
	 */
	public static var priority:int = 0;
	
	/**
	 * EventUtil クラスのクラスメソッドを使用した場合の useWeakReference のデフォルト値になります.
	 * リスナーへの参照が強参照と弱参照のいずれであるかを判断します。
	 */
	public static var useWeakReference:Boolean = false;
	
	
	
	/**
	 * 1度だけ登録したイベントリスナーが実行されます。実行後は登録は解除されます。
	 * 
	 * @param	target イベントリスナーオブジェクトを登録する EventDispatcher オブジェクトです。
	 * @param	type イベントのタイプです。
	 * @param	listener イベントを処理するリスナー関数です。
	 * @param	useCapture リスナーが、キャプチャ段階、またはターゲットおよびバブリング段階で動作するかどうかを判断します。
	 * @param	priority イベントリスナーの優先度レベルです。
	 * @param	useWeakReference リスナーへの参照が強参照と弱参照のいずれであるかを判断します。
	 * @author  michi at seyself.com
	 */
    public static function addOneTimeEventListener 
		(target:EventDispatcher, type:String, listener:Function, 
        useCapture:Boolean = false, priority:int = 0, 
		useWeakReference:Boolean = false):void
    {
		if (arguments.length < 4) useCapture = EventUtil.useCapture;
		if (arguments.length < 5) priority = EventUtil.priority;
		if (arguments.length < 6) useWeakReference = EventUtil.useWeakReference;
        target.addEventListener(type, 
            function( event:Event ):void {
                listener.call(target, event);
                target.removeEventListener( type, arguments.callee );
            }
            , useCapture, priority, useWeakReference);
    }
    
	/**
	 * 指定時間の経過後にイベントリスナーが実行されます。
	 * 登録したイベントリスナーはイベントの通知を受けるたびに遅延実行します。
	 * 
	 * @param	target イベントリスナーオブジェクトを登録する EventDispatcher オブジェクトです。
	 * @param	type イベントのタイプです。
	 * @param	listener イベントを処理するリスナー関数です。
	 * @param	delay 待機時間（ミリ秒単位）
	 * @param	useCapture リスナーが、キャプチャ段階、またはターゲットおよびバブリング段階で動作するかどうかを判断します。
	 * @param	priority イベントリスナーの優先度レベルです。
	 * @param	useWeakReference リスナーへの参照が強参照と弱参照のいずれであるかを判断します。
	 * @author  michi at seyself.com
	 */
    public static function addDelayEventListener 
		(target:EventDispatcher, type:String, listener:Function, delay:uint=0, 
        useCapture:Boolean = false, priority:int = 0, 
		useWeakReference:Boolean = false):void
    {
        if (arguments.length < 5) useCapture = EventUtil.useCapture;
		if (arguments.length < 6) priority = EventUtil.priority;
		if (arguments.length < 7) useWeakReference = EventUtil.useWeakReference;
        var timer:Timer = new Timer(delay, 1);
        target.addEventListener(type, 
            function( event:Event ):void {
                timer.addEventListener( "timer", 
                    function(e:TimerEvent):void {
                        listener.call(target, event);
                        timer.removeEventListener( "timer", arguments.callee );
						timer.reset();
                    }
                );
                timer.start();
            }, 
            useCapture, priority, useWeakReference);
    }
    
    /**
     * タイムラインが次のフレームに移った時にイベントリスナーが実行されます。
	 * 
	 * @param	target イベントリスナーオブジェクトを登録する EventDispatcher オブジェクトです。
	 * @param	type イベントのタイプです。
	 * @param	listener イベントを処理するリスナー関数です。
	 * @param	useCapture リスナーが、キャプチャ段階、またはターゲットおよびバブリング段階で動作するかどうかを判断します。
	 * @param	priority イベントリスナーの優先度レベルです。
	 * @param	useWeakReference リスナーへの参照が強参照と弱参照のいずれであるかを判断します。
	 * @author  michi at seyself.com
     */
    public static function addNextFrameEventListener 
		(target:EventDispatcher, type:String, listener:Function, 
        useCapture:Boolean = false, priority:int = 0, 
		useWeakReference:Boolean = false):void
    {
        if (arguments.length < 4) useCapture = EventUtil.useCapture;
		if (arguments.length < 5) priority = EventUtil.priority;
		if (arguments.length < 6) useWeakReference = EventUtil.useWeakReference;
        var dummy:Shape = new Shape();
        target.addEventListener(type, 
            function( event:Event ):void {
                dummy.addEventListener( "enterFrame", 
                    function(e:Event):void {
                        listener.call(target, event);
                        dummy.removeEventListener( "enterFrame", arguments.callee );
                    }
                );
            }, 
            useCapture, priority, useWeakReference);
    }
    
	/**
	 * 任意の引数を設定したイベントリスナーを登録します。
	 * 
	 * @param	target イベントリスナーオブジェクトを登録する EventDispatcher オブジェクトです。
	 * @param	type イベントのタイプです。
	 * @param	listener イベントを処理するリスナー関数です。
	 * @param	args 引数を指定した配列
	 * @param	useCapture リスナーが、キャプチャ段階、またはターゲットおよびバブリング段階で動作するかどうかを判断します。
	 * @param	priority イベントリスナーの優先度レベルです。
	 * @param	useWeakReference リスナーへの参照が強参照と弱参照のいずれであるかを判断します。
	 * @author  michi at seyself.com
	 */
    public static function addCustomArgumentsEventListener 
		(target:EventDispatcher, type:String, listener:Function, args:Array=null,
        useCapture:Boolean = false, priority:int = 0, 
		useWeakReference:Boolean = false):void
    {
        if (arguments.length < 5) useCapture = EventUtil.useCapture;
		if (arguments.length < 6) priority = EventUtil.priority;
		if (arguments.length < 7) useWeakReference = EventUtil.useWeakReference;
        target.addEventListener(type, 
            function( event:Event ):void {
                listener.apply(target, args);
            }
            , useCapture, priority, useWeakReference);
    }
    
	/**
	 * DisplayObject オブジェクトがステージ上に配置されている時だけイベントリスナーが登録されます.
	 * 指定の DisplayObject オブジェクトがステージ上から削除されると、イベントリスナーは解除されますが、再度ステージ上に配置されたときは再設定されます。
	 * 
	 * @param	eventTarget イベントリスナーオブジェクトを登録する EventDispatcher オブジェクトです。
	 * @param	type イベントのタイプです。
	 * @param	listener イベントを処理するリスナー関数です。
	 * @param	displayTarget イベントの登録・解除のタイミングを決定する DisplayObject インスタンス。
	 * @param	useCapture リスナーが、キャプチャ段階、またはターゲットおよびバブリング段階で動作するかどうかを判断します。
	 * @param	priority イベントリスナーの優先度レベルです。
	 * @param	useWeakReference リスナーへの参照が強参照と弱参照のいずれであるかを判断します。
	 * @author  michi at seyself.com
	 */
	public static function addOnStageEventListener
		(eventTarget:EventDispatcher, type:String, listener:Function, 
		displayTarget:DisplayObject, useCapture:Boolean = false, priority:int = 0, 
		useWeakReference:Boolean = false ):void
	{
		if (arguments.length < 5) useCapture = EventUtil.useCapture;
		if (arguments.length < 6) priority = EventUtil.priority;
		if (arguments.length < 7) useWeakReference = EventUtil.useWeakReference;
        if (displayTarget.stage && arguments.length<8 ) {
			eventTarget.addEventListener(
				type, listener, useCapture, priority, useWeakReference);
		} else {
			displayTarget.addEventListener("addedToStage", 
				function(event:Event):void
				{
					displayTarget.removeEventListener("addedToStage", arguments.callee);
					eventTarget.addEventListener(
						type, listener, useCapture, priority, useWeakReference);
					displayTarget.addEventListener("removedFromStage", 
						function(event:Event):void
						{
							eventTarget.removeEventListener(type, listener, useCapture);
							addOnStageEventListener.apply( eventTarget, 
								[eventTarget, type, listener, displayTarget, 
								useCapture, priority, useWeakReference, true] );
						}
					);
				}
			);
			
		}
			
	}
	
}

}