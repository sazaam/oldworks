/*
 * Licensed under the MIT License
 * 
 * Copyright (c) 2008 tera
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

package org.libspark.utils
{
	
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	/**
	 * 一行分がバッファに貯まったら送信されます。
	 */
	[Event(name="progress", type="ProgressEvent.PROGRESS")]
	
	
	/**
	 * LineReader クラスは、 IDataInput インターフェースを実装するクラスに対して、一行ごとにデータを読み込む機能を提供します。<br />
	 * 一行読み込むたびにProgressEvent.PROGRESSを発生させます。
	 * 
	 */
	public class LineReader extends EventDispatcher {
		
		/**
		 * 新しい LineReader クラスのインスタンスを生成します。
		 * 
		 * 引数で渡される dataInput オブジェクトは、 IEventDispatcher を実装し、<br />
		 * flash.events.ProgressEvent.SOCKET_DATA または flash.events.ProgressEvent.PROGRESS イベントを発生させるクラス<br />
		 * ( flash.net.Socket , flash.net.URLStream , flash.filesystem.FileStream )である必要があります。<br />
		 * ロード完了時なでではProgressEvent.PROGRESSを発生させないので、<br />
		 * 最後の一行を得るには読み込みが完了した段階でLineReaderオブジェクトのbufferプロパティを直接取得する必要があります。
		 * 
		 * @param dataInput 処理対象となる IDataInput インターフェースの実装クラス
		 */
		public function LineReader(dataInput:IDataInput)
		{
			var dataInputDispatcher:IEventDispatcher = dataInput as IEventDispatcher;
			
			if (!dataInputDispatcher) {
				throw new IllegalOperationError("dataInput must implements IEventDispatcher");
			}
			dataInputDispatcher.addEventListener((dataInput is Socket) ? ProgressEvent.SOCKET_DATA : ProgressEvent.PROGRESS, progressHandler, false, 0, true);
		}
		
		// 改行コード：キャリッジリターン
		private static const CARRIAGE_RETURN:int = 0x0D;
		
		// 改行コード：ラインフィード
		private static const LINE_FEED:int = 0x0A;
		
		// 次バイトで検出したLFをスキップするか
		private var _skipNextLineFeed:Boolean = false;
		
		// 読み取りバッファ
		private var _buffer:ByteArray = new ByteArray();
		
		// 改行コードをバッファに保存するか
		private var _trimLineFeed:Boolean = true;
		
		// 空行をスキップするか
		private var _skipBlankLine:Boolean = false;
		
		/**
		 * 現在のバッファ内容を返します。
		 * 
		 * @return	現在読み込んでいるバッファ内容
		 */
		public function get buffer():ByteArray {
			return _buffer;
		}
		
		/**
		 * 改行コードをバッファに保存するかを設定します。
		 * 
		 * @param flag 現在の設定
		 */
		public function set trimLineFeed(flag:Boolean):void {
			_trimLineFeed = flag;
		}
		
		/**
		 * 改行コードをバッファに保存するかを返します。
		 * 
		 * @return 現在の設定
		 */
		public function get trimLineFeed():Boolean {
			return _trimLineFeed;
		}
		
		/**
		 * 空行をスキップするかを設定します。
		 * 
		 * @param flag 現在の設定
		 */
		public function set skipBlankLine(flag:Boolean):void {
			_skipBlankLine = flag;
		}
		
		/**
		 * 空行をスキップするかを返します。
		 * 
		 * @return 現在の設定
		 */
		public function get skipBlankLine():Boolean {
			return _skipBlankLine;
		}
		
		/**
		 * ProgressEvent.PROGRESS または ProgressEvent.SOCKET_DATA イベントを受け取り、一行ごとにバッファに格納します。
		 * 
		 * @param e ProgressEvent.PROGRESS または ProgressEvent.SOCKET_DATA イベント
		 * @eventType ProgressEvent.PROGRESS
		 * @private
		 */
		private function progressHandler(e:ProgressEvent):void
		{
			// バッファにリード
			var dataInput:IDataInput = e.target as IDataInput;
			var byte:int;
			while (dataInput.bytesAvailable) {
				// 1バイトずつ読み込む
				byte = dataInput.readByte();
				
				if (_skipNextLineFeed) {
					_skipNextLineFeed = false;
					if (byte == LINE_FEED) {
						if (!_trimLineFeed) {
							_buffer.writeByte(byte);
							if (!_skipBlankLine || _buffer.length > 2) {
								dispatchEvent(new ProgressEvent( ProgressEvent.PROGRESS, false, false, e.bytesLoaded-dataInput.bytesAvailable, e.bytesTotal));
							}
						} else {
							if (!_skipBlankLine || _buffer.length > 1) {
								dispatchEvent(new ProgressEvent( ProgressEvent.PROGRESS, false, false, e.bytesLoaded-dataInput.bytesAvailable, e.bytesTotal));
							}
						}
						_buffer = new ByteArray();
						continue;
					} else {
						if (!_skipBlankLine || _buffer.length > 1) {
							dispatchEvent(new ProgressEvent( ProgressEvent.PROGRESS, false, false, e.bytesLoaded-dataInput.bytesAvailable-1, e.bytesTotal));
						}
						_buffer = new ByteArray();
					}
				} else if (byte == LINE_FEED) {
					if (!_trimLineFeed) {
						_buffer.writeByte(byte);
					}
					if (!_skipBlankLine || _buffer.length > 1) {
						dispatchEvent(new ProgressEvent( ProgressEvent.PROGRESS, false, false, e.bytesLoaded-dataInput.bytesAvailable, e.bytesTotal));
					}
					_buffer = new ByteArray();
					continue;
				} else if (byte == CARRIAGE_RETURN) {
					if (!_trimLineFeed) {
						_buffer.writeByte(byte);
					}
					_skipNextLineFeed = true;
					continue;
				}
				_buffer.writeByte(byte);
				
			}
		}
	}
}