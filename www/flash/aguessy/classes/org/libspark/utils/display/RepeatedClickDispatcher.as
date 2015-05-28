/*
 * Licensed under the MIT License
 * 
 * Copyright (c) 2008 BeInteractive!, Spark project
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
 * 
 */

package org.libspark.utils.display
{
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * ターゲットの InteractiveObject が押されたときに MouseEvent.CLICK を配信します。
	 * 更に、指定された delay フレーム以上押し続けた場合に、interval の間隔で MouseEvent.CLICK をリピートします。
	 * 
	 * Dispatch and repeat MouseEvent.CLICK event if target InteractiveObject was pressed.
	 * 
	 * Usage:
	 * 
	 * 1. Initialize this class with stage.
	 * 
	 *  RepeatedClickDispatcher.initialize(stage);
	 * 
	 * 2. Create a instance of this class with target InteractiveObject, repeat delay and repeat interval.
	 * 
	 *  var rcd:RepeatedClickDispatcher = new RepeatedClickDispatcher(target, 12, 1);
	 * 
	 * 3. Hook the MouseEvent.CLICK event listener.
	 * 
	 *  rcd.addEventListener(MouseEvent.CLICK, clickHandler);
	 * 
	 * 4. If you need finalize the instance, call removeEventListener and finalize method (for each instance).
	 * 
	 *  rcd.removeEventListener(MouseEvent.CLICK, clickHandler);
	 *  rcd.finalize();
	 * 
	 * @see http://www.libspark.org/wiki/Utils/RepeatedClickDispatcher
	 */
	public class RepeatedClickDispatcher extends EventDispatcher
	{
		private static var _stage:Stage;
		
		/**
		 * 初期化
		 * 
		 * Initialize
		 * 
		 * @param	stage ステージ
		 */
		public static function initialize(stage:Stage):void
		{
			_stage = stage;
		}
		
		/**
		 * @param	target ターゲット
		 * @param	delay リピート開始までのフレーム数
		 * @param	interval 何フレームごとにリピートするか
		 */
		public function RepeatedClickDispatcher(target:InteractiveObject, delay:uint = 0, interval:uint = 0)
		{
			_target = target;
			_delay = delay;
			_interval = interval == 0 ? 1 : interval;
			
			_target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		private var _target:InteractiveObject;
		private var _counter:uint;
		private var _delay:uint;
		private var _interval:uint;
		
		private function mouseDownHandler(e:MouseEvent):void
		{
			dispatchClickEvent();
			
			_counter = 0;
			
			registerStageListener();
		}
		
		private function mouseUpHandler(e:MouseEvent):void
		{
			unregisterStageListener();
		}
		
		private function registerStageListener():void
		{
			_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function unregisterStageListener():void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void
		{
			if (++_counter > _delay) {
				if ((_counter - _delay) % _interval == 0) {
					dispatchClickEvent();
				}
			}
		}
		
		private function dispatchClickEvent():void
		{
			dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		/**
		 * 破棄
		 */
		public function finalize():void
		{
			_target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			unregisterStageListener();
		}
	}
}