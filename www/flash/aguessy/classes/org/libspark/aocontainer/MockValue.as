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

package org.libspark.aocontainer
{
    /**
     * @private
     * @author yossy
     */
    public class MockValue implements Value
    {
        public var provider:Provider = new MockProvider();
        public var def:Definition;
        public var type:Class;
        
        public function getProvider(def:Definition, type:Class):Provider
        {
            this.def = def;
            this.type = type;
            return provider;
        }
    }
}

import org.libspark.aocontainer.Provider;

class MockProvider implements Provider
{
    public function provide():Object
    {
        return null;
    }
}