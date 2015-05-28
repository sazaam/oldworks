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

package org.libspark.aocontainer.errors
{
    /**
     * 定義が重複している場合に発生するエラーを表します。
     *
     * @author yossy
     */
    public class DuplicateError extends AOContainerError
    {
        public function DuplicateError(message:String = "", id:int = 0)
        {
            super(message, id);
        }
    }
}