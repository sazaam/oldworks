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

package org.libspark.aocontainer.examples.greeting
{
    import org.libspark.as3unit.test;
    import org.libspark.as3unit.assert.assertEquals;
    import org.libspark.aocontainer.AOContainer;
    import org.libspark.aocontainer.AOContainerFactory;
    
    use namespace test;
    
    /**
     * Seasarのクイックスタート「最初の一歩」にある例に沿ったテストです。
     * @see http://s2container.seasar.org/ja/DIContainer.html#FirstStep
     * @author yossy
     */
    public final class GreetingTest
    {
        test function greetingDI():void
        {
            // 使用するクラスを明示的に読み込んでおかないとswfファイルにリンクされない場合があるので注意
            GreetingImpl; GreetingClientImpl;
            
            // オブジェクト定義（Seasarで言うdiconファイル）
            var config:XML = 
                <objects>
                    <object name='greeting' class='org.libspark.aocontainer.examples.greeting.GreetingImpl'/>
                    <object name='greetingClient' class='org.libspark.aocontainer.examples.greeting.GreetingClientImpl'>
                        <property name='greeting'>greeting</property>
                    </object>
                </objects>;
            /*
             *  <object name='greeting' class='org.libspark.aocontainer.examples.greeting.GreetingImpl'/>
             * は次のコードに相当
             *  var greeting:Greeting = new GreetingImpl();
             */
            /*
             *  <object name='greetingClient' class='org.libspark.aocontainer.examples.greeting.GreetingClientImpl'>
             *      <property name='greeting'>greeting</property>
             *  </object>
             * は次のコードに相当
             *  var greetingClient:GreetingClient = new GreetingClientImpl();
             *  greetingClient.greeting = greeting;
             */
            
            // コンテナの生成
            var container:AOContainer = AOContainerFactory.create(config);
            
            // ログ初期化
            Static.log = '';
            
            // greetingClientオブジェクトの取得
            var greetingClient:GreetingClient = GreetingClient(container.getObject('greetingClient'));
            // greetingClinetオブジェクトの実行
            greetingClient.execute();
            
            // うまくいけばログに追記されているはず
            assertEquals('Hello World!', Static.log);
        }
    }
}