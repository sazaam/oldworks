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
    import org.libspark.as3unit.runners.Suite;
    import org.libspark.aocontainer.impls.AllTests;
    import org.libspark.aocontainer.providers.AllTests;
    import org.libspark.aocontainer.creators.AllTests;
    import org.libspark.aocontainer.injectors.AllTests;
    import org.libspark.aocontainer.deployers.AllTests;
    import org.libspark.aocontainer.values.AllTests;
    import org.libspark.aocontainer.creations.AllTests;
    import org.libspark.aocontainer.injections.AllTests;
    import org.libspark.aocontainer.deployments.AllTests;
    import org.libspark.aocontainer.builders.AllTests;
    import org.libspark.aocontainer.examples.AllTests;
    
    /**
     * org.libspark.aocontainer パッケージ以下の
     * 全てのテストを実行するためのテストスイートです。
     * 
     * @author yossy
     */
    public final class AllTests
    {
        public static const RunWith:Class = Suite;
        public static const SuiteClasses:Array = [
            org.libspark.aocontainer.impls.AllTests,
            org.libspark.aocontainer.providers.AllTests,
            org.libspark.aocontainer.creators.AllTests,
            org.libspark.aocontainer.injectors.AllTests,
            org.libspark.aocontainer.deployers.AllTests,
            org.libspark.aocontainer.values.AllTests,
            org.libspark.aocontainer.creations.AllTests,
            org.libspark.aocontainer.injections.AllTests,
            org.libspark.aocontainer.deployments.AllTests,
            org.libspark.aocontainer.builders.AllTests,
            org.libspark.aocontainer.examples.AllTests
        ];
    }
}