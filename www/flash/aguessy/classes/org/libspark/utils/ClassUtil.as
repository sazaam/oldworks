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
import flash.utils.getDefinitionByName;

/**
 * Class のためのユーティリティクラスです
 */
public class ClassUtil 
{
    
	/**
	 * 指定したオブジェクトを型指定無しで返します。
	 * 
	 * @param	instance キャスト対象オブジェクト
	 * @return 指定したオブジェクトが型指定無しで返されます。
	 * @author  michi at seyself.com
	 */
    public static function cast(instance:Object):*
	{
		return instance;
	}
	
	/**
	 * インスタンスオブジェクトからクラス名を表す文字列を返します。
	 * 
	 * @param	instance クラス名を取得するオブジェクト
	 * @return クラス名を表す文字列
	 * @author  michi at seyself.com
	 */
    public static function getClassName(instance:Object):String
	{
		var classObject:Class = instance.constructor;
		return String(classObject).replace(/\[class ([^\]]+)\]/, 
			function():String { return arguments[1]; } );
	}
	
	/**
	 * クラスのコンストラクタ内で呼び出すことで、そのクラスを抽象クラスのように振舞わせます.
	 * このメソッドは、必ずクラスのコンストラクタ内で使用してください。
	 * このメソッドを使用すると、そのクラスは直接インスタンスを作成できなくなります。
	 * インスタンスを作成するためには、このクラスを継承したサブクラスを作る必要があります。
	 * 
	 * @param	instance 必ず this を指定します
	 * @param	klass 現在のクラスを指定します。
	 * @example 以下のコードでは AbstractTest クラスと、これを継承した AbstractSubClass を作成します。
	 * AbstractTest クラスからインスタンスを作成しようとすると ArgumentError が throw されますが、
	 * AbstractTest クラスを継承した AbstractSubClass は、正常にインスタンスを生成することができます。
	 * <listing>
	 * import org.libspark.utils.ClassUtil;
	 * public class AbstractTest 
	 * {
	 *     public function AbstractTest() 
	 *     {
	 *         ClassUtil.abstraction(this, AbstractTest);
	 *     }
	 *     
	 *     public function testCall():void
	 *     {
	 *         trace("create instance ok!");
	 *     }
	 * }
	 * 
	 * public class AbstractSubClass extends AbstractTest
	 * {
	 *     public function AbstractSubClass() 
	 *     {
	 *         testCall();
	 *     }
	 * }
	 * </listing>
	 */
	public static function abstraction(instance:Object, klass:Class):void
	{
		if (instance.constructor == klass) throw new ArgumentError
			("Error #2012: "+getClassName(instance)+"$ クラスをインスタンス化することはできません。");
	}
	
	/**
	 * クラスのコンストラクタ内で呼び出すことで、そのクラスのインスタンス数を制限します。
	 * このメソッドは、必ずクラスのコンストラクタ内で使用してください。
	 * このメソッドを使用すると、コンストラクタは 1 度だけ呼び出すことができるようになります。
	 * 
	 * @param	instance 必ず this を指定します
	 * @example 以下のコードでは SingletonTest のコンストラクタは 1 度しか呼び出せなくなります。
	 * 通常 getInstance() メソッド等を作成して併用しますが、サンプルでは省略しています。
	 * <listing>
	 * import org.libspark.utils.ClassUtil;
	 * public class SingletonTest 
	 * {
	 *     public function SingletonTest() 
	 *     {
	 *         ClassUtil.singleton(this);
	 *     }
	 * }
	 * </listing>
	 */
	public static function singleton(instance:Object):void
	{
		if ( _SingletonContainer[instance.constructor] ) throw new ArgumentError
			("Error #2012: "+getClassName(instance)+" クラスをインスタンス化することはできません。");
		else _SingletonContainer[instance.constructor] = true;
	}
	
	/**
	 * クラスのコンストラクタ内で呼び出すことで、そのクラスのインスタンス数を制限します。
	 * このメソッドは、必ずクラスのコンストラクタ内で使用してください。
	 * このメソッドを使用すると、コンストラクタは指定回数まで呼び出すことができるようになります。
	 * 
	 * @param	instance 必ず this を指定します
	 * @param	maxCount コンストラクタの呼び出し可能数
	 * @example 以下のコードでは MultiSingletonTest のコンストラクタは 3 度だけ呼び出すことができます。
	 * 通常 getInstance() メソッド等を作成して併用しますが、サンプルでは省略しています。
	 * <listing>
	 * import org.libspark.utils.ClassUtil;
	 * public class MultiSingletonTest 
	 * {
	 *     public function MultiSingletonTest() 
	 *     {
	 *         ClassUtil.multiSingleton(this, 3);
	 *     }
	 * }
	 * </listing>
	 */
	public static function multiSingleton(instance:Object, maxCount:uint=1):void
	{
		var cnst:Object = instance.constructor;
		if ( _SingletonContainer[cnst] )
			if (_SingletonContainer[cnst].length < maxCount)
				_SingletonContainer[cnst].push([instance]);
			else throw new ArgumentError
				("Error #2012: "+getClassName(instance)+" クラスをインスタンス化することはできません。");
		else _SingletonContainer[cnst] = [instance];
	}
	
	
	
	//----------------------------------------------------
	// PRIVATE PROPERTIES
	//----------------------------------------------------
	
	private static var _SingletonContainer:Dictionary = new Dictionary(true);
	private static var _MultiSingletonContainer:Dictionary = new Dictionary(false);
	
	
}

}