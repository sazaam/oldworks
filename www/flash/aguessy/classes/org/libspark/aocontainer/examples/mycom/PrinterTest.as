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

package org.libspark.aocontainer.examples.mycom
{
    import org.libspark.as3unit.test;
    import org.libspark.as3unit.assert.assertEquals;
    import org.libspark.aocontainer.AOContainer;
    import org.libspark.aocontainer.AOContainerFactory;
    
    use namespace test;
    
    /**
     * MYCOMジャーナル"【ハウツー】Seasar 2.4リリース! 今更でも恥ずかしくない、始めてみようDIプログラミング"に沿ったテストです。
     * @see http://journal.mycom.co.jp/articles/2006/11/16/seasar/
     * @author yossy
     */
    public final class PrinterTest
    {
        test function printerDI():void
        {
            // 使用するクラスを明示的に読み込んでおかないとswfファイルにリンクされない場合があるので注意
            MessageImpl; PrinterImpl;
            
            // オブジェクト定義（Seasarで言うdiconファイル）
            // 自動プロパティインジェクションします。
            var config:XML = 
                <objects>
                    <object name='message' class='org.libspark.aocontainer.examples.mycom.MessageImpl'/>
                    <object name='printer' class='org.libspark.aocontainer.examples.mycom.PrinterImpl'/>
                </objects>;
            
            // コンテナの生成
            var container:AOContainer = AOContainerFactory.create(config);
            
            // ログ初期化
            Static.log = '';
            
            // printerオブジェクトの取得
            var printer:Printer = Printer(container.getObject('printer'));
            // print実行
            printer.print();
            
            // うまくいけばログに追記されているはず
            assertEquals('新大陸へようこそ', Static.log);
        }
    }
}