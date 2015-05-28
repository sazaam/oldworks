/**
 * BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
 * BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
 * 
 * BBBBBBBBBBBBBBB					  BBBBBBBBBBBBBB			        BBBBBBBBBBBB				
 * BBBBBBBBBBBBBBBBB			    BBBBBBBBBBBBBBBBBB			      BBBBBBBBBBBBBBBB				
 * BBBBBB	    BBBBBB			  BBBBBB		  BBBBBB		    BBBBBB	      BBBBBB	
 * BBBBBB	     BBBBBB			 BBBBBB		       BBBBBB		   BBBBBB	       BBBBBB
 * BBBBBB	    BBBBBB	   B	BBBBBB			    BBBBBB	  B	  BBBBBB	        BBBBBB
 * BBBBBBBBBBBBBBBBBB	  BBB  BBBBBB			     BBBBBB  BBB  BBBBBBBBBBBBBBBBBBBBBBBB
 * BBBBBBBBBBBBBBBBBBBB	  BBB  BBBBBB			     BBBBBB  BBB  BBBBBBBBBBBBBBBBBBBBBBBB
 * BBBBBB		  BBBBBB   B	BBBBBB			    BBBBBB	  B	  BBBBBB			BBBBBB
 * BBBBBB		   BBBBBB		 BBBBBB			   BBBBBB		  BBBBBB			BBBBBB
 * BBBBBB		  BBBBBB		  BBBBBB		  BBBBBB		  BBBBBB			BBBBBB
 * BBBBBBBBBBBBBBBBBBBB 			BBBBBBBBBBBBBBBBBB			  BBBBBB			BBBBBB
 * BBBBBBBBBBBBBBBBBB			      BBBBBBBBBBBBBB			  BBBBBB			BBBBBB
 * 
 * BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
 * BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
 */
package begin.type {	
	//boa api
	import begin.type.array.Accessors;
	import begin.type.array.Constants;
	import begin.type.array.Methods;
	import begin.type.array.Variables;
	import begin.type.weak.Reference;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.ObjectEncoding;
	import flash.net.registerClassAlias;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.IExternalizable;
	import flash.utils.Proxy;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.xml.XMLNode;

	/**
	 * Reflection api of the boa framework. All introspections operations are made by this Class. 
	 * 
	 * @author abiendo@gmail.com
	 * @version 1.0.0
	 */
	public final class Type extends Object {	
		/**
		 * Create a new Type instance from the specified type.
		 * 
		 * @param x * (default=null) - The specified type to introspect.
		 */
		public function Type(x : *= null) {
			super();
			if (x == null)
				x = new Untyped(Untyped.NULL);
			source = x;
		}

		/**
		 * Runtime casting of an Object as a specified type.
		 * @param instance Object - The object to cast.
		 * @param T Class - The type to cast the specified instance in.
		 * @return * - The casting result.
		 */
		public static function cast(instance : Object, T : Class) : * {
			if (instance as T)
				return T(instance);
			throw new TypeError("Illegal attempted to cast an " + Type.getClass(instance) + "instance to " + T + " subclass of which it is not an instance");
		}

		/**
		 * 
		 * @param	source
		 * @return
		 */
		public function clone(x : Object = null) : Object {
			if (x != null)
				return getClone(x);
			return new Type(x);
		}

		/**
		 * Return the the current application domain
		 * @return ApplicationDomain - the current application domain.
		 */
		public static function context() : ApplicationDomain {
			return ApplicationDomain.currentDomain;
		}	

		/**
		 * Write a plain vanilla object to be an instance of the class
		 * passed as the second variable.  This is not a recursive funtion
		 * and will only work for the first level of nesting.  When you have
		 * deeply nested objects, you first need to convert the nested
		 * objects to class instances, and then convert the top level object.
		 *
		 * TODO: This method can be improved by making it recursive.  This would be
		 * done by looking at the typeInfo returned from describeType and determining
		 * which properties represent custom classes.  Those classes would then
		 * be registerClassAlias'd using getDefinititonByName to get a reference,
		 * and then objectToInstance would be called on those properties to complete
		 * the recursive algorithm.
		 * original sources : http://www.darronschall.com/weblog/archives/000247.cfm
		 * 
		 * @param constructor Class - The type to write the object to.		 
		 * @param prototype Object - The plain object that should be converted.
		 * @param encoding int - The ObjectEncoding int. 
		 * @return * - the instanted type.
		 */		
		public static function create(constructor : Class, prototype : Object, encoding : int = -1) : * {
			//prototype = copyInto(constructor, prototype);
			var bytes : ByteArray = new ByteArray();
			var coding : int = encoding == 0 || encoding == 3 ? encoding : ObjectEncoding.AMF0;
			bytes.objectEncoding = coding;
			// Find the objects and byetArray.writeObject them, adding in the
			// class configuration variable name -- essentially, we're constructing
			// and AMF packet here that contains the class information so that
			// we can simplly byteArray.readObject the sucker for the translation
			// Write out the bytes of the original object
			var objBytes : ByteArray = new ByteArray();
			objBytes.objectEncoding = coding;
			objBytes.writeObject(prototype);
			// Register all of the classes so they can be decoded via AMF
			if (register(constructor)) {
				var fullyQualifiedName : String = getClassPath(constructor);
				// Write the new object information starting with the class information
				//var len:int = fullyQualifiedName.length;
				bytes.writeByte(0x10);  // 0x10 is AMF0 for "typed object (class instance)"
				bytes.writeUTF(fullyQualifiedName);
				// After the class name is set up, write the rest of the object
				bytes.writeBytes(objBytes, 1);
				// Read in the object with the class property added and return that
				bytes.position = 0;
				// This generates some ReferenceErrors of the object being passed in
				// has properties that aren't in the class instance, and generates TypeErrors
				// when property values cannot be converted to correct values (such as false
				// being the value, when it needs to be a Date instead).  However, these
				// errors are not thrown at runtime (and only appear in trace ouput when
				// debugging), so a try/catch block isn't necessary.  I'm not sure if this
				// classifies as a bug or not... but I wanted to explain why if you debug
				// you might seem some TypeError or ReferenceError items appear.
				return bytes.readObject();
			}
			return null;
		}

		/**
		 * Try to evaluate a string instantiation representation expression.
		 * 
		 * @param expr String - The string to evaluate.
		 * @return Object - The instantiated object.
		 */
		public static function eval(expr : String) : * {
			var newindex : int = expr.indexOf("new");
			var startParenthesisIndex : int = expr.indexOf("(");
			var endParenthesisIndex : int = expr.indexOf(")");
			if(newindex == -1) {
				startParenthesisIndex = expr.indexOf("{");
				endParenthesisIndex = expr.indexOf("}");				
				if(startParenthesisIndex != -1 && endParenthesisIndex != -1) {
				}
			} else {
								
			}
			if(startParenthesisIndex != -1 && endParenthesisIndex != -1 && endParenthesisIndex > (startParenthesisIndex + 1)) {
				var min : int = startParenthesisIndex + 1;
				var max : int = endParenthesisIndex - 1;
				var T : Class = getClassByName(expr.substring(newindex + 4, startParenthesisIndex));
				var xml : XML = toXml(T);
				var parametersDesc : XMLList = xml["factory"]["constructor"].*;
				var parameters : Array = min == max ? [] : expr.substring(startParenthesisIndex + 1, endParenthesisIndex).split(",");
				var l : int = parametersDesc.length();
				var i : int;
				for (i = 0;i < l;i++)  {
					var type : String = parametersDesc[i].@type;
					switch(type) {
						case "int":
							parameters[i] = parseInt(parameters[i]);
							break;
						case "uint":
							parameters[i] = parseFloat(parameters[i]);
							break;
						case "Boolean":
							parameters[i] = Boolean(parameters[i]);
							break;
						case "String":
							break;
						case "Array":
							var list : Array = String(parameters[i]).split(",");
							var len : int = list.length;
							parameters[i] = [];
							while(len--)
								parameters[i][len] = eval(list[len]);	
							break;	
						case "Object":						case "*":
						default:
							parameters[i] = eval(parameters[i]);
							break;
					}
				}
				var tmp : Array = [T];
				return getInstance.apply(null, tmp.concat(parameters));
			}
			return null;
		}

		/**
		 * Test if the specified type exist in the specified domain.
		 * 
		 * @param alias String - the fully qualified type name to test. 
		 * @param context ApplicationDomain - the current application Domain to test.
		 * @return Boolezn - if the specoified type exist in the specified domain.
		 */
		public static function exist(alias : String, ctx : ApplicationDomain = null) : Boolean {
			var domain : ApplicationDomain;	
			domain = ctx || context();
			while (!domain.hasDefinition(alias)) {
				if (domain.parentDomain)
					domain = domain.parentDomain;
				else
					return false;
			}	
			return true;
		}

		/**
		 * Try to see if a class extends a particular Class by reflexion.
		 * 
		 * @param instance * - The specified type to test.
		 * @param T Class - The supposed super class.
		 * @return Boolean - True if the specified type is subclass, otherwise false.
		 */
		public static function extendsClass(instance : *, T : Class) : Boolean {
			var desc : XML = toXml(getClass(instance))["typeDescription"]["factory"][0];
			return (desc.children().(name() == "extendsClass").(attribute("type") == getQualifiedName(T)).length() > 0);
		}

		/**
		 * Try to represent the specified object as a string based on introspected runtime properties.
		 * 
		 * @param instance Object - The object to represent.
		 * @return String - A string representation of the specified object.
		 */
		public static function format(instance : Object, namespaceURIs : Array = null, exclude : Array = null) : String {
			var buff : String = "[object " + getClassName(instance) + ": {\n";
			if (exclude == null)
	            exclude = [];//defaultToStringExcludes
			refCount = 0;
			buff += internalToString(instance, 0, null, namespaceURIs, exclude) + "\n";
			return buff += "}]";
		}

		/**
		 * Try to instancite an object from an xml definition.
		 * 
		 * @param definition XML - The specified xml input definition.
		 * @return * - The instance type from the specified xml. 
		 */
		public static function fromXml(definition : XML) : Type {
			
			return null;
		}

		/**
		 * 
		 * @param	o
		 * @param	name
		 * @param	modifier
		 * @return
		 */
		public static function getAccessor(instance : *, name : String = "*") : Array {
			var list : Array = new Type(instance).accessors;
			if (name == "*")
				return list;
			var len : int = list.length;
			while(len--)
				if (Accessor(list[len]).name == name)
					return [Accessor(list[len])];	
			return [];
		}

		/**
		 * Retrieve the class of a specified instance.
		 * 
		 * @param instance Object - The class instance target.
		 * @param context ApplicationDomain (default=null) - The ApplicationDomain where find the class.
		 * @return Class - The class or null if no class where found.
		 */
		public static function getClass(instance : Object, context : ApplicationDomain = null) : Class {
			try {				
				if (context != null)
					return getClassByName(getQualifiedName(instance), context);
				return instance as Class ? Class(instance) : Class(instance["constructor"]);
			} catch (ex : ReferenceError) {
				throw new ArgumentError(ex.message);
			}
			return null;
		}

		/**
		 *  Returns information about the class, and properties of the class, for
		 *  the specified Object.
		 *
		 *  @param obj The Object to inspect.
		 *
		 *  @param exclude Array of Strings specifying the property names that should be 
		 *  excluded from the returned result. For example, you could specify 
		 *  <code>["currentTarget", "target"]</code> for an Event object since these properties 
		 *  can cause the returned result to become large.
		 *
		 *  @param options An Object containing one or more properties 
		 *  that control the information returned by this method. 
		 *  The properties include the following:
		 *
		 *  <ul>
		 *    <li><code>includeReadOnly</code>: If <code>false</code>, 
		 *      exclude Object properties that are read-only. 
		 *      The default value is <code>true</code>.</li>
		 *  <li><code>includeTransient</code>: If <code>false</code>, 
		 *      exclude Object properties and variables that have <code>[Transient]</code> metadata.
		 *      The default value is <code>true</code>.</li>
		 *  <li><code>uris</code>: Array of Strings of all namespaces that should be included in the output.
		 *      It does allow for a wildcard of "~~". 
		 *      By default, it is null, meaning no namespaces should be included. 
		 *      For example, you could specify <code>["mx_internal", "mx_object"]</code> 
		 *      or <code>["~~"]</code>.</li>
		 *  </ul>
		 * 
		 *  @return An Object containing the following properties:
		 *  <ul>
		 *    <li><code>name</code>: String containing the name of the class;</li>
		 *    <li><code>properties</code>: Sorted list of the property names of the specified object.</li>
		 *  </ul>
		 */
		public static function getClassInfo(obj : Object, excludes : Array = null, options : Object = null) : Object {   
			var n : int, i : int;
			// this version doesn't handle ObjectProxy
			if (options == null)
	            options = { includeReadOnly: true, uris: null, includeTransient: true };
			var result : Object;
			var propertyNames : Array = [];
			var cacheKey : String;
			var className : String;
			var classAlias : String;
			var properties : XMLList;
			var prop : XML;
			var dyn : Boolean = false;
			var metadataInfo : Object;
			if (typeof(obj) == "xml") {
				className = "XML";
				properties = XML(obj).text();
				if (properties.length())
	                propertyNames.push("*");
				properties = XML(obj).attributes();
			} else {
				// don't cache describe type.  Makes it slower, but fewer dependencies
				var classInfo : XML = describeType(obj);
				className = XML(classInfo.@name).toString();
//				classAlias = XML(classInfo.@alias).toString();
				dyn = (XML(classInfo.@isDynamic).toString() == "true");
				if (options["includeReadOnly"])
	                properties = classInfo.descendants("accessor").(@access != "writeonly") + classInfo.descendants("variable");
	            else
	                properties = classInfo.descendants("accessor").(@access == "readwrite") + classInfo.descendants("variable");
				var numericIndex : Boolean = false;
			}	
			// If type is not dynamic, check our cache for class info...
			if (!dyn) {
				cacheKey = getCacheKey(obj, excludes, options);
				result = CLASSES[cacheKey];
				if (result != null)
	                return result;
			}
			result = {};
			result["name"] = className;
			result["alias"] = classAlias;
			result["properties"] = propertyNames;
			result["dynamic"] = dyn;
			result["metadata"] = metadataInfo = recordMetadata(properties);
			var excludeObject : Object = {};
			if (excludes) {
				n = excludes.length;
				for (i = 0;i < n;i++)
	                excludeObject[excludes[i]] = 1;
			}
	
			var isArray : Boolean = className == "Array";
			if (dyn) {
				for (var p:String in obj) {
					if (excludeObject[p] != 1) {
						if (isArray) {
							var pi : Number = parseInt(p);
							if (isNaN(pi))
	                             propertyNames.push(new QName("", p));
	                         else
	                            propertyNames.push(pi);
						} else {
							propertyNames.push(new QName("", p));
						}
					}
				}
				numericIndex = isArray && !isNaN(Number(p));
			}
	
			if (className == "Object" || isArray) {
	            // Do nothing since we've already got the dynamic members
			} else if (className == "XML") {
				n = properties.length();
				for (i = 0;i < n;i++) {
					p = properties[i].name();
					if (excludeObject[p] != 1)
	                    propertyNames.push(new QName("", "@" + p));
				}
			} else {
				n = properties.length();
				var uris : Array = options.uris;
				var uri : String;
				var qName : QName;
				for (i = 0;i < n;i++) {
					prop = properties[i];
					p = prop.@name.toString();
					uri = prop.@uri.toString();  
					if (excludeObject[p] == 1)
	                    continue;                
					if (!options.includeTransient && internalHasMetadata(metadataInfo, p, "Transient"))
	                    continue;
					if (uris != null) {
						if (uris.length == 1 && uris[0] == "*") {   
							qName = new QName(uri, p);
							try {
								obj[qName]; // access the property to ensure it is supported
								propertyNames.push();
							} catch(e : Error) {
	                            // don't keep property name 
							}
						} else {
							var j : int;
							for (j = 0;j < uris.length;j++) {
								uri = uris[j];
								if (prop.@uri.toString() == uri) {
									qName = new QName(uri, p);
									try {
										obj[qName];
										propertyNames.push(qName);
									} catch(e : Error) {
	                                    // don't keep property name 
									}
								}
							}
						}
					} else if (uri.length == 0) {
						qName = new QName(uri, p);
						try {
							obj[qName];
							propertyNames.push(qName);
						} catch(e : Error) {
	                        // don't keep property name 
						}
					}
				}
			}
			propertyNames.sort(Array.CASEINSENSITIVE | (numericIndex ? Array.NUMERIC : 0));
			// remove any duplicates, i.e. any items that can't be distingushed by toString()
			for (i = 0;i < propertyNames.length - 1;i++) {
				// the list is sorted so any duplicates should be adjacent
				// two properties are only equal if both the uri and local name are identical
				if (propertyNames[i].toString() == propertyNames[i + 1].toString()) {
					propertyNames.splice(i, 1);
					i--; // back up
				}
			}
	
			// For normal, non-dynamic classes we cache the class info
			if (!dyn) {
				cacheKey = getCacheKey(obj, excludes, options);
				CLASSES[cacheKey] = result;
			}
			return result;
		}

		/**
		 * Retrieve a class by is string alias.
		 * 
		 * @param alias String - The name of the class to retrieve.
		 * @param context ApplicationDomain (default=null) - The ApplicationDomain where find the class.
		 * @return Class - The class or null if no class where found.
		 */
		public static function getClassByName(alias : String, contextDomain : ApplicationDomain = null) : Class {
			if (hasReference(alias))
				return getReference(alias).ref;			
			try {
				if (contextDomain != null) {
					var domain : ApplicationDomain = contextDomain;
					while (domain != null) {
						if (domain.hasDefinition(alias))
							return Class(contextDomain.getDefinition(alias));
						domain = domain.parentDomain;
					}
				}
				return Class(getDefinitionByName(alias));
			} catch (tex : TypeError) {
				throw new TypeError(alias);
			} catch(rex : ReferenceError) {
				throw new TypeError(alias);
			}
			return null;
		}

		/**
		 * Return the short name of a class.
		 * 
		 * @param instance Object - The object instance.
		 * @return String - the name of the class.
		 */				
		public static function getClassName(instance : Object) : String {
			var f : Function = instance as Class ? (Class(instance)["toString"] as Function) : (Class(instance["constructor"])["toString"] as Function);
			var s : String = f.call(instance);		
			return s.slice(7, s.length - 1);
		}

		/**
		 * Returns the package string representation of the specified instance passed in arguments.
		 * 
		 * @param instance Object - the reference of the object to apply reflexion.
		 * @return String - the package string representation of the specified instance passed in arguments.
		 */
		public static function getClassPackage(instance : Object) : String {
			return parsePackage(getClassPath(instance));
		}

		/**
		 * Returns the full path string representation of the specified instance passed in arguments (package + name).
		 * 
		 * @param instance Object - the reference of the object to apply reflexion.
		 * @return String - the full path string representation of the specified instance passed in arguments (package + name).
		 */
		public static function getClassPath(instance : Object) : String {
			return parsePath(getQualifiedName(instance));
		}

		/**
		 * Creates and returns a copy of the specified object. The precise meaning of "copy" may depend on the class of the object.
		 * By convention the specified object must implements the boa.api.core.Serializable.
		 * 
		 * @param instance Object - The specified object to clone.
		 * @return * - The clone instance of the specified object.
		 */
		public static function getClone(object : Object) : * {
			if (object == null)
				throw new ArgumentError("Null 'object' argument.");
			var x : *;
			try {
				switch(object) {
					case (object as int):
					case (object as uint):
					case (object as Number):
					case (object as Boolean):
					case (object as Class):
					case (object as Function):
						return cloneReference(object);
					case (object as String):
						return cloneString(String(object));
					case (object as Array):
						return cloneArray(object as Array); 	
					case (object as BitmapData): 
					case (object as Event):
					case (object as Matrix):
					//case (object as Matrix3D):
					case (object as Point):
					case (object as Rectangle):
					case (object.hasOwnProperty("clone")):
						return cloneNative(object);
					case (object as XML):
					case (object as XMLList): 	
						return cloneXML(object);
					case (object as IExternalizable):
						return cloneExternal(object);
					case (object as DisplayObject):
						return cloneDisplayObject(DisplayObject(object));
					case (object as Namespace):
						return cloneNamespace(object as Namespace);
					case (object as QName):
						return cloneQName(object as QName);
					case (getDefinition(object).isDynamic):
					case (object as Dictionary):
					case (isObjectObject(object)):
						return cloneObject(object);
					default:			
						if (object == null)
							return null;
						break;
				}	
			} catch(ex1 : ReferenceError) {
				throw new Error("Cloning not supported by " + getClass(object) + " class", ex1);
			} catch(ex2 : TypeError) {
				throw new Error("Cloning not supported by " + getClass(object) + " class", ex2);
			}
			return x;
		}

		/**
		 * 
		 * @param	o
		 * @param	name
		 * @param	modifier
		 * @return
		 */
		public static function getConstant(o : *, name : String = "*") : Array {
			var list : Array = new Type(o).constants;
			if (name == "*")
				return list;
			var len : int = list.length;
			while(len--)
				if (Constant(list[len]).name == name)
					return [Constant(list[len])];	
			return [];
		}

		/**
		 * Return type definition of the specified object.
		 * 
		 * @param T Object - The type to introspect at runtime.
		 * @return Type - The Type definition instance.
		 */
		public static function getDefinition(T : Object) : Type {
			if (T == null)
				return null;
			return new Type(T);
		}		

		/**
		 * 
		 * @param	T
		 * @return
		 */
		public static function getQualifiedName(T : *) : String {
			try {
				return getQualifiedClassName(T);
			} catch(e : Error) {}
			return getClassName(T);
		}

		/**
		 * 
		 * @param	T
		 * @return
		 */
		public static function getQualifiedSuperName(T : *) : String {
			return getQualifiedSuperclassName(T);
		}

		/**
		 * 
		 * @return
		 */
		public static function getStackTrace() : String {
			/*
			//var stack:String = Debug.getStackTrace(Error);
			var stack:String = (new Error()).getStackTrace();//Debug.getStackTrace(Error);
			stack = stack.substring(stack.indexOf("@") + 2);
			var i:int = stack.indexOf("@") + 3;
			var j:int = stack.indexOf("()", i);
			//trace(stack);
			//return stack.substring(i, j);
			return stack;
			 */
			return null;
		}

		/**
		 * Get an instance from a specified type to resolve.
		 * 
		 * @param	type * - Can a Class or an instanceof a Class to reinstanciate.
		 * @param	... parameters - Instanciating parameters.
		 * @return	Object - New instance created otherwise null.
		 */
		public static function getInstance(type : *, ... parameters : Array) : Object {
			try {	
				var T : *;
				if (type as String)
					T = getClassByName(type as String);
				else if (type as Class)
					T = type;
				else if (type as Function)
					T = type;
				else
					T = getClassByName(getClassPath(type));
				var a : Array = parameters || [];
				switch(a.length) {
					case 0:
						return new T();
					case  1 : 
						return new T(a[0]) ;
					case  2 : 
						return new T(a[0], a[1]) ;
					case  3 :
						return new T(a[0], a[1], a[2]) ; 
					case  4 : 
						return new T(a[0], a[1], a[2], a[3]) ;
					case  5 : 
						return new T(a[0], a[1], a[2], a[3], a[4]) ;
					case  6 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5]) ;
					case  7 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6]) ;
					case  8 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]) ;
					case  9 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8]) ;
					case 10 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9]) ;
					case 11 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10]) ;
					case 12 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11]) ;
					case 13 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12]) ;
					case 14 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13]) ;
					case 15 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14]) ;
					case 16 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15]) ;
					case 17 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16]) ;
					case 18 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17]) ;
					case 19 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18]) ;
					case 20 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19]) ;
					case 21 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19], a[20]) ;
					case 22 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19], a[20], a[21]) ;
					case 23 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19], a[20], a[21], a[22]) ;
					case 24 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19], a[20], a[21], a[22], a[23]) ;
					case 25 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19], a[20], a[21], a[22], a[23], a[24]) ;
					case 26 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19], a[20], a[21], a[22], a[23], a[24], a[25]) ;
					case 27 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19], a[20], a[21], a[22], a[23], a[24], a[25], a[26]) ;
					case 28 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19], a[20], a[21], a[22], a[23], a[24], a[25], a[26], a[27]) ;
					case 29 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19], a[20], a[21], a[22], a[23], a[24], a[25], a[26], a[27], a[28]) ;
					case 30 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19], a[20], a[21], a[22], a[23], a[24], a[25], a[26], a[27], a[28], a[29]) ;
					case 31 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19], a[20], a[21], a[22], a[23], a[24], a[25], a[26], a[27], a[28], a[29], a[30]) ;
					case 32 : 
						return new T(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19], a[20], a[21], a[22], a[23], a[24], a[25], a[26], a[27], a[28], a[29], a[30], a[31]) ;
					default:
						throw new ArgumentError("Type.getInstance method has been passed an illegal argument" + a[31]);
				}				
			} catch (ex : Error) {
				throw new TypeError("the specified type cannot be instantiated : " + type);
			}
			return null;
		}
		
		public static function getLoaderInfo(T : *) : LoaderInfo {
			return LoaderInfo.getLoaderInfoByDefinition(T);
		}
		
		/**
		 * 
		 * @param	o
		 * @param	name
		 * @param	modifier
		 * @return
		 */
		public static function getMethod(o : *, name : String = "*") : Array {
			var list : Array = new Type(o).methods;
			if (name == "*")
				return list;
			var len : int = list.length;
			while(len--)
				if (Method(list[len]).name == name)
					return [Method(list[len])];	
			return [];
		}

		/**
		 * 
		 */
		public static function getReference(alias : *) : Reference {
			var ref : Reference;
			for each(ref in ALIAS) {
				if (ref.alias == alias)
					return ref;
			}
			return null;
		}

		/**
		 * 
		 * @param	instance
		 * @param	context
		 * @return
		 */
		public static function getSuperClass(instance : Object, context : ApplicationDomain = null) : Class { 
			try {
				return getClassByName(getSuperClassPath(instance), context);
			} catch (ex : ReferenceError) {
				throw new TypeError(ex.message);
			}
			return null;
		}

		/**
		 * Returns the super class name as string of an object.
		 * @return the super class name as string of an object.
		 */				
		public static function getSuperClassName(instance : Object) : String {
			return parseName(getSuperClassPath(instance));
		}

		/**
		 * Returns the super class package string representation of the specified instance passed in arguments.
		 * @param o the reference of the object to apply reflexion.
		 * @return the super class package string representation of the specified instance passed in arguments.
		 */
		public static function getSuperClassPackage(o : *) : String {
			return parsePackage(getSuperClassPath(o));
		}

		/**
		 * Returns the super class path string representation of the specified instance passed in arguments.
		 * @param o the reference of the object to apply reflexion.
		 * @return the super class path string representation of the specified instance passed in arguments.
		 */
		public static function getSuperClassPath(instance : Object) : String {
			return parsePath(getQualifiedSuperName(instance));
		}

		/**
		 * 
		 * @param	o
		 * @param	name
		 * @param	modifier
		 * @return
		 */
		public static function getVariable(o : *, name : String = "*") : Array {
			var list : Array = new Type(o).variables;
			if (name == "*")
				return list;
			var len : int = list.length;
			while(len--)
				if (Variable(list[len]).name == name)
					return [Variable(list[len])];	
			return [];
		}

		/**
		 * 
		 */
		public function hasAccessor(name : String) : Boolean {
			return hasProperty("accessors", name, true);
		}

		/**
		 * 
		 */
		public function hasConstant(name : String) : Boolean {
			return hasProperty("constants", name, true);			
		}

		/**
		 * 
		 */
		public function hasMethod(name : String) : Boolean {
			return hasProperty("methods", name, true);					
		}

		/**
		 * 
		 */
		public static function hasReference(alias : *) : Boolean {
			var ref : Reference;
			for each(ref in ALIAS) {
				if (ref.alias == alias)
					return true;
			}
			return false;
		}

		/**
		 * 
		 */
		public function hasVariable(name : String) : Boolean {
			return hasProperty("variables", name, true);			
		}

		/**
		 * Test if the specified instance type implements the specified Interface type.
		 * 
		 * @param instance * - the type to test.
		 * @param T Class - the specified interface to compare.
		 * @return Boolean - true if the specified instance implements the specified interface otherwise false.
		 */
		public static function implementsInterface(instance : *, T : Class) : Boolean {
			return Boolean(toXml(getClass(instance)).descendants("implementsInterface").(attribute("type") == getQualifiedName(T)).length() > 0);
		}

		/**
		 * Determine if the specified instance implements all the specified methods list.
		 * 
		 * @param instance Object - the specified instance to test.
		 * @param methods Array (default=null) - the list of methods to test.
		 * @return Boolean - true if the specified instance implements all the specified methods.
		 */
		public static function implementsMethods(instance : Object, methods : Array = null) : Boolean {
			var className : String = getQualifiedName(instance);
			var desc : XML = toXml(instance);
			var method : String;
			var overridenFlag : Boolean = false;
			var p : String;
			var m : XML;
			if (methods != null) {
				for each (method in methods) {
					m = desc["method"];
					for (p in m) {
						if (XML(m.@name[p]).toString() == method)
							overridenFlag = (XML(m.@declaredBy[p]).toString() === className);
					}
					if (!overridenFlag)
						throw new Error("abstract method '" + method + "' must be overridden and implemented in subclass.");
				}
			}
			return overridenFlag;
		}

		/**
		 * Test if the specified object arguments is an instance of the specified class arguments
		 * @param instance * - the specified type to test.
		 * @param c Class - the supposed SuperClass.
		 * @return Boolean - true if the specified type is an instance of the specified Class.
		 */
		public static function instanceOf(instance : *, c : Class) : Boolean {
			return Boolean((instance as c) != null);
		}

		/**
		 * Test if the specified object arguments is an instance of Array.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object arguments is an Array.
		 */
		public static function isArray(o : *) : Boolean {
			return Boolean((o as Array) != null);
		}

		/**
		 * Determines if the class or interface represented by this subclass object parameter is either the same as
		 * or is a superclass or superinterface of, the class or interface represented by the specified 
		 * implementation parameter.
		 * 
		 * @param subclass Class - the type to test.
		 * @param implementation - the implementaion to compare.
		 * @return Boolean - true if the implementation parameter is a SuperClass or a SuperInterface of the specified subclass parameter.
		 */
		public static function isAssignableFrom(subclass : Class, implementation : Class) : Boolean {
			var type : Type = new Type(implementation);
			var def : Class = subclass;
			if (type.isInterface) {
				var t : Type = new Type(def);
				var tmp : Array;
				var len : int;
				var i : int;
				while(t != null) {
					tmp = t.interfaces;
					len = tmp.length;
					for (i = 0;i < len;i++) {
						if (implementation == Type(tmp[i]).declaringClass)
							return true;
					}
					if (t.declaringSuperClass != null)
						t = new Type(t.declaringSuperClass);
					else
						break;
				}	
			} else {		
				while(def != null) {
					if (def == implementation)
						return true;
					def = getSuperClass(def);
				}
			}
			return false;
		}

		/**
		 * Test if the specified object arguments is an instance of Boolean.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object arguments is a Boolean Object.
		 */
		public static function isBoolean(o : *) : Boolean {
			return Boolean(o as Boolean);
		}

		/**
		 * Test if the specified object arguments is a complex type.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object arguments is a complex type.
		 */
		public static function isComplex(o : *) : Boolean {
			return isObject(o) || isArray(o) || isDate(o) || isError(o) || isFunction(o) || isRegExp(o) || isXML(o) || isXMLList(o);
		}

		/**
		 * Test if the specified object arguments is a Date.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object arguments is a Date.
		 */
		public static function isDate(o : *) : Boolean {
			return Boolean(o as Date); 
		}

		/**
		 * Test if the specified object arguments is a Date.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object arguments is a Date.
		 */
		public static function isDictionary(o : *) : Boolean {
			return Boolean(o as Dictionary); 
		}

		/**
		 * Test if the specified object arguments is an Error.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object arguments is a Error.
		 */
		public static function isError(o : *) : Boolean {
			return Boolean(o as Error);
		}

		/**
		 * Test if the specified object arguments is an Event.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object arguments is a Event.
		 */
		public static function isEvent(o : *) : Boolean {
			return Boolean(o as Event);
		}

		/**
		 * Test if the specified object arguments is a Function.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object arguments is a Function.
		 */
		public static function isFunction(o : *) : Boolean {
			return Boolean(o as Function);
		}

		/**
		 * Test if the specified object arguments is an int.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object arguments is an int.
		 */
		public static function isInt(o : *) : Boolean {
			return Boolean(o as int);
		}

		/**
		 * Test if the specified object arguments is an internal modifier Class.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object arguments is an internal modifier Class.
		 */
		public static function isInternal(o : *) : Boolean {
			return getQualifiedName(o).indexOf(INTERNAL) != -1;
		}

		/**
		 * Test if the specified object arguments is a native type.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object arguments is a native type.
		 */
		public static function isNative(o : *) : Boolean {
			return isObjectObject(o) || isPrimitive(o);
		}

		/**
		 * Test if the specified object arguments is a null type.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object arguments is a null type.
		 */
		public static function isNull(o : *) : Boolean {
			return Boolean(o === null);
		}

		/**
		 * Test if the specified object arguments is a Number.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object arguments is a Number.
		 */
		public static function isNumber(o : *) : Boolean {
			return !isNaN(o);
		}

		/**
		 * Test if the specified object arguments is an Object.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object arguments is an Object.
		 */
		public static function isObject(o : *) : Boolean {
			return Boolean(o as Object);
		}

		/**
		 * Test if the specified object arguments is an Object Object.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object arguments is an Object Object.
		 */
		public static function isObjectObject(o : *) : Boolean {
			return Boolean(Object(o).constructor === Object);
		}

		/**
		 * Test if the specified object arguments is a primitive type like Boolean, int, Null, Number, String, uint void.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object arguments is a primitive type.
		 */
		public static function isPrimitive(o : *) : Boolean {
			return isObjectObject(o) || isBoolean(o) || isInt(o) || isUint(o) || isNumber(o) || isString(o) || isNull(o) || isVoid(o);
		}

		/**
		 * Test if the specified object arguments is a RegExp instance.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object is a RegExp instance.
		 */
		public static function isRegExp(o : *) : Boolean {
			return Boolean(o as RegExp);
		}

		/**
		 * Test if the specified class alias exist in the internal Boa map registration.
		 * @param alias String - the alias to test
		 * @return Boolean - true if the specified alias correspond to a registered type.
		 */
		public static function isRegistered(alias : String) : Boolean {
			if (alias != null) {
				var ref : Reference;
				for each(ref in ALIAS) {
					if (ref.alias == alias)
						return true;				
				}
			}
			return false;
		}

		/**
		 * Test if the specified object arguments is a String instance.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object is a String.
		 */
		public static function isString(o : *) : Boolean {
			return Boolean(o as String);
		}

		/**
		 * Test if the specified SubClass is a SubClass of the specified SuperClass.
		 * @param subClass Class - the class to test.
		 * @param superClass Class - the suposed superClass.
		 * @return Boolean  - true if the specified subClass is a subClass of the specifed SuperClass.
		 */
		public static function isSubclassOf(subClass : Class, superClass : Class) : Boolean {
			return Class(superClass).isPrototypeOf(subClass);/*superClass.prototype.isPrototypeOf(subClass.prototype);*/
		}

		/**
		 * Test if the specified object arguments is a uint type.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object is a uint type.
		 */
		public static function isUint(o : *) : Boolean {
			return Boolean(o as uint);
		}

		/**
		 * Test if the specified object arguments is a void type.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object is a void type.
		 */
		public static function isVoid(o : *) : Boolean {
			return Boolean(o === undefined);
		}

		/**
		 * Test if the specified object arguments is a XML type.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object is a XML type.
		 */
		public static function isXML(o : *) : Boolean {
			return Boolean(o as XML);
		}

		/**
		 * Test if the specified object arguments is a XMLList type.
		 * @param o * - the type to test
		 * @return Boolean - true if the specified object is a XMLList type.
		 */
		public static function isXMLList(o : *) : Boolean {
			return Boolean(o as XMLList);
		}

		/**
		 * Register the specified Object in the Boa API class map.
		 * 
		 * @param o Object - the specified Object to register.
		 * @param name String (default=null) - the registration name (null in the most of the case).
		 * @param isDynamic Boolean (default=false) - true if the specified Object class is Dynamic.
		 * @param isFinal Boolean (default=false) - true if the specified Object class is Final.
		 * @param isStatic Boolean (default=false) - true if the specified Object class is Static.
		 * @return Boolean - true in the case of success registration otherwise false. 
		 */
		public static function register(o : Object, name : String = null, isDynamic : Boolean = false, isFinal : Boolean = false, isStatic : Boolean = false) : Boolean {
			try {
				var c : Class = toClass(o);
				var qualifiedAlias : String = getQualifiedName(c);
				var alias : String = getClassName(c);
				if (!isRegistered(qualifiedAlias)) {
					registerClassAlias(alias, c);		
					var classDeclaration : XML = o as Class ? describeType(o) : describeType(c);
					var ref : Reference;
					ref = ALIAS[qualifiedAlias] = createReference(qualifiedAlias, c, classDeclaration, isDynamic, isFinal, isStatic);
					if (!(o as Class))
						ref.instanceDescription = describeType(o);
				} else {
					ref = ALIAS[qualifiedAlias];
					if (ref.instanceDescription == null) 
						ref.instanceDescription = describeType(o);
				}
				return true;
			} catch (e : Error) { }
			return false;
		}

		/**
		 * Test if to types are stricly equals.
		 * 
		 * @param o1 * - the first type to compare.
		 * @param o2 * - the second type to compare.
		 * @return Boolean - true if the specified types are stricly equals otherwise false.
		 */
		public static function strictEquality(o1 : *, o2 : *) : Boolean {
			return Boolean(o1 === o2);
		}

		public function toString() : String {
			return format(this, null, [ 	//debug"accessors", "classLoader", "className", "constants","declaringClass", "declaringConstructor", "declaringSuperClass","defaultHashCode", "defaultVersion", "definition","hierarchy", "interfaces", "isClass", "isDynamic","isFinal", "isInterface", "isStatic", "metaDatas",
											"methods", "packages", "prototype", "staticAccessors",
											"staticConstants", "staticMethods", "staticVariables",
											"source", "variables", "definition", "metaDatas",
											"superClassName", "declaringSuperConstructor",]);
		}

		/**
		 * Return an XML description off the specified type. This method is based on flash.utils.describeType method.
		 * 
		 * @param	T Object - the object to describe.
		 * @param isDynamic Boolean (default=false) - true if the specified Object class is Dynamic.
		 * @param isFinal Boolean (default=false) - true if the specified Object class is Final.
		 * @param isStatic Boolean (default=false) - true if the specified Object class is Static.
		 * @return XML - the xml definition otherwise null.
		 */
		public static function toXml(T : Object, loaderInfo : LoaderInfo = null, isDynamic : Boolean = false, isFinal : Boolean = false, isStatic : Boolean = false) : XML {
			if (register(T, null, isDynamic, isFinal, isStatic)) {
				var name : String;
				switch(T) {
					case (T == null):
						name = getQualifiedName(Untyped);
						break;
					case (T as XML):
					case (T as XMLList):
					case (T as String):
					case (T as Array):
						name = getQualifiedName(T.constructor);
						break;
					case (T as Proxy):
						// Proxy subclasses don't have references to their constructors
						name = getQualifiedName(Proxy);
						break;
					default: 
						name = getQualifiedName(T);
						break;
				}
				if (loaderInfo != null) {
					T = loaderInfo.applicationDomain.getDefinition(name);	
				} else {
					try {
						T = getDefinitionByName(name);
					} catch (e : Error) {
						try {
							loaderInfo = getLoaderInfo(Type);
							if (loaderInfo.applicationDomain != null)
								T = loaderInfo.applicationDomain.getDefinition(name);
							else 
								throw new TypeError("Describe type Error");
						} catch(e2 : Error) {
//							trace("here")	
						}
					}
				}
				return describeType(T);
//				if (ALIAS[name] != null) {
//					if (Reference(ALIAS[alias]).description != null)
//					return Reference(ALIAS[alias]).description;
				//createReference(alias, describeType(o), o, isDynamic, isFinal, isStatic)
				//= describeType(T)
//				}
//				if (alias in ALIAS)*/
//				return T as Class ? Reference(ALIAS[alias]).description : Reference(ALIAS[alias]).instanceDescription;
			}
			return null;
		}

		/**
		 * Unregister the specified Object off the Boa API class map.
		 * 
		 * @param alias String (default=null) - The alias class to flush if a class is specified, otherwise all aliases are flush.
		 */
		public static function unregister(alias : String = null) : void {
			if (isRegistered(alias))
				delete ALIAS[alias];
		}

		/**
		 * @return an array of <code>Accessor</code> methods
		 * @see Accessor
		 */
		public function get accessors() : Array {
			return getAccessorList(isClass ? _definition["accessor"] : _instanceDefinition["accessor"], false);
		}

		/**
		 * 
		 
		public function get classLoader():ClassLoader
		{
		return null;
		}
		 */
		/**
		 * @return the name of the inspected class
		 */
		public function get className() : String {
			return isClass ? _definition.@name : _instanceDefinition.@name;
		}

		/**
		 * @return an array of <code>Variable</code> objects representing all public static constants 
		 * within the inspected class
		 * @see Variable
		 */
		public function get constants() : Array {
			return getConstantList(_definition["constant"], false);
		}

		/**
		 * 
		 */
		public function get defaultHashCode() : int {
			var hashcode : int = 1;
			hashcode += isDynamic ? 1 : 0;
			hashcode += isFinal ? 1 : 0;
			hashcode += isStatic ? 1 : 0;
			hashcode += accessors.length + constants.length + interfaces.length + metaDatas.length + methods.length + staticAccessors.length + staticConstants.length + staticMethods.length + staticVariables.length + variables.length;
			return hashcode *= 31;
		}

		/**
		 * 
		 */
		public function get definition() : XML { 
			return _definition; 
		}

		/**
		 * 
		 */
		public function get declaringClass() : Class { 
			return _declaringClass; 
		}

		/**
		 * 
		 */
		public function get declaringConstructor() : Constructor {
			return new Constructor(this, className, getParametersList(_definition["factory"]["constructor"]), getMetaDataList(_definition["factory"]["metadata"]));
		}		

		public function get declaringInterfaces() : Array {
			var tmp : Array = [];
			var list : XMLList = _definition["factory"]["implementsInterface"];
			var item : XML;
			var c : Class;
			var type : Type;
			for each (item in list) {
				type = new Type(getClassByName(item.@type));
				tmp.push(new Interface(this, type.className, type.metaDatas));			
			}
			return tmp;
		}

		/**
		 * 
		 * @return  Class - the superclass of the spcified type
		 */
		public function get declaringSuperClass() : Class { 
			return getClassByName(superClassName);
		}

		/**
		 * 
		 */
		public function get declaringSuperConstructor() : Constructor {
			var T : Type = new Type(declaringSuperClass);
			return new Constructor(T, T.className, T.declaringConstructor.parameters, T.declaringConstructor.metadatas);
		}

		/**
		 * Return the dom tree
		 * 
		 * @return Array - An array of Type hierarchy for each superclass found in the object dom.
		 */
		public function get hierarchy() : Array {
			var classes : Array = toArray(_definition["extendsClass"], "type");
			var len : int = classes.length;
			var i : int;
			var type : Type;
			var cl : Class;
			var tmp : Array = [];
			for(i = 0;i < len;i++) {
				type = new Type(getClassByName(String(classes[i])));
				tmp.push(type.declaringClass);
			}
			return tmp;
		}

		/**
		 * 
		 * @return  Array - an array of the Types of the interfaces implemented by the inspected class
		 */		
		public function get interfaces() : Array { 
			var list : Array = toArray(_definition["factory"]["implementsInterface"], "type");// : _instanceDefinition["implementsInterface"]
			var len : int = list.length;
			if (len > 0) {
				var classes : Array = [];
				var cl : Class;
				var name : String;
				while(len--) {
					name = list[len];
					cl = getClassByName(name);
					classes[len] = getDefinition(cl);	 
				}
				return classes;
			}
			return [];
		}

		/**
		 * 
		 * @return  Boolean - if the specified type is Class
		 */
		public function get isClass() : Boolean {
			return Boolean((source as Class) != null);
		}

		/**
		 * Mostly returns true because mostly the inspected object is decendent of a class object and 
		 * the Class class is dynamic. But we can try to set an arbitrary property to the Type instance
		 * source... Throwing an Error and returning false the specified Object isn't Dynamic.
		 * 
		 * @return	Boolean -
		 */
		public function get isDynamic() : Boolean {
			try {
				if (isClass)
					return Boolean(_definition.@isDynamic == "true");
				var rnd : Number = Math.random() * 1000000;
				var code : String = "_$@" + rnd;
				_source[code] = code;
				delete _source[code];
				return true;
			} catch (ex : Error) { 
			}
			return false;
		}

		/**
		 * @return true if the class is declared as final otherwise returns false
		 */
		public function get isFinal() : Boolean {	
			return Boolean(_definition.@isFinal == "true");
		}

		/**
		 * @return
		 */
		public function get isInterface() : Boolean {
			return Boolean(_definition.@base == "Class" && XMLList(_definition["factory"]["extendsClass"]).length() == 0);/*&& definition["constructor"] == null*/
		}

		/**
		 * @return true if the class is declared as static otherwise returns false
		 */
		public function get isStatic() : Boolean {
			return _definition.@isStatic == "true";
		}

		/**
		 * @return an array of <code>MetaData</code> objects representing the classes metadata 
		 * if it is present, otherwise returns an empty array
		 */
		public function get metaDatas() : Array {
			return getMetaDataList(isClass ? _definition.descendants().(name() == "metadata") : _instanceDefinition.descendants().(name() == "metadata"));
		}

		/**
		 * @return an array of <code>Method</code> objects representing all public methods within the inspected class
		 * @see Method
		 */		
		public function get methods() : Methods { 
			var tmp : Methods = new Methods();
			var list : XMLList; 
			if (isClass) {
				list = _definition["factory"]["method"];
			} else {
				list = _instanceDefinition["method"];
			}
			var item : XML;
			for each (item in list)
				tmp.push(new Method(this, item.@name, item.@returnType, false, getParametersList(item), getMetaDataList(item["metadata"])));
			return tmp;
		}

		/**
		 * @return an Object that is the prototype of the current declaringClass
		 */		
		public function get packages() : Array { 		
			return null;
		}

		/**
		 * @return an Object that is the prototype of the current declaringClass
		 */		
		public function get prototype() : Object { 		
			return declaringClass.prototype;
		}

		/**
		 * @return an array of <code>Accessor</code> methods
		 * @see Accessor
		 */
		public function get staticAccessors() : Array {
			return getAccessorList(_definition["accessor"], true);
		}

		/**
		 * @return an array of <code>Variable</code> objects representing all public constants within 
		 * the inspected class
		 * @see Variable
		 */
		public function get staticConstants() : Array {
			return getConstantList(_definition["constant"], true);
		}

		/**
		 * @return an array of <code>Method</code> objects representing all public static methods 
		 * within the inspected class
		 * @see Method
		 */
		public function get staticMethods() : Array {
			var tmp : Array = [];
			var list : XMLList = _definition["method"];
			var item : XML;
			for each (item in list)
				tmp.push(new Method(this, item.@name, item.@returnType, true, getParametersList(item), getMetaDataList(item["metadata"])));
			return tmp;
		}

		/**
		 * @return an array of <code>Variable</code> objects representing all public static variables 
		 * within the inspected class 
		 * @see Variable
		 */
		public function get staticVariables() : Array {
			return getVariablesList(_definition["variable"], true);
		}

		public function get source() : Object {
			return _source;
		}

		public function set source(value : Object) : void {
			if (value != null) {
				if (value as Class) {
					_declaringClass = value as Class;
					_definition = describeType(_declaringClass);
				} else {
					_declaringClass = Class(value.constructor);//work around
					_definition = describeType(_declaringClass);
					_instanceDefinition = describeType(value);
				}				
				_source = value;
				register(_source, getQualifiedName(value), _definition.@isDynamic == "true", _definition.@isFinal == "true", _definition.@isStatic == "true");
			}
		}

		/**
		 * @return the superclass of the inspected class
		 */
		public function get superClassName() : String {
			return toArray(_definition["extendsClass"], "type")[0];
		}

		/**
		 * @return an array of <code>Variable</code> objects representing all public variables within 
		 * the inspected class
		 * @see Variable
		 */
		public function get variables() : Variables {
			var tmp : Array = getVariablesList(isClass ? _definition["factory"]["variable"] : _instanceDefinition["variable"], false);
			var variables : Variables = new Variables();
			var len : int = tmp.length;
			while(len--)
				variables.push(tmp[len]);
			return variables;
		}

		public static const ACCESSOR : String = ".";
		public static const E4X_ACCESSOR : String = "@";
		public static const INTERNAL : String = "as$";
		public static const QUALIFIED : String = "::";
		public static const READONLY : String = "readonly";
		public static const READWRITE : String = "readwrite";
		public static const WRITEONLY : String = "writeonly";

		protected function getModifiers() : Object {
			return {
				isDynamic:false, isFinal:true, isStatic:false
			};	
		}

		/**
		 * 
		 */
		private static function cloneArray(array : Array) : Object {
			var len : int = array.length;
			var tmp : Array = new Array(len);
			while(len--)
		 		tmp[len] = getClone(array[len]);
			return tmp;
		}

		/**
		 * 
		 */
		private static function cloneDisplayObject(displayObject : DisplayObject) : Object {
			var prototype : Object = {
				transform : displayObject.transform, filters : displayObject.filters, cacheAsBitmap : displayObject.cacheAsBitmap, opaqueBackground : displayObject.opaqueBackground
			};
			if (displayObject.scale9Grid != null) {
				var rect : Rectangle = displayObject.scale9Grid;
				// Flash 9 bug where returned scale9Grid is 20x larger than assigned
				rect.x /= 20, 
				rect.y /= 20, 
				rect.width /= 20, 
				rect.height /= 20;
				prototype["scale9Grid"] = rect;
			}
			if (displayObject as Bitmap) {
				var bmp : Bitmap = Bitmap(displayObject);
				prototype["bitmapData"] = bmp.bitmapData.clone();
				prototype["pixelSnapping"] = bmp.pixelSnapping; 
				prototype["smoothing"] = bmp.smoothing;
			}
			var x : * = create(Class(Object(displayObject).constructor), prototype);
			if (displayObject as DisplayObjectContainer) {					
				var src : DisplayObjectContainer = DisplayObjectContainer(displayObject);
				var dst : DisplayObjectContainer = DisplayObjectContainer(x);
				var num : int = src.numChildren;
				var j : int = 0;
				if (num > 0) {
					do {
						dst.addChild(DisplayObject(getClone(src.getChildAt(j))));
					} while(j++ < num);
				}
			}
			return x;			
		}

		/**
		 * 
		 */
		private static function cloneExternal(o : Object) : Object {
			if (register(o)) {
				//default instance cloning
				var bytes : ByteArray = new ByteArray();
				bytes.writeObject(o);
				bytes.position = 0;
				return bytes.readObject();
			}
			return null;
		}

		/**
		 * 
		 */
		private static function cloneNamespace(ns : Namespace) : Object {
			return new Namespace(ns.prefix, ns.uri);
		}

		/**
		 * 
		 */
		private static function cloneNative(instance : Object) : Object {
			var f : Function = instance["clone"] as Function;
			return f();
		}

		/**
		 * 
		 */
		private static function cloneObject(src : *) : Object {
			var dst : *;
			if (src as Dictionary)
		 		dst = new Dictionary(true);
		 	else if (isObjectObject(src))
		 		dst = {};
		 	else if (getDefinition(src).isDynamic)
		 		dst = getInstance(src);
		 	else
		 		return null; 
			for (var p:* in src)
		 		dst[p] = getClone(src[p]);
			return dst;
		}

		/**
		 * 
		 */
		private static function cloneQName(qname : QName) : Object {
			return new QName(new Namespace(qname.localName, qname.uri));
		}

		/**
		 * 
		 */
		private static function cloneReference(x : *) : Object {
			return x;	
		}

		/**
		 * 
		 */
		private static function cloneString(str : String) : String {
			var x : String;
			var n : int = str.length;
			var i : int = 0;
			do {
				x += str.charAt(i);
			} while(i++ < n);
			return x;
		}

		/**
		 * 
		 */
		private static function cloneXML(doc : Object) : Object {
			if (doc as XML)
				return (doc as XML).copy();
			if (doc as XMLList)	
				return (doc as XMLList).copy();
			return null;	
		} 	

		/**
		 * 
		 */
		private static function createReference(alias : String, ref : Class, desc : XML, isDynamic : Boolean = false, isFinal : Boolean = false, isStatic : Boolean = false) : Reference {
			return Reference.create(alias, ref, desc, isDynamic, isFinal, isStatic);
		}

		/**
		 * 
		 */
		private function foundProperty(props : String, name : String) : Boolean {
			var tmp : Array = this[props] as Array;
			var len : int = tmp.length;
			var el : *;
			while(len--) {
				el = tmp[len];
				if (el != null && el["name"] == name)
					return true;
			}
			return false;
		}

		/**
		 * @private
		 * 
		 * @param	list
		 * @param	isStatic
		 * @return
		 */
		private function getAccessorList(list : XMLList, isStatic : Boolean) : Array {
			var tmp : Accessors = new Accessors();
			var item : XML;
			for each (item in list)
				tmp.push(new Accessor(this, item.@name, item.@access, item.@type, isStatic, getMetaDataList(item["metadata"])));
			return tmp;
		}

		/**
		 *  @private
		 */
		private static function getCacheKey(o : Object, excludes : Array = null, options : Object = null) : String {
			var key : String = getQualifiedClassName(o);
			if (excludes != null) {
				for (var i : uint = 0;i < excludes.length;i++) {
					var excl : String = excludes[i] as String;
					if (excl != null)
	                    key += excl;
				}
			}
			if (options != null) {
				for (var flag:String in options) {
					key += flag;
					var value : String = options[flag] as String;
					if (value != null)
	                    key += value;
				}
			}
			return key;
		}

		/**
		 * 
		 * @param	list
		 * @param	isStatic
		 * @return
		 */
		private function getConstantList(list : XMLList, isStatic : Boolean) : Array {
			var tmp : Array = new Constants();
			for each (var item:XML in list)
				tmp.push(new Constant(this, item.@name, item.@type, isStatic));
			return tmp;
		}

		/**
		 * 
		 * @param	metaData
		 * @return
		 */
		private function getMetaDataList(metaData : XMLList) : Array {
			if(metaData == null) 
				return null;
			var metaDataAr : Array = [];
			var data : XML;
			var name : String;
			var argsAr : Array;
			var node : *;
			var list : XMLList;
			for each (data in metaData) {
				name = data.@name;
				if(name == "") 
					continue;
				argsAr = [];
				list = data.children();
				for each (node in list)
					argsAr.push(new Arg(this, node.@key, node.@value));
				metaDataAr.push(new Metadata(this, name, argsAr));
			} 
			return metaDataAr;
		}

		/**
		 * 
		 * @param	method
		 * @return
		 */
		private function getParametersList(method : *) : Array {
			var tmp : Array = [];
			var list : * = method as XMLList ? XMLList(method).children() : method["parameter"];
			var item : XML;
			for each (item in list)
				tmp.push(new Parameter(this, item.@index, item.@type, item.@optional == "true"));	
			return tmp;
		}

		/**
		 * 
		 * @param	list
		 * @param	isStatic
		 * @return
		 */
		private function getVariablesList(list : XMLList, isStatic : Boolean) : Array {
			var tmp : Array = [];
			for each (var item:XML in list)
				tmp.push(new Variable(this, item.@name, item.@type, isStatic, getMetaDataList(item["metadata"])));
			return tmp;
		}

		/**
		 * 
		 */	
		private function hasProperty(props : String, name : String, staticChek : Boolean = false) : Boolean {
			if (isDynamic) {
				var o : Object = declaringClass.prototype;
				if (o != null && name in o)
					return true;
			}
			if (foundProperty(props, name))
				return true;
			if (staticChek)
				return foundProperty("static" + props.charAt(0).toLocaleUpperCase() + props.substr(1, props.length), name);
			return false;			
		}

		/**
		 *  This method cleans up all of the additional parameters that show up in AsDoc
		 *  code hinting tools that developers shouldn't ever see.
		 *  @private
		 */
		private static function internalToString(value : Object, indent : int = 0, refs : Dictionary = null,  namespaceURIs : Array = null, exclude : Array = null) : String {
			var str : String;
			var type : String = value == null ? "null" : typeof(value);
			switch (type) {
				case "boolean":
				case "number":
					{
					return "" + value;
					}
				case "string":
					{
					return "\"" + String(value) + "\"";
					}
				case "object":
					{
					if (value as Date) {
						return (value as Date).toString();
					} else if (value as XMLNode) {
						return XMLNode(value).toString();
					} else if (value as Class) {
						return "(" + getQualifiedClassName(value) + ")";
					} else {
						var classInfo : Object = getClassInfo(value, exclude, { includeReadOnly: true, uris: namespaceURIs }); 
						var properties : Array = classInfo["properties"];
						str = "(" + classInfo["name"] + ")";
						// refs help us avoid circular reference infinite recursion.
						// Each time an object is encoumtered it is pushed onto the
						// refs stack so that we can determine if we have visited
						// this object already.
						if (refs == null)
	                        refs = new Dictionary(true);
						// Check to be sure we haven't processed this object before
						var id : Object = refs[value];
						if (id != null) {
							str += "#" + int(id);
							return str;
						}
						if (value != null) {
							str += "#" + refCount.toString();
							refs[value] = refCount;
							refCount++;
						}
						var isArray : Boolean = value is Array;
						var prop : *;
						indent += 2;
						// Print all of the variable values.
						var j : int;
						var f : Function;
						for (j = 0;j < properties.length;j++) {
							str = newline(str, indent);
							prop = properties[j];
							if (isArray)
	                            str += "[";
							f = prop["toString"];
							str += String(f());
							if (isArray)
	                            str += "] ";
	                        else
	                            str += " = ";
							try {
								str += internalToString(value[prop], indent, refs, namespaceURIs, exclude);
							} catch(e : Error) {
								// value[prop] can cause an RTE
								// for certain properties of certain objects.
								// For example, accessing the properties
								//   actionScriptVersion
								//   childAllowsParent
								//   frameRate
								//   height
								//   loader
								//   parentAllowsChild
								//   sameDomain
								//   swfVersion
								//   width
								// of a Stage's loaderInfo causes
								//   Error #2099: The loading object is not
								//   sufficiently loaded to provide this information
								// In this case, we simply output ? for the value.
								str += "?";
							}
						}
						indent -= 2;
						return str;
					}
					break;
					}
				case "xml":
					{
					return XML(value).toString();
					}
				default:
					{
	                return "(" + type + ")";
	            }
			}
			return "(unknown)";
		}  

		/**
	     *  @private
	     */
	    private static function internalHasMetadata(metadataInfo:Object, propName:String, metadataName:String):Boolean
	    {
	        if (metadataInfo != null) {
	            var metadata:Object = metadataInfo[propName];
	            if (metadata != null) {
	                if (metadata[metadataName] != null)
	                    return true;
	            }
	        }
	        return false;
	    }
    
	    /**
	     *  @private
	     *  This method will append a newline and the specified number of spaces
	     *  to the given string.
	     */
	    private static function newline(str:String, n:int = 0):String
	    {
	        var result:String = str;
	        result += "\n";
	        for (var i:int = 0; i < n; i++)
	            result += " ";
	        return result;
	    }	    
		
		private static function parseAlias(type:*):String 
        {
			var name:String = getQualifiedName(type);
            return parsePath(name);
        }
		
		/**
		 * 
		 * @param	path
		 * @return
		 */
		private static function parseName(path:String):String 
        {
            var a:Array = path.split(ACCESSOR) ;
            return (a.length > 1) ? a.pop() : path ;
        }

		/**
		 * 
		 * @param	path
		 * @return
		 */
		private static function parsePackage(path:String):String 
        {
            var a:Array = path.split(ACCESSOR) ;
            if (a.length > 1) {
            	var list:Array = a.pop();
                return list.join(ACCESSOR) ;
            }
			return null;
        }
 
	    /**
	     *  @private
	     */
	    private static function recordMetadata(properties:XMLList):Object
	    {
	        var result:Object = null;
	        try {
	        	var prop:XML;
	            for each (prop in properties) {
	                var propName:String = prop.attribute("name").toString();
	                var metadataList:XMLList = prop["metadata"];
	                if (metadataList.length() > 0) {
	                    if (result == null)
	                        result = {};
	                    var metadata:Object = {};
	                    result[propName] = metadata;
	                    for each (var md:XML in metadataList) {
	                        var mdName:String = md.attribute("name").toString();
	                        var argsList:XMLList = md["arg"];
	                        var value:Object = {};
	                        for each (var arg:XML in argsList) {
	                            var argKey:String = arg.attribute("key").toString();
	                            if (argKey != null) {
	                                var argValue:String = arg.attribute("value").toString();
	                                value[argKey] = argValue;
	                            }
	                        }
	                        var existing:Object = metadata[mdName];
	                        if (existing != null) {
	                            var existingArray:Array;
	                            if (existing is Array)
	                                existingArray = existing as Array;
	                            else
	                                existingArray = [];
	                            existingArray.push(value);
	                            existing = existingArray;
	                        } else {
	                            existing = value;
	                        }
	                        metadata[mdName] = existing;
	                    }
	                }
	            }
	        }
	        catch(e:Error)
	        {
	        }
	        
	        return result;
	    }
           	
		/**
		 * Since there is no way to reflectively invoke namespace scoped methods we will
		 * not add them. But there is the edge case that interface methods have an uri
		 * that equals the fully qualified name of the interface. That is the only case where
		 * we accept an uri attribute.
		 * 
		 * @return whether we accept the type as a public member
		 
		private static function representsPublicMember(xml:XML) : Boolean 
		{
			xml;
			//TODO: implements Type.representsPublicMember properly
			return false;//(xml.@uri.length() == 0 || _interface);
		}
		*/
		/**
		 * 
		 * @param	path
		 * @return
		 */
		private static function parsePath(path:String):String {
			if (path == null)
				return null;	
			if (path.indexOf("as$") != -1) {
				var pkg:Array = path.split(ACCESSOR);
				var superClass:String = pkg[0];
				var internalClass:Array = path.split(QUALIFIED);
				return superClass + "." + internalClass[internalClass.length - 1];
			}
            return path.split(QUALIFIED).join(ACCESSOR);
        } 
		
		/**
		 * 
		 * @param	list
		 * @param	attribute
		 * @return
		 */
		private static function toArray(list:XMLList, attribute:String):Array
		{
			var tmp:Array = [];
			for each (var item:XML in list)
				tmp.push(item["@" + attribute]);
			return tmp;
		}
		
		/**
		 * 
		 * @param	T
		 * @param	contex
		 * @return
		 */
		private static function toClass(T:*, domain:ApplicationDomain=null):Class
		{
			try {
				var c:Class;
				switch(T) {
					case (T as Class):
						c = Class(T);
					break;
					case (T as String):
						c = getClassByName(T, domain);
					break;
					default:
						try {
							c = getClass(Object(T).constructor, domain);
						} catch (err:Error) {
							var name:String = getQualifiedName(T);
							c = getClassByName(name, domain);
						}
					break;
				}
				return c;
			} catch (e:Error) {}
			return null;
		}
			
		private static function toReference(T:Object, isDynamic:Boolean=false, isFinal:Boolean=false, isStatic:Boolean=false):Reference {
			if (register(T, null, isDynamic, isFinal, isStatic)) {
				var name:String;
				var c:Class;
				switch(T) {
					case (T == null):
						name = getQualifiedName(Untyped);
						break;
					case (T as XML):
					case (T as XMLList):
					case (T as String):
					case (T as Array):
						name = getQualifiedName(T.constructor);
						break;
					case (T as Proxy):
						//Proxy subclasses don't have references to their constructors
						name = getQualifiedName(T);
						break;
					default: 
						name = getQualifiedName(T);
						break;
				}	
				c = Class(getDefinitionByName(name));
				var alias:String = parseAlias(c);
				return Reference(ALIAS[alias]);
			}
			return null;
		}
		
		private static var ALIAS:Dictionary = new Dictionary(true);
			
		/**
		 * 
		 */
		
		private var _definition:XML;
		private var _instanceDefinition:XML;
		private var _declaringClass:Class;
		private var _source:Object;
			
	    /**
	     * @private
	     */
	    private static var refCount:int = 0;
	    
	    /**
	     * @private
	     */ 
	    private static var CLASSES:Object = {};
	}	
}