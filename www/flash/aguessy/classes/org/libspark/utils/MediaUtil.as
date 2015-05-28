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
import flash.media.Camera;
import flash.media.Microphone;
import flash.media.SoundLoaderContext;
import flash.media.SoundMixer;
import flash.media.SoundTransform;
import flash.media.Video;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.system.Security;
import flash.system.SecurityPanel;
import flash.net.URLRequest;
import flash.utils.ByteArray;

/**
 * flash.media パッケージのためのユーティリティクラスです
 */
public class MediaUtil 
{
	
	/**
	 * マイクを取得します.
	 * 
	 * @param	index マイクのインデックス値です。
	 * @param	showSettings セキュリティパネルのマイクの設定を表示の有無。
	 * @param	loopBack マイクによってキャプチャされたオーディオをローカルスピーカーに転送するかどうかを指定します。
	 * @param	useEchoSuppression オーディオコーデックのエコー抑制機能を使用するかどうかを指定します。
	 * @return  オーディオをキャプチャする Microphone オブジェクトの参照を返します。
	 * @author  michi at seyself.com
	 */
	public static function getMicrophone(index:int=0, showSettings:Boolean = false, 
		loopBack:Boolean=true, useEchoSuppression:Boolean=false):Microphone
	{
		var mic:Microphone = Microphone.getMicrophone(index);
		if (mic) {
			if(showSettings) Security.showSettings(SecurityPanel.MICROPHONE);
			mic.setLoopBack(loopBack);
			mic.setUseEchoSuppression(useEchoSuppression);
		}
		return mic;
	}
	
	/**
	 * ビデオをキャプチャする Camera オブジェクトへの参照を返します.
	 * <br />
	 * 戻り値のオブジェクトには camera と video が含まれています。<br />
	 * camera : Camera クラスのインスタンスオブジェクト<br />
	 * video : Video クラスのインスタンスオブジェクト<br />
	 * 
	 * @param	name 取得するカメラを names プロパティで返される配列から決定します。
	 * @return  Camera オブジェクトと Video オブジェクトへの参照を保持するオブジェクト
	 * @author  michi at seyself.com
	 */
	public static function getCamera(name:String=null):Object
	{
		var camera:Camera = Camera.getCamera(name);
		var video:Video = new Video(camera.width, camera.height);
		video.attachCamera(camera);
		return { camera: camera, video: video };
	}
	
	/**
	 * 外部MP3ファイルを指定してサウンドを再生します.
	 * <br />
	 * 戻り値のオブジェクトには sound と channel が含まれています。<br />
	 * sound : Sound クラスのインスタンスオブジェクト<br />
	 * channel : SoundChannel クラスのインスタンスオブジェクト<br />
	 * 
	 * @param	url 外部の MP3 ファイルを指定する URL です。
	 * @param	loops サウンドチャネルの再生が停止するまで startTime 値に戻ってサウンドの再生を繰り返す回数を定義します。
	 * @param	sndTransform サウンドチャンネルに割り当てられた初期 SoundTransform オブジェクトです。
	 * @param	bufferTime サウンドのストリーミングを開始するまでに、バッファにストリーミングサウンドをプリロードする秒数です。
	 * @param	checkPolicyFile サウンドのロードを開始する前に、Flash Player が、ロードされるサウンドのサーバーからのクロスドメインポリシーファイルのダウンロードを試行するかどうかを指定します。
	 * @return  Sound オブジェクトと SoundChannel オブジェクトへの参照を保持するオブジェクト
	 * @author  michi at seyself.com
	 */
	public static function playSound(url:String, loops:uint = 0, sndTransform:SoundTransform = null,
		bufferTime:Number = 1000, checkPolicyFile:Boolean = false):Object
    {
        var sound:Sound = new Sound();
		var context:SoundLoaderContext = new SoundLoaderContext(bufferTime, checkPolicyFile);
		sound.load( new URLRequest(url), context );
        var channel:SoundChannel = sound.play( 0, loops, sndTransform );
		return { sound: sound, channel: channel };
    }
    
	/**
	 * 現在のサウンド波形からのスナップショットを ByteArray オブジェクトに配置した状態で取得します.
	 * 
	 * @param	FFTMode サウンドデータに対して最初にフーリエ変換を実行するかどうかを示すブール値です。
	 * @param	stretchFactor サウンドサンプリングの解像度です。
	 * @return  現在のサウンド波形からのスナップショットを配置した ByteArray オブジェクト。
	 * @author  michi at seyself.com
	 */
	public static function computeSpectrum(FFTMode:Boolean=false, stretchFactor:int=0):ByteArray
	{
		SoundMixer.computeSpectrum( soundData, FFTMode, stretchFactor);
		return soundData;
	}
	
	
	private static var soundData:ByteArray = new ByteArray();
	
}
	
}