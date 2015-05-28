/*
 * Copyright(c) 2006 the Spark project.
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
	import flash.utils.describeType;
	import flash.net.NetConnection;
	import flash.errors.IllegalOperationError;
	
	public class Method
	{
		private var name_:String;
		private var declaringClass_:Class;
		private var returnType_:String;
		private var parameters_:Array;
		private var namespace_:Namespace;
		private var isStatic_:Boolean;
		
		public static function getDeclaredMethods(klass:Class):Array
		{
			var results:Array = new Array();
			var classDescription:XML = describeType(klass);
			for each (var methodXML:XML in classDescription.method) {
				results.push(createMethod(klass, methodXML, true));
			}
			for each (var factoryMethodXML:XML in classDescription.factory.method) {
				results.push(createMethod(klass, factoryMethodXML, false));
			}
			return results;
		}
		
		private static function createMethod(klass:Class, methodXML:XML, isStatic:Boolean):Method
		{
			var method:Method = new Method();
			
			method.declaringClass_ = klass;
			method.name_ = String(methodXML.@name);
			method.returnType_ = methodXML.@returnType;
			method.isStatic_ = isStatic;
			
			if (methodXML.@uri != null) {
				method.namespace_ = new Namespace(methodXML.@uri);
			}
			else {
				method.namespace_ = null;
			}
			
			method.parameters_ = new Array();
			for each (var parameterXML:XML in methodXML.parameter) {
				method.parameters_.push(parameterXML.@type);
			}
			
			return method;
		}
		
		public function get declaringClass():Class
		{
			return declaringClass_;
		}
		
		public function get namespace():Namespace
		{
			return namespace_;
		}
		
		public function get name():String
		{
			return name_;
		}
		
		public function get parameters():Array
		{
			return parameters_;
		}
		
		public function get returnType():String
		{
			return returnType_;
		}
		
		public function get isStatic():Boolean
		{
			return isStatic_;
		}
		
		public function invoke(obj:Object, args:Array = null):*
		{
			if (isStatic) {
				if (namespace != null) {
					return declaringClass.namespace::[name].apply(obj, args);
				}
				else {
					return declaringClass[name].apply(obj, args);
				}
			}
			if (!(obj is declaringClass)) {
				throw new IllegalOperationError('object is not declaringClass instance.');
			}
			if (namespace != null) {
				return obj.namespace::[name].apply(obj, args);
			}
			return obj[name].apply(obj, args);
		}
	}
}