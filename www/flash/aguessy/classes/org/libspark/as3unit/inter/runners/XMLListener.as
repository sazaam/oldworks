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

package org.libspark.as3unit.inter.runners
{
    import org.libspark.as3unit.runner.notification.RunListener;
    import org.libspark.as3unit.runner.Description;
    import org.libspark.as3unit.runner.Result;
    import org.libspark.as3unit.runner.notification.Failure;
    import flash.utils.Dictionary;

    public class XMLListener extends RunListener
    {
        private var descriptionMap:Dictionary;
        private var resultXML:XML = <tests/>;
        
        public function get result():XML
        {
            return resultXML;
        }
        
        public override function testRunStarted(description:Description):void
        {
            descriptionMap = new Dictionary();
            resultXML = <tests/>
            
            if (description.isSuite) {
                for each (var child:Description in description.children) {
                    buildResultXML(child, resultXML);
                }
            }
            else {
                buildResultXML(description, resultXML);
            }
        }
        
        private function buildResultXML(description:Description, xml:XML):void
        {
            if (description.isSuite) {
                var suiteXML:XML = <suite name={description.displayName}/>;
                for each (var child:Description in description.children) {
                    buildResultXML(child, suiteXML);
                }
                xml.appendChild(suiteXML);
            }
            else {
                var displayName:String = description.displayName;
                var endIndex:uint = displayName.indexOf("(");
                var testName:String = displayName.substring(0, endIndex >= 0 ? endIndex : displayName.length);
                var testXML:XML = <test name={testName} qualifiedName={displayName} status="n"/>
                descriptionMap[description.displayName] = testXML;
                xml.appendChild(testXML);
            }
        }
        
        public override function testRunFinished(result:Result):void
        {
            descriptionMap = null;
        }
        
        public override function testStarted(description:Description):void
        {
        }
        
        public override function testFinished(description:Description):void
        {
            var testXML:XML = descriptionMap[description.displayName];
            if (testXML.@status == "n") {
                testXML.@status = "o";
            }
        }
        
        public override function testFailure(failure:Failure):void
        {
            var testXML:XML = descriptionMap[failure.description.displayName];
            testXML.@status = "f";
            testXML.@trace = failure.trace;
        }
        
        public override function testIgnored(description:Description):void
        {
            descriptionMap[description.displayName].@status = "i";
        }
    }
}