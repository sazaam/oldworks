/*
 * Shinobi - a OOP based kit. The
 * original source remains:
 *
 * Copyright (c) 2012, Shinobi
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or
 * without modification, are permitted provided that the following
 * conditions are met:
 *
 *  * Redistributions of source code must retain the above
 *    copyright notice, this list of conditions and the
 *    following disclaimer.
 *  * Redistributions in binary form must reproduce the above
 *    copyright notice, this list of conditions and the following
 *    disclaimer in the documentation and/or other materials provided
 *    with the distribution.
 *  * Neither the name of the Shinobi Software nor the names of
 *    its contributors may be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 */
(function Shinobi(namespace) {

	//Temporary namespace
	var SHINOBI_NAMESPACE = {};

	/*****************************
	 *
	 * TYPE
	 *
	 ******************************/

	/**
	 * Type object provide types manipulation for the Javascript programming
	 * language. These include raw types, parameterized types, array
	 * types, type variables and primitive types.
	 *
	 * @author Aime Biendo
	 */
	var Type = {
		/**
		 * Define a type into an instance of the specified type. Before the type
		 * can be used it must be resolved.
		 *
		 * @param {Object} definition the type declaration
		 * @param {Object} type the desired superclass
		 * @return the defined type
		 */
		define : function define(definition, type) {
			var p, s, o, statics = definition["statics"]
			var T = type ||
			function T() {
			};
			var body = (function(obj, proto) {
				if (!Type.ownedProperty(obj, "__proto__")) {
					obj["__proto__"] = {};
				}
				obj.__proto__ = typeof proto == "function" ? proto.prototype : proto;
				return obj;
			})(definition, definition.constructor);
			definition = body.constructor;
			definition.prototype = new T;
			if (statics) {
				for (p in statics)
				definition[p] = statics[p];
			}
			delete body["statics"];
			for (p in body) {
				if (p != "constructor") {
					definition.prototype[p] = body[p];
				}
			}
			return definition;
		},
		/**
		 * Returns the name of the entity (class, interface, array class, or
		 * primitive type) represented by the specified object, as a String.
		 *
		 * @param {Object} type the entity (class, interface, array class, or
		 * 			primitive type)
		 * @return the name of the class or interface represented by the specified
		 * 			object.
		 */
		getClassName : function getClassName(type) {
			if (type == null) {
				return null;
			}
			type = typeof type != "function" ? type.constructor : type;
			var index, lindex, parts, name = type.toString();
			if (Type.ownedProperty(type, "slot")) {
				return type["slot"];
			} else if (name.indexOf("function") != -1) {
				parts = Type.getFunctionName(name);
				if (parts != null) {
					return parts;
				}
			} else if (name.indexOf("[class") != -1 || name.indexOf("[object") != -1) {
				return name.substring(7, name.length - 1);
			}
			return null;
		},
		/**
		 * Valid only in a function. Defines the undecorated name of the enclosing
		 * function as a string.
		 *
		 * @param {Function} func the specified Function
		 * @return The undecorated name of the enclosing function as a string.
		 */
		getFunction : function getFunction(func) {
			var cl = func || getFunction.caller;
			if (cl != null) {
				return cl.toString();
			}
			return null;
		},
		/**
		 * Valid only in a function. Defines the undecorated name of the enclosing
		 * function as a string.
		 *
		 * @param {Function} func the specified Function
		 * @return The the undecorated name of the enclosing function as a string.
		 */
		getFunctionName : function getFunctionName(func) {
			var cl = func || getFunctionName.caller;
			if (cl != null) {
				var fsignature = cl.toString();
				var fName = fsignature.match(/function\s*([\w\$]*)\s*\(/);
				if (fName !== null) {
					return fName[1];
				}
			}
			return null;
		},
		/**
		 * Valid only in a function. Defines the signature of the enclosing function
		 * as a string.
		 *
		 * @param {Function} func the specified Function
		 * @return The signature of the signature of the enclosing function as a
		 * 			string
		 */
		getFunctionSignature : function getFunctionSignature(func) {
			var cl = func || getFunctionSignature.caller;
			if (cl != null) {
				var f = cl.toString();
				return f.substring(f.indexOf("{") + 1, f.lastIndexOf("}"));
			}
			return null;
		},
		/**
		 * Creates a new instance of the type represented by the specified type
		 * object.
		 *
		 * @param {Object} type the object to instanciate
		 * @param {Object} namespace the named scope
		 * @return the instanciated type otherwise null
		 */
		getInstance : function getInstance(type, namespace/*, ... parameters : Array*/) {
			try {
				var a, T, args, namespace = Type.namespace(namespace);
				if ( typeof type == "string") {
					T = Type.getTypeByName(type, namespace);
					if ( typeof T != "function") {
						T = T.constructor;
					}
				} else if ( typeof type == "function") {
					T = type;
				} else {
					T = type.constructor;
				}
				args = Type.toArray(arguments).splice(2, arguments.length - 1) || [];
				var fName = Type.getFunctionName(T);
				if (fName) {
					return eval("var f = namespace[fName]; new f(" + args.join(",") + ")");
				}
			} catch (ex) {
				throw new TypeError("the specified type cannot be instantiated : " + type);
			}
			return null;
		},
		/**
		 * Returns the type object associated with the class or interface with
		 * the given string name
		 *
		 * @param {String} name the fully qualified name of the desired type.
		 * @param {Object} namespace
		 * @return the type object for the class or interface with the specified
		 * 			name.
		 */
		getTypeByName : function getTypeByName(name, namespace) {
			if (!name || typeof name != "string") {
				return null;
			}
			if (name == "" || name == "*" || name == "window" || name == "global") {
				return window;
			}
			if (Type.ownedProperty( namespace = Type.namespace(namespace), name)) {
				return namespace[name];
			}
			var i, ns, p = Type.normalizeComponents(name), len = p.length;
			for ( i = 0; i < len; i++) {
				if (( ns = p[i]) && !( namespace = namespace[ns])) {
					return null;
				}
			}
			return namespace;
		},
		/**
		 * Returns a hash code value for the specified type.
		 *
		 * @param {Object} type the object to calculate hascode
		 * @return a hash code value for the specified type
		 */
		hashCode : function hashCode(type) {
			var c;
			var hash = 0;
			var qualifiedClassName = Type.getClassName( typeof type == "function" ? type : type.constructor);
			if (qualifiedClassName.length == 0) {
				return hash;
			}
			for ( i = 0; i < qualifiedClassName.length; i++) {
				c = qualifiedClassName.charCodeAt(i);
				hash = 31 * ((hash << 31) - hash) + c;
				hash = hash & hash;
			}
			return hash;
		},
		/**
		 * The implements method is used in a type declaration to indicate that
		 * the class being declared provides implementations for all methods declared
		 * in the specified interfaces whose name are listed.
		 *
		 * @param {Object} definition the type being declared
		 * @param {Array} interfaces list of interfaces to implements
		 * @param {Object} namespace the global scope where live the being
		 * 		declared
		 * @return the implemented type
		 */
		implement : function implement(type, interfaces, namespace) {
			if (type == null) {
				return null;
			}
			interfaces = interfaces || [];
			var c, method, cname, len = interfaces ? interfaces.length : 0;
			namespace = Type.namespace(namespace);
			type.interfaces = [];
			while (len--) {
				c = interfaces[len];
				if ( typeof c == "string") {
					cname = c;
					c = Type.getTypeByName(cname, namespace);
				} else if ( typeof c == "function") {
					cname = Type.getClassName(c);
				}
				if (!c || !cname || cname == "") {
					throw new TypeError("ClassNotFoundException " + cname);
				}
				c = c.prototype;
				for (method in c) {
					if (/constructor|bind|clone|hashCode|clone|finalize|equals|toString|getClass/.test(method)) {
						continue;
					}
					if (!Type.ownedProperty(type.prototype, method)) {
						throw new TypeError("NotImplementedMethodException " + cname + "::" + method + "() in class " + Type.getClassName(type));
					}
				}
				type.interfaces.push(cname);
			}
			return type;
		},
		/**
		 * The inherit method is used to declare a new Javascript type, which is
		 * a collection of related variables and/or methods. Types are the basic
		 * building blocks of object−oriented programming. A type typically represents
		 * some real−world entity such as a geometric Shape or a Person. A type
		 * is a template for an object. Every object is an instance of a type. To
		 * use a type, you instantiate an object of the type, typically with the
		 * new operator, then call the declared methods to access the features of
		 * the type.
		 *
		 * @param {String} qname the fully qualified type name
		 * @param {Object} superclass the super type
		 * @param {Array} interfaces a list of interfaces to implements
		 * @param {Object} subclass the type definition
		 * @param {Object} namespace the global scope where live the type
		 * @return the created type otherwise null
		 */
		inherit : function inherit(parameters/*qname, superclass, interfaces, subclass, namespace*/) {
			var T = function T() {
			};
			var qname = parameters["qname"];
			var superclass = parameters["superclass"] || Object;
			var interfaces = parameters["interfaces"] || [];
			var subclass = parameters["subclass"] || {};
			var namespace = Type.namespace(parameters["namespace"]);
			var isinterface = qname.indexOf("@") != -1;
			//default subclass
			subclass = !subclass ? o : ( typeof subclass == "string" ? (Type.getTypeByName(subclass) || o) : subclass);
			//default superclass
			superclass = !superclass ? Object : ( typeof superclass == "string" ? (Type.getTypeByName(superclass) || Object) : ( typeof superclass != "function" ? superclass.constructor : superclass));
			//set prototype of the new Type
			T.prototype = superclass.prototype;
			subclass.constructor == Function ? (subclass.prototype = new T) : ( subclass = Type.define(subclass, T));
			subclass.slot = qname;
			subclass.base = superclass;
			subclass.itype = isinterface;
			subclass.factory = superclass.prototype;
			subclass.prototype.constructor = subclass;
			subclass = Type.implement(subclass, interfaces, namespace);
			subclass.subclass = function subclass(vargs) {
				vargs["superclass"] = parameters["subclass"];
				return inherit(vargs);
			};
			subclass.toString = function toString() {
				return (subclass.itype ? "[interface " : "[class ") + subclass.slot + "]";
			};
			var parts = Type.normalizeComponents(qname);
			var nsname = parts.length >= 2 ? parts.splice(0, parts.length - 1).join(".") : "";
			var ns = nsname == "" ? namespace : Type.getTypeByName(nsname, namespace);
			var c = ns ? (ns[parts[parts.length - 1]] = subclass) : subclass;
			if (c.prototype.cinit) {
				c.prototype.cinit.apply(c.prototype, [c, namespace]);
				delete c.prototype.cinit;
			}
			if (c.prototype.iinit) {
				c.prototype.iinit.apply(c.prototype, [c.prototype]);
				delete c.prototype.iinit;
			}
			return c;
		},
		/**
		 * @param
		 */
		isNative : function isNative(obj) {
			switch(typeof obj) {
				case 'number':
				case 'string':
				case 'boolean':
					// Primitive types are not native objects
					return false;
			}
			// Should be an instance of an Object
			if (!( obj instanceof Object)) {
				return false;
			}
			// Should have a constructor that is an instance of Function
			if ( typeof obj.constructor === 'undefined') {
				return false;
			}
			if (!(obj.constructor instanceof Function)) {
				return false;
			}
			return true;
		},
		/**
		 * Mixin allows multiple objects to be combined into a single larger object.
		 *
		 * @param {Object} type the destination type
		 * @param {Object} base the source type
		 * @param {Object} exp user callback method
		 * @return the mixed type
		 */
		mixin : function mixin(type, base, exp) {
			var p, exp = exp;
			for (p in base) {
				if ((exp && exp(p)) || Type.ownedProperty(base, p)) {
					type[p] = base[p];
				}
			}
			return type;
		},
		/**
		 * Always return a valid named scope
		 *
		 * @param {Object} ns the named scope
		 * @param {Object} defaults the default named scope
		 * @return a valid named scope
		 */
		namespace : function namespace(ns, defaults) {
			return ns || defaults || window;
		},
		/**
		 * Normalise a fully qualified class name.
		 *
		 * @param {Object} qualifiedClassName the name to normalize
		 * @return the normalized namespace
		 */
		normalize : function normalize(qualifiedClassName) {
			return qualifiedClassName.replace(/\/|\$|::/g, ".");
		},
		/**
		 * Return a splited normalised fully qualified class name.
		 *
		 * @param {Object} qualifiedClassName the name to normalize and split
		 * @return the splited normalized namespace
		 */
		normalizeComponents : function normalizeComponents(qualifiedClassName) {
			return Type.normalize(qualifiedClassName).split(".");
		},
		/**
		 * Tests if the specified objects are equals
		 *
		 * @param {Object} obj1 the first type to test
		 * @param {Object} obj2 the second type to test
		 * @return true otherwise false
		 */
		objectEquals : function objectEquals(obj1, obj2) {
			var i;
			for (i in obj1) {
				if (Type.ownedProperty(obj1, i)) {
					if (!Type.ownedProperty(obj2, i)) {
						return false;
					}
					if (obj1[i] != obj2[i]) {
						return false;
					}
				}
			}
			for (i in obj2) {
				if (Type.ownedProperty(obj2, i)) {
					if (!Type.ownedProperty(obj1, i)) {
						return false;
					}
					if (obj1[i] != obj2[i]) {
						return false;
					}
				}
			}
			return true;
		},
		/**
		 *
		 */
		ownedProperty : function ownedProperty(type, name) {
			if (type["hasOwnProperty"]) {
				return type.hasOwnProperty(name);
			} else if (Object.prototype.hasOwnProperty) {
				return Object.prototype.hasOwnProperty.call(type, name);
			}
			return type[name] != null;
		},
		/**
		 * Transform arguments object into an Array of parameters
		 *
		 * @param {Object} parameters the parameters to slice
		 * @return the sliced parameters list
		 */
		toArray : function(parameters) {
			return Array.prototype.slice.call(parameters);
		}
	};

	/*****************************
	 *
	 * ArrayUtil
	 *
	 ******************************/

	var ArrayUtil = Type.inherit({
		qname : "ArrayUtil",
		subclass : {
			constructor : function ArrayUtil() {
			},
			statics : {
				/**
				 * Executes a test function on each item in the array until an item
				 * is reached that returns false for the specified function. You use
				 * this method to determine whether all items in an array meet a criterion,
				 * such as having values less than a particular number.
				 * For this method, the third parameter, scope, must be null if the
				 * second parameter, callback, is a method closure.
				 *
				 * @param  	array Array - the needed Array.
				 * @param 	callback Function - The function to run on each item in
				 * 			the array. This function can contain a simple comparison
				 * 			(for example, item < 20) or a more complex operation, and
				 * 			is invoked with three arguments; the value of an item, the
				 * 			index of an item, and the Array object.
				 * @param 	scope An object to use as this for the function.
				 * @return	A Boolean value of true if all items in the array return
				 * 			true for the specified function; otherwise, false
				 */
				every : function every(array, callback, scope) {
					if (!Type.ownedProperty(array, "every")) {
						if (scope == undefined) {
							scope = null;
						}
						var len = array.length;
						for (var i = 0; i < len; i++) {
							if (!callback.call(scope, array[i], i, array)) {
								return false;
							}
						}
						return true;
					}
					return array.every(callback, scope);
				},
				/**
				 * Executes a test function on each item in the array and constructs
				 * a new array for all items that return true for the specified function.
				 * If an item returns false, it is not included in the new array.
				 * For this method, the third parameter, scope, must be null if the
				 * second parameter, callback, is a method closure.
				 *
				 * @param  	array the needed Array.
				 * @param 	callback The function to run on each item in the array.
				 * 			This function can contain a simple comparison (for example,
				 * 			item < 20) or a more complex operation, and is invoked with
				 * 			three arguments; the value of an item, the index of an item,
				 * 			and the Array object.
				 * @param 	scope scope - An object to use as this for the function.
				 * @return 	A new array that contains all items from the original array
				 * 			that returned true.
				 */
				filter : function filter(array, callback, scope) {
					if (!Type.ownedProperty(array, "filter")) {
						if (scope == undefined) {
							scope = null;
						}
						var tmp = new Array();
						var len = array.length;
						for (var i = 0; i < len; i++) {
							if (callback.call(scope, array[i], i, array)) {
								tmp.push(array[i]);
							}
						}
						return tmp;
					}
					return array.filter(callback, scope);
				},
				/**
				 * Executes a function on each item in the array.
				 * For this method, the second parameter, scope, must be null if the
				 * first parameter, callback, is a method closure.
				 *
				 * @param  	array the needed Array.
				 * @param 	callback The function to run on each item in the array.
				 * 			This function can contain a simple command (for example,
				 * 			a trace() statement) or a more complex operation, and is
				 * 			invoked with three arguments; the value of an item, the
				 * 			index of an item, and the Array object.
				 * @param 	scope An object to use as this for the function.
				 */
				forEach : function forEach(array, callback, scope) {
					if (!Type.ownedProperty(array, "forEach")) {
						if (scope == undefined) {
							scope = null;
						}
						var len = array.length;
						for (var i = 0; i < len; i++) {
							callback.call(scope, array[i], i, array);
						}
					} else {
						array.forEach(callback, scope);
					}
				},
				/**
				 * Searches for an item in an array by using strict equality (===)
				 * and returns the index position of the item.
				 *
				 * @param  	array the needed Array.
				 * @param 	item The item to find in the array.
				 * @param 	fromIndex The location in the array from which to start
				 * 			searching for the item.
				 * @return	A zero-based index position of the item in the array. If
				 * 			the searchElement argument is not found, the return value
				 * 			is -1.
				 */
				indexOf : function indexOf(array, item, fromIndex) {
					if (!Type.ownedProperty(array, "indexOf")) {
						if (fromIndex == undefined) {
							fromIndex = 0;
						}
						var len = array.length;
						for (var i = fromIndex; i < len; i++) {
							if (array[i] === item) {
								return i;
							}
						}
						return -1;
					}
					return array.indexOf(item, fromIndex);
				},
				/**
				 * Searches for an item in an array by using strict equality (===)
				 * and returns the index position of the item.
				 *
				 * @param  	array the needed Array.
				 * @param 	item The item to find in the array.
				 * @param 	fromIndex The location in the array from which to start
				 * 			searching for the item.
				 * @return	A zero-based index position of the item in the array. If
				 * 			the searchElement argument is not found, the return value
				 * 			is -1.
				 */
				lastIndexOf : function lastIndexOf(array, item, fromIndex) {
					if (!Type.ownedProperty(array, "lastIndexOf")) {
						if (fromIndex == undefined) {
							fromIndex = 0;
						}
						var len = fromIndex || array.length;
						while (len--) {
							if (array[len] === item) {
								return len;
							}
						}
						return -1;
					}
					return array.lastIndexOf(item, fromIndex);
				},
				/**
				 * Executes a function on each item in an array, and constructs a new
				 * array of items corresponding to the results of the function on each
				 * item in the original array.For this method, the second parameter,
				 * scope, must be null if the second parameter, callback, is a method
				 * closure.
				 *
				 * @param 	callback The function to run on each item in the array.
				 * 			This function can contain a simple command (such as changing
				 * 			the case of an array of strings) or a more complex operation,
				 * 			and is invoked with three arguments; the value of an item,
				 * 			the index of an item.
				 * @param 	scope An object to use as this for the function.
				 * @return 	A new array that contains the results of the function on
				 * 			each item in the original array.
				 */
				map : function map(array, callback, scope) {
					if (!Type.ownedProperty(array, "map")) {
						if (scope == undefined) {
							scope = null;
						}
						var len = array.length;
						var tmp = [];
						for (var i = 0; i < len; i++) {
							tmp.push(callback.call(scope, array[i], i, array));
						}
						return tmp;
					}
					array.map(callback, scope);
				},
				/**
				 * Executes a test function on each item in the array until an item
				 * is reached that returns true. Use this method to determine whether
				 * any items in an array meet a criterion, such as having a value less
				 * than a particular number. For this method, the third parameter,
				 * scope, must be null if the second parameter, callback, is a method
				 * closure.
				 *
				 * @param  	array the needed Array.
				 * @param 	callback The function to run on each item in the array.
				 * 			This function can contain a simple comparison (for example item < 20)
				 * 			or a more complex operation, and is invoked with three
				 * 			arguments; the value of an item, the index of an item.
				 * @param 	scope An object to use as this for the function.
				 */
				some : function some(array, callback, scope) {
					if (!Type.ownedProperty(array, "some")) {
						if (scope == undefined) {
							scope = null;
						}
						var len = array.length;
						for (var i = 0; i < len; i++) {
							if (!callback.call(scope, array[i], i, array)) {
								return false;
							}
						}
						return true;
					}
					return array.some(callback, scope);
				}
			}
		}
	});

	/*****************************
	 *
	 * CONTRUCTOR
	 *
	 ******************************/

	/**
	 * <code>Constructor</code> provides information about, and access to, a
	 * single constructor for a class.
	 * @see Type
	 * @see Class
	 * @author Aime Biendo
	 */
	var Constructor = Type.inherit({
		qname : "Constructor",
		subclass : {
			/**
			 * Create a <code>Constructor</code> from the specified declaringClass and
			 * name.
			 *
			 * @param {Function} declaringClass the type constructor
			 * @param {String} name the type name
			 */
			constructor : function Constructor(declaringClass, name) {
				this.clazz = declaringClass;
				this.name = name;
			},
			/**
			 * Return a copy of this constructor
			 *
			 * @return this constructor copy
			 */
			copy : function copy() {
				return new this.constructor(this.clazz, this.name);
			},
			/**
			 * Compares this <code>Constructor</code> against the specified object.
			 * Returns true if the objects are the same.  Two <code>Constructor</code>
			 * objects are the same if they were declared by the same class and have
			 * the same formal parameter types.
			 *
			 * @param {Object} obj the object to compare
			 * @return true otherwise false
			 */
			equals : function equals(obj) {
				if (obj != null && obj instanceof Constructor) {
					var other = obj;
					return (this.getDeclaringClass() == other.getDeclaringClass()) && (this.getName() == other.getName());
				}
				return false;
			},
			/**
			 * Returns the <code>Class</code> object representing the class that
			 * declares the constructor represented by this <code>Constructor</code>
			 * object.
			 *
			 * @return the declaring class
			 */
			getDeclaringClass : function getDeclaringClass() {
				return this.clazz;
			},
			/**
			 * Returns the name of this constructor, as a string.  This is
			 * always the same as the simple name of the constructor's declaring
			 * class.
			 *
			 * @return the simple name of the constructor's declaring class.
			 */
			getName : function getName() {
				return this.name;
			},
			/**
			 * Returns a hash code value for the constructor.
			 *
			 * @return a hash code value for this constructor.
			 */
			hashCode : function hashCode() {
				return Type.hashCode(this.clazz);
			},
			/**
			 * Uses the constructor represented by this Constructor object to create
			 * and initialize a new instance of the constructor's declaring class,
			 * with the specified initialization parameters. Individual parameters
			 * are automatically unwrapped to match primitive formal parameters,
			 * and both primitive and reference parameters are subject to method
			 * invocation conversions as necessary.
			 *
			 * @param {Array} initargs array of objects to be passed as arguments to
			 * 					the constructor call; values of primitive types are
			 * 					wrapped in a wrapper object of the appropriate type
			 * @return a new object created by calling the constructor this object
			 * 			represents
			 */
			newInstance : function newInstance() {
				return Type.newInstance(this.type, Type.toArray(arguments).splice(1, 1));
			},
			/**
			 * Returns a string describing this Constructor
			 *
			 * @return a string representation of the object.
			 */
			toString : function toString() {
				return +"function " + this.getName() + "()";
			},
			clazz : null,
			name : null

		},
		namespace : SHINOBI_NAMESPACE
	});

	/*****************************
	 *
	 * FIELD
	 *
	 ******************************/

	/**
	 * A <code>Field</code> provides information about, and dynamic access to, a
	 * single field of a class or an interface.  The reflected field may be a class
	 * (static) field or an instance field.
	 *
	 * <p>A <code>Field</code> permits widening conversions to occur during a get
	 * or set access operation, but throws an <code>IllegalArgumentException</code>
	 * if a narrowing conversion would occur.
	 *
	 * @see Type
	 * @see Class
	 * @author Aime Biendo
	 */
	var Field = Type.inherit({
		qname : "Field",
		subclass : {
			/**
			 * Create a <code>Field</code> from the specified declaringClass, name,
			 * type value constructor and static modifier.
			 *
			 * @param {Function} declaringClass the type constructor
			 * @param {String} name the type name
			 * @param {Function} type value constructor
			 * @param {Boolean} isStatic the static modifier
			 */
			constructor : function Field(declaringClass, name, type, isStatic) {
				this.clazz = declaringClass;
				this.name = name;
				this.asStatic = isStatic == null ? false : isStatic;
			},
			/**
			 * Return a copy of this field
			 *
			 * @return this field copy
			 */
			copy : function copy() {
				return new this.constructor(this.clazz, this.name, this.type, this.asStatic);
			},
			/**
			 * Compares this <code>Field</code> against the specified object. Returns
			 * true if the objects are the same.  Two <code>Field</code> objects are
			 * the same if they were declared by the same class and have the same name
			 * and type.
			 *
			 * @param {Object} obj the object to compare
			 * @return true otherwise false
			 */
			equals : function equals(obj) {
				if (obj != null && obj instanceof Field) {
					var other = obj;
					return (this.getDeclaringClass() == other.getDeclaringClass()) && (this.getName() == other.getName()) && (this.getType() == other.getType()) && (this.asStatic == obj.asStatic);
				}
				return false;
			},
			/**
			 * Returns the value of the field represented by this <code>Field</code>,
			 * on the specified object.
			 *
			 * @param {Object} obj object from which the represented field's value is
			 * 			to be extracted
			 * @return the value of the represented field in object
			 * 			<tt>obj</tt>; primitive values are wrapped in an appropriate
			 * 			object before being returned
			 */
			get : function get(obj) {
				var proto = this.clazz.prototype;
				if (Type.ownedProperty(proto, this.name) && Type.ownedProperty(obj, this.name)) {
					var field = obj[this.name];
					return field;
				}
				throw new TypeError("Field " + this.name + " invocation error");
			},
			/**
			 * Returns the <code>Class</code> object representing the class or interface
			 * that declares the field represented by this <code>Field</code> object.
			 *
			 * @return the field declaring class
			 */
			getDeclaringClass : function getDeclaringClass() {
				return this.clazz;
			},
			/**
			 * Returns the name of the field represented by this <code>Field</code>
			 * object, as a <code>String</code>.
			 *
			 * @return this method name
			 */
			getName : function getName() {
				return this.name;
			},
			/**
			 * Returns a <code>Class</code> object that identifies the
			 * declared type for the field represented by this
			 * <code>Field</code> object.
			 *
			 * @return a <code>Class</code> object identifying the declared
			 * 			type of the field represented by this object
			 */
			getType : function getType() {
				return this.type;
			},
			/**
			 * Returns a hash code value for the field.
			 *
			 * @return a hash code value for this method.
			 */
			hashCode : function hashCode() {
				return Type.hashCode(this.clazz);
			},
			/**
			 * Tets if this field is static
			 *
			 * @return true otherwise false
			 */
			isStatic : function isStatic() {
				return asStatic;
			},
			/**
			 * Sets the field represented by this <code>Field</code> object on the
			 * specified object argument to the specified new value.
			 *
			 * @param {Object} obj the object whose field should be modified
			 * @param {Object} value the new value for the field of <code>obj</code>
			 * 			being modified
			 */
			set : function set(obj, value) {
				var proto = this.clazz.prototype;
				if (Type.ownedProperty(proto, this.name) && Type.ownedProperty(obj, this.name)) {
					obj[this.name] = value;
					return obj[this.name];
				}
				throw new TypeError("Field " + this.name + " invocation error");
			},
			/**
			 * Returns a string describing this <code>Field</code>.
			 *
			 * @return the string description
			 */
			toString : function toString() {
				var cname = Type.getClassName(this.clazz);
				var dec = asStatic ? cname : cname + "prototype.";
				return dec + this.getName();
			},
			statics : {
				/**
				 * Utility routine to paper over array type names
				 *
				 * @param {Function} type the type to determine name
				 * @return the name of the specified type
				 */
				getTypeName : function getTypeName(type) {
					return Type.getClassName(type);
				}
			},
			asStatic : false,
			clazz : null,
			name : null
		},
		namespace : SHINOBI_NAMESPACE
	});

	/*****************************
	 *
	 * METHOD
	 *
	 ******************************/

	/**
	 * A <code>Method</code> provides information about, and access to, a single method
	 * on a class or interface.  The reflected method may be a class method
	 * or an instance method (including an abstract method).
	 *
	 * @see Type
	 * @see Class
	 * @author Aime Biendo
	 */
	var Method = Type.inherit({
		qname : "Method",
		subclass : {
			/**
			 * Create a <code>Method</code> from the specified declaringClass, name and
			 * static modifier.
			 *
			 * @param {Function} declaringClass the type constructor
			 * @param {String} name the type name
			 * @param {Boolean} isStatic the static modifier
			 */
			constructor : function Method(declaringClass, name, isStatic) {
				this.clazz = declaringClass;
				this.name = name;
				this.asStatic = isStatic == null ? false : isStatic;
			},
			/**
			 * Return a copy of this method
			 *
			 * @return this constructor copy
			 */
			copy : function copy() {
				return new this.constructor(this.clazz, this.name, this.asStatic);
			},
			/**
			 * Compares this <code>Method</code> against the specified object.  Returns
			 * true if the objects are the same.  Two <code>Methods</code> are the same
			 * if they were declared by the same class and have the same name
			 * and formal parameter types and return type.
			 *
			 * @param {Object} obj the object to compare
			 * @return true otherwise false
			 */
			equals : function equals(obj) {
				if (obj != null && obj instanceof Method) {
					var other = obj;
					return (this.getDeclaringClass() == other.getDeclaringClass()) && (this.getName() == other.getName()) && (this.asStatic == obj.asStatic);
				}
				return false;
			},
			/**
			 * Returns the <code>Class</code> object representing the class or interface
			 * that declares the method represented by this <code>Method</code> object.
			 *
			 * @return the method declaring class
			 */
			getDeclaringClass : function getDeclaringClass() {
				return this.clazz;
			},
			/**
			 * Returns the name of the method represented by this <code>Method</code>
			 * object, as a <code>String</code>.
			 *
			 * @return this method name
			 */
			getName : function getName() {
				return this.name;
			},
			/**
			 * Returns a hash code value for the method.
			 *
			 * @return a hash code value for this method.
			 */
			hashCode : function hashCode() {
				return Type.hashCode(this.clazz);
			},
			/**
			 * Invokes the underlying method represented by this <code>Method</code>
			 * object, on the specified object with the specified parameters.
			 * Individual parameters are automatically unwrapped to match
			 * primitive formal parameters, and both primitive and reference
			 * parameters are subject to method invocation conversions as
			 * necessary.
			 *
			 * <p>If the underlying method is static, then the specified <code>obj</code>
			 * argument is ignored. It may be null.
			 *
			 * <p>If the number of formal parameters required by the underlying method is
			 * 0, the supplied <code>args</code> array may be of length 0 or null.
			 *
			 * <p>If the underlying method is an instance method, it is invoked
			 * using dynamic method lookup as documented in The Java Language
			 * Specification, Second Edition, section 15.12.4.4; in particular,
			 * overriding based on the runtime type of the target object will occur.
			 *
			 * <p>If the underlying method is static, the class that declared
			 * the method is initialized if it has not already been initialized.
			 *
			 * <p>If the method completes normally, the value it returns is
			 * returned to the caller of invoke; if the value has a primitive
			 * type, it is first appropriately wrapped in an object. However,
			 * if the value has the type of an array of a primitive type, the
			 * elements of the array are <i>not</i> wrapped in objects; in
			 * other words, an array of primitive type is returned.  If the
			 * underlying method return type is void, the invocation returns
			 * null.
			 *
			 * @param {Object} obj  the object the underlying method is invoked from
			 * @param {Array} parameters the arguments used for the method call
			 * @return the result of dispatching the method represented by
			 * this object on <code>obj</code> with parameters
			 * <code>args</code>
			 */
			invoke : function invoke(obj) {
				var paremeters = Type.toArray(arguments);
				var proto = this.clazz.prototype;
				if (Type.ownedProperty(proto, this.name) && Type.ownedProperty(obj, this.name)) {
					var method = proto[this.name];
					return method.apply(obj, parameters.splice(1, parameters.length));
				}
				throw new TypeError("Method " + this.name + " invocation error");
			},
			/**
			 * Tets if this method is static
			 *
			 * @return true otherwise false
			 */
			isStatic : function isStatic() {
				return asStatic;
			},
			/**
			 * Uses the constructor represented by this Constructor object to create
			 * and initialize a new instance of the constructor's declaring class,
			 * with the specified initialization parameters. Individual parameters
			 * are automatically unwrapped to match primitive formal parameters,
			 * and both primitive and reference parameters are subject to method
			 * invocation conversions as necessary.
			 *
			 * @param {Array} initargs array of objects to be passed as arguments to
			 * 					the constructor call; values of primitive types are
			 * 					wrapped in a wrapper object of the appropriate type
			 * @return a new object created by calling the constructor this object
			 * 			represents
			 */
			newInstance : function newInstance() {
				return Type.newInstance(this.type, Type.toArray(arguments).splice(1, 1));
			},
			/**
			 * Returns a string describing this <code>Method</code>.
			 *
			 * @return this method string description
			 */
			toString : function toString() {
				var cname = Type.getClassName(this.clazz);
				var dec = asStatic ? cname : cname + "prototype.";
				return dec + "= function " + this.getName() + "(){}";
			},
			asStatic : false,
			clazz : null,
			name : null
		},
		namespace : SHINOBI_NAMESPACE
	});

	/*****************************
	 *
	 * LINKER
	 *
	 ******************************/

	/**
	 * A class linker is an object that is responsible for loading and linking
	 * classes. Given the binary name of a class, a class linker should attempt
	 * to locate or generate data that constitutes a definition for the class. A
	 * typical strategy is to transform the name into a file name and then read
	 * a "class file" of that name from a file system.
	 * Every Shinobi application object contains a reference to the Linker that
	 * defined it.
	 * Applications implement subclasses of Linker in order to extend the manner
	 * in which the Shinobi dynamically loads classes.
	 * Linker class uses a delegation model to search for  classes and resources
	 * Each instance of Linker has an associated parent class linker. When requested
	 * to find a class or resource, a Linker instance will delegate the search for
	 * the class or resource to its parent class linker before attempting to find
	 * the class or resource itself. The Shinobi built-in class linker, called the
	 * "bootstrap class linker", does not itself have a parent but may serve as
	 * the parent of a Linker instance.
	 * Class linkers that support concurrent loading of classes are known as parallel
	 * capable class linkers and are required to register themselves at their class
	 * initialization time by invoking the registerAsParallelCapable method.
	 * Note that the Linker class is registered as parallel capable by default.
	 * However, its subclasses still need to register themselves if they are parallel
	 * capable.
	 * In environments in which the delegation model is not strictly hierarchical,
	 * class linkers need to be parallel capable.
	 * However, some classes may not originate from a file; they may originate from
	 * other sources, such as the network, or they could be constructed by an
	 * application.
	 * The method defineClass converts a string into an instance of class.
	 * The methods and constructors of objects created by a class linker may
	 * reference other classes. To determine the class(es) referred to, the
	 * Shinobi invokes loadClass method of the linker that originally created the
	 * class. Any class name provided as a string parameter to methods in Linker
	 * must be a binary name as defined by the Shinobi API specification.
	 *
	 * @see Type
	 * @see SystemClassLinker
	 * @author Aime Biendo
	 */
	var Linker = Type.inherit({
		qname : "Linker",
		subclass : {
			/**
			 * Creates a new class linker using the specified parent class linker
			 * for delegation.
			 *
			 * @param {Linker} parent The parent class linker
			 */
			constructor : function Linker(parent) {
				if (ArrayUtil.indexOf(Linker.LINKERS, this) == -1) {
					Linker.LINKERS.push(this);
				}
				if (!this instanceof SystemClassLinker) {
					var scl = Linker.getSystemClassLinker();
					this.parent = parent || scl;
				}
				this.created = true;
			},
			/**
			 * Record every loaded class with this linker.
			 *
			 * @param {String} qualifiedClassName the binary name of the class
			 * @param {Function} type class to record
			 * @return the recored class
			 */
			addClass : function addClass(qualifiedClassName, type) {
				if (type == null) {
					return null;
				}
				if (this.classes[qualifiedClassName] == null) {
					this.classes[qualifiedClassName] = type;
				}
				return type;
			},
			/**
			 * Record every loaded package with this linker.
			 *
			 * @param {Package} pkg the Package to add
			 * @return the recorded package
			 */
			addPackage : function addPackage(pkg) {
				if (pkg == null) {
					return null;
				}
				var path = pkg.getPath();
				if (this.packages[path] == null) {
					this.packages[path] = pkg;
					this.addClassPath(path);
				}
				return pkg;
			},
			/**
			 * Add the specified class path on this Linker
			 *
			 * @param {String} path the new path to add
			 * @return the added path
			 */
			addClassPath : function addClassPath(path) {
				if (ArrayUtil.indexOf(this.classPaths, path) == -1) {
					this.classPaths.push(this instanceof SystemClassLinker ? Linker.syspath(path) : Linker.ipath(path));
				}
				return path;
			},
			/**
			 * Test if this linker id fully created
			 *
			 * @return true otherwise false
			 */
			checkCreateClassLinker : function checkCreateClassLinker() {
				return this.created;
			},
			/**
			 * Find a class loaded by the bootstrap class loader;
			 * or return null if not found.
			 *
			 * @param {String} qualifiedClassName the binary name of the class
			 * @return the class loaded otherwise null
			 */
			findBootstrapClass : function findBootstrapClass(qualifiedClassName) {
				if (this instanceof SystemClassLinker) {
					return this.classes[qualifiedClassName];
				}
				var scl = Linker.getSystemClassLinker();
				return scl.findBootstrapClass(qualifiedClassName);
			},
			/**
			 * Returns a class loaded by the bootstrap class loader;
			 * or return null if not found.
			 *
			 * @param {String} qualifiedClassName the binary name of the class
			 * @return the class loaded otherwise null
			 */
			findBootstrapClassOrNull : function findBootstrapClassOrNull(qualifiedClassName) {
				if (!Linker.checkName(qualifiedClassName)) {
					return null;
				}
				return this.findBootstrapClass(qualifiedClassName);
			},
			/**
			 * Finds the class with the specified binary name.
			 * This method should be overridden by class loader implementations that
			 * follow the delegation model for loading classes, and will be invoked by
			 * the <tt>loadClass method after checking the
			 * parent class loader for the requested class.
			 *
			 * @param  {String} qualifiedClassName The binary nameof the class
			 * @return  The resulting <tt>Class</tt> object
			 */
			findClass : function findClass(qualifiedClassName) {
				//abstract method
				return null;
			},
			/**
			 * Returns the absolute path name of a native library.  The Shinobi invokes
			 * this method to locate the native libraries that belong to classes loaded
			 * with this class linker. If this method returns <tt>null</tt>, the Shinobi
			 * searches the library along the path specified as the
			 * "<tt>project.library.path</tt>" property.  </p>
			 *
			 * @param  {String} libname The library name
			 * @return The absolute path of the native library
			 */
			findLibrary : function findLibrary(libname) {
				if (this instanceof SystemClassLinker) {
					return this.nativeLibraries[libname]["path"];
				}
				var scl = Linker.getSystemClassLinker();
				return scl.findLibrary(libname);
			},
			/**
			 * Returns the class with the given binary name if this
			 * loader has been recorded by the Shinobi as an initiating loader of a
			 * class with that <a href="#name">binary name</a>.  Otherwise
			 * <tt>null</tt> is returned.  </p>
			 *
			 * @param  {String} qualifiedClassName binary name of the class
			 * @return  The <tt>Class</tt> object, or <tt>null</tt> if the class has
			 *          not been loaded
			 */
			findLoadedClass : function findLoadedClass(qualifiedClassName) {
				if (!Linker.checkName(name)) {
					return null;
				}
				if (this instanceof SystemClassLinker) {
					return this.findBootstrapClass(qualifiedClassName);
				}
				var c = this.classes[qualifiedClassName];
				if (c == null && this.parent != null) {
					c = this.parent.findLoadedClass(qualifiedClassName);
				}
				return c;
			},
			/**
			 * Finds a class with the specified binary name, loading it if necessary.
			 * <p> This method loads the class through the system class linker.
			 * The <tt>Class</tt> object returned might have more than one <tt>Linker</tt>
			 * associated with it. Subclasses of <tt>Linker</tt> need not usually
			 * invoke this method, because most class linkers need to override just
			 * findClass method.
			 * </p>
			 *
			 * @param  qualifiedClassName binary name of the class
			 * @return  The <tt>Class</tt> object for the specified <tt>name</tt>
			 */
			findSystemClass : function findSystemClass(qualifiedClassName) {
				var system = this.getSystemClassLinker();
				if (system != null) {
					if (!Linker.checkName(qualifiedClassName)) {
						throw new ReferenceError("ClassNotFoundException " + qualifiedClassName);
					}
					var cls = system.findBootstrapClass(qualifiedClassName);
					if (cls == null) {
						cls = system.loadClass(qualifiedClassName);
					}
				} else {
					throw new ReferenceError("ClassNotFoundException " + qualifiedClassName);
				}
				return cls;
			},
			/**
			 * Get the Linker of the specified obj
			 *
			 * @param {Object} obj the type to introspec
			 * @return the Linker of the specified object
			 */
			getCaller : function getCaller(obj) {
				return Linker.getCallerClassLinker(obj);
			},
			/**
			 * Returns a <tt>Package</tt> that has been defined by this class loader
			 * or any of its ancestors.  </p>
			 *
			 * @param  {String} qualifiedClassName The package binary name
			 * @return  The <tt>Package</tt> corresponding to the given name, or
			 *          <tt>null</tt> if not found
			 */
			getPackage : function getPackage(qualifiedClassName) {
				var pkg = this.packages[qualifiedClassName];
				if (pkg == null && this.parent != null) {
					pkg = this.parent.getPackage(qualifiedClassName);
				}
				//if null try global resolution
				return pkg || Type.getTypeByName(qualifiedClassName);
			},
			/**
			 * Returns all of the <tt>Packages</tt> defined by this class linker and
			 * its ancestors.
			 *
			 * @return  The array of <tt>Package</tt> objects defined by this
			 *          <tt>Linker</tt>
			 */
			getPackages : function getPackages(pkgs) {
				var p, pkgs = pkgs || {};
				for (p in this.packages) {
					pkgs[p] = this.packages[p];
				}
				if (this.parent != null) {
					pkgs = this.parent.getPackages(pkgs);
				}
				return pkgs;
			},
			/**
			 * Returns the parent class linker for delegation. Some implementations may
			 * use <tt>null</tt> to represent the bootstrap class loader. This method
			 * will return <tt>null</tt> in such implementations if this class linker's
			 * parent is the bootstrap class loader.
			 *
			 * @return  The parent <tt>Linker</tt>
			 */
			getParent : function getParent() {
				return this.parent;
			},
			/**
			 * Test if the specified class exist on this linker
			 *
			 * @param {String} qualifiedClassName the binary name of the specified
			 * 					class
			 * @return the specified class object otherwise null
			 */
			hasClass : function hasClass(qualifiedClassName) {
				var found = this.classes[qualifiedClassName] != null;
				if (!found && this.parent != null) {
					found = this.parent.hasClass(qualifiedClassName);
				}
				return found;
			},
			/**
			 * Test if the specified package exist on this linker
			 *
			 * @param {String} qualifiedClassName the binary name of the specified
			 * 					package
			 * @return the specified package object otherwise null
			 */
			hasPackage : function hasPackage(qualifiedClassName) {
				var found = this.packages[qualifiedClassName] != null;
				if (!found && this.parent != null) {
					found = this.parent.hasPackage(qualifiedClassName);
				}
				return found;
			},
			/**
			 * Returns true if the specified class linker can be found in this class
			 * linker's delegation chain.
			 *
			 * @param {Linker} cl the Linker to test
			 * @return true otherwise false
			 */
			isAncestor : function isAncestor(cl) {
				var acl = this;
				do {
					acl = acl.parent;
					if (cl == acl) {
						return true;
					}
				} while (acl != null);
				return false;
			},
			/**
			 * Loads the class with the specified binary name.  The
			 * default implementation of this method searches for classes in the
			 * following order:
			 * <p><ol>
			 *   <li><p> Invoke findLoadedClass(String) to check if the class
			 *   has already been loaded.  </p></li>
			 *   <li><p> Invoke the <tt>loadClass</tt>} method on the parent class
			 * 		linker.  If the parent is <tt>null</tt> the class
			 *   linker built-in to the Shinobi is used, instead.  </p></li>
			 *   <li><p> Invoke the <tt>findClass(String)<tt> method to find with
			 * 	 the user defined class resolution.  </p></li>
			 * </ol>
			 * <p> If the class was not found using the above steps, and the
			 * <tt>resolve</tt> flag is true, this method will then invoke the
			 * includes(String, Function, Object) method. The resulting <tt>Class</tt>
			 * object is returned.
			 * <p> Subclasses of <tt>Linker</tt> are encouraged to override
			 * #findClass(String), rather than this method.  </p>
			 *
			 * @param {String} qualifiedClassName The binary name of the class
			 * @param {Function} callback the completion listener
			 * @param {Object} namespace the named scope
			 * @param {Boolean} resolve If <tt>true</tt> then resolve the class with
			 * 					file inclusion
			 * @return  The resulting <tt>Class</tt> object
			 */
			loadClass : function loadClass(qualifiedClassName, callback, namespace, resolve) {
				if (resolve == undefined) {
					resolve = false;
				}
				// First, check if the class has already been loaded
				var c = this.findLoadedClass(qualifiedClassName);
				if (c == null) {
					if (this.parent != null) {
						c = this.parent.loadClass(qualifiedClassName, callback, namespace, false);
					} else {
						c = this.findBootstrapClass(qualifiedClassName);
					}
					if (c == null) {
						// If still not found, then invoke findClass in order
						// to find the class.
						c = this.findClass(name, namespace);
					}
					if (c == null && resolve) {
						if (this instanceof SystemClassLinker) {
							c = Linker.includes(qualifiedClassName, callback, namespace);
						} else {
							var scl = Linker.getSystemClassLinker();
							c = scl.loadClass(qualifiedClassName, callback, namespace, resolve);
						}
					}
					c = this.addClass(qualifiedClassName, c);
				}
				return c;
			},
			statics : {
				extractPackageComponents : function extractPackageComponents(qualifiedPackageName) {
					var dir, parts, i, ns;
					if (qualifiedPackageName.indexOf("-")) {
						parts = qualifiedPackageName.split("-");
						dir = parts[0];
						qualifiedPackageName = parts[1];
					}
					return {
						dir : dir || "",
						path : qualifiedPackageName
					};
				},
				/**
				 * Test if the name has the potential to be a valid binary name
				 *
				 * @param {String} name the identifier to test
				 * @return true if the name is null or has the potential to be a valid
				 * 			binary name
				 */
				checkName : function checkName(name) {
					if ((name == null) || (name.length == 0)) {
						return true;
					}
					if ((name.indexOf('/') != -1) || (name.charAt(0) == '[')) {
						return false;
					}
					return true;
				},
				/**
				 * Cross browser safe JSON parsing illegal JSON must stops here
				 *
				 * @param {String} json
				 */
				createJsonDocument : function createJsonDocument(json) {
					// taken from http://json.org/json2.js
					if (JSON && typeof JSON.parse == "function") {
						// true if native JSON exists and supports non-standard JSON
						if (Linker.supportJson) {
							// Case 1 : native JSON is here but supports illegal strings
							if (!Linker.testJson(json)) {
								//"Bad JSON string.";
								return null;
							}
							return JSON.parse(json);
						} else {
							// Case 2: native JSON is here , and does not support
							//illegal strings this will throw on illegal strings
							try {
								return JSON.parse(json);
							} catch(e) {
							}
							return null;
						}
					}
					// Case 3: there is no native JSON present
					if (!Linker.testJson(data)) {
						return null;
					}
					return (new Function("return " + json))();
				},
				/**
				 *
				 */
				createMSXMLDocumentObject : function createMSXMLDocumentObject() {
					var Ao = window["ActiveXObject"];
					if (Ao) {
						var progIDs = ["Msxml2.DOMDocument.6.0", "Msxml2.DOMDocument.5.0", "Msxml2.DOMDocument.4.0", "Msxml2.DOMDocument.3.0", "MSXML2.DOMDocument", "MSXML.DOMDocument"];
						var len = progIDs.length;
						while (len--) {
							try {
								return new Ao(progIDs[len]);
							} catch(e) {
								continue;
							};
						}
					}
					return null;
				},
				/**
				 *
				 * @param {String} mame
				 */
				createXmlDocument : function createXmlDocument(mame) {
					if (!mame) {
						mame = "";
					}
					var xmlDoc = Linker.createMSXMLDocumentObject();
					if (xmlDoc) {
						if (mame) {
							var rootNode = xmlDoc.createElement(mame);
							xmlDoc.appendChild(rootNode);
						}
					} else {
						if (document.implementation.createDocument) {
							xmlDoc = document.implementation.createDocument("", mame, null);
						}
					}
					return xmlDoc;
				},
				/**
				 * Test the existence of the specified url
				 *
				 * @param {Object} url the file to test
				 * @return true otherwise false
				 */
				fileExist : function fileExist(url) {
					var req = Linker.getXMLHttpRequest();
					if (!req) {
						throw new Error('XMLHttpRequest not supported');
					}
					try {
						// HEAD Results are usually shorter (faster) than GET
						req.open('HEAD', url, false);
						req.send(null);
						if (req.status == 0 || req.status == 200) {
							return true;
						}
					} catch(e) {
					}
					return false;
				},
				/**
				 * Invoked in the Shinobi class linking code.
				 *
				 * @param {Linker} loader
				 * @param {String} name
				 * @return
				 */
				findNative : function findNative(loader, name) {
					var p, libs = loader != null ? loader.nativeLibraries : Linker.INCLUDE_LIB;
					for (p in libs) {
						if (p == name) {
							return libs[p]["lib"];
						}
					}
					return null;
				},
				/**
				 * Get the base name of the specified path
				 *
				 * @param {Object} path the file name
				 * @param {Object} suffix the optional prefix
				 * @return the path base name
				 */
				getBasename : function getBasename(path, suffix) {
					suffix = suffix || ".js";
					var b = path.replace(/^.*[\/\\]/g, '');
					if ( typeof (suffix) == 'string' && b.substr(b.length - suffix.length) == suffix) {
						b = b.substr(0, b.length - suffix.length);
					}
					return b;
				},
				/**
				 * Returns the system linking include paths
				 *
				 * @return the system linking class paths
				 */
				getBootstrapClassPath : function getBootstrapClassPath() {
					return Linker.INCLUDE_SYSTEM_PATHS;
				},
				/**
				 * Returns the invoker's class linker, or null if none.
				 * NOTE: This must always be invoked when there is exactly one intervening
				 * frame from the core libraries on the stack between this method's
				 * invocation and the desired invoker.
				 *
				 * @param {Object} invoker the class invoker
				 * @return the linker of the specified invoker
				 */
				getCallerClassLinker : function getCallerClassLinker(invoker) {
					if ( typeof invoker != "function") {
						invoker = invoker.constructor;
					}
					return Linker.scl.getLinker(invoker);
				},
				/**
				 * Get the class path of the given class
				 *
				 * @param {String} qualifiedClassName the fully qualified clas name
				 * @param {String} ext optional file extension
				 * @return the class path of the specified class
				 */
				getClassPath : function getClassPath(qualifiedClassName, ext) {
					ext = ext || ".js";
					var file = "", filename = qualifiedClassName.replace(/\./g, "/");
					var index1 = filename.indexOf("<");
					var index2 = filename.indexOf(">");
					var extensionIndex = filename.indexOf(ext);
					if (index1 != -1 && index2 != -1) {
						file = filename.substring(index1 + 1, filename.length)
						file = file.substring(0, index2 - 1);
						filename = file;
					}
					if (extensionIndex == -1) {
						filename += ext;
					}
					return filename;
				},
				/**
				 * Returns the linking include paths
				 *
				 * @return the linking class path
				 */
				getIncludeClassPath : function getBootstrapClassPath() {
					return Linker.INCLUDE_PATHS;
				},
				/**
				 * Returns the linking packages
				 *
				 * @return the linking packages
				 */
				getPackage : function getPackage(name) {
					var p, pkg, pkgs = Linker.PACKAGES;
					for (p in pkgs) {
						pkg = pkgs[p];
						if (p == name) {
							return pkg;
						}
						pkg = pkg.getPackage(name);
						if (pkg != null) {
							return pkg;
						}
					}
					return null;
				},
				/**
				 * Returns the linking packages
				 *
				 * @return the linking packages
				 */
				getPackages : function getPackages() {
					return Linker.PACKAGES;
				},
				/**
				 * Returns the system class linker for delegation.  This is the default
				 * delegation parent for new <tt>Class Linker</tt> instances, and is
				 * typically the class linker used to start the application.
				 *
				 * <p> This method is first invoked early in the runtime's startup
				 * sequence, at which point it creates the system class linker and
				 * sets it as the context class linker of the invoking <tt>Package</tt>.
				 *
				 * <p> The default system class linker is an implementation-dependent
				 * instance of this class.
				 *
				 * <p> If the system property "<tt>system.class.linker</tt>"
				 * is defined when this method is first invoked then the value of that
				 * property is taken to be the name of a class that will be returned
				 * as the system class linker. The class is loaded using the default
				 * system class linker and must define a public constructor that takes
				 * a single parameter of type <tt>Linker</tt> which is used as the
				 * delegation parent. An instance is then created using this constructor
				 * with the default system class linker as the parameter.
				 * The resulting class linker is defined to be the system class linker.
				 *
				 * @return  The system <tt>Linker</tt> for delegation, or
				 *          <tt>null</tt> if none
				 */
				getSystemClassLinker : function getSystemClassLinker() {
					var scl = Linker.initSystemClassLinker();
					if (scl == null) {
						return null;
					}
					var ccl = Linker.getCallerClassLinker(Linker);
					if (ccl != null && ccl != scl && !scl.isAncestor(ccl)) {

					}
					return scl;
				},
				/**
				 * Get an instance of a XMLHttpRequest
				 *
				 * @return an instance of XMLHttpRequest
				 */
				getXMLHttpRequest : function getXMLHttpRequest() {
					var xhr, ctr;
					var win = window;
					if (Type.ownedProperty(win, "XMLHttpRequest")) {
						ctr = win["XMLHttpRequest"];
						xhr = new ctr();
					} else if (Type.ownedProperty(win, "ActiveXObject")) {
						var names = ["Microsoft.XMLHTTP", "Msxml2.XMLHTTP", "Msxml2.XMLHTTP.3.0", "Msxml2.XMLHTTP.6.0"];
						var len = names.length;
						while (len--) {
							try {
								xhr = new ctr(names[len])
							} catch(e) {
								continue;
							}
						}
					}
					return xhr;
				},
				/**
				 * Specifies that short_filename is to be used as an alias for long_filename.
				 * The ialias pragma performs simple string matching on the filenames;
				 * no other filename validation is performed. no aliasing (substitution) is
				 * performed, since the .js file strings do not match exactly. You can use
				 * the ialias pragma to map any .js filename to another.
				 *
				 * @param {String} long_filename the file name to map
				 * @param {String} short_filename the new file name after mapping
				 * @return true if the specified long_filename has been mapped with the specified
				 * 				short_filename otherwise false;
				 */
				ialias : function ialias(long_filename, short_filename) {
					if (!Type.ownedProperty(Linker.INCLUDE_ALIASES, short_filename)) {
						Linker.INCLUDE_ALIASES[short_filename] = long_filename;
						return true;
					}
					return false;
				},
				/**
				 * The includes directive tells the Linker to treat the contents of a
				 * specified file as if those contents had appeared in the source program at
				 * the point where the directive appears.
				 * The preprocessor searches for include files in the following order:
				 * 1. In the same directory as the file that contains the include_ statement.
				 * 2. In the directories of any previously opened include files in the reverse
				 * order in which they were opened. The search starts from the directory of
				 * the include file that was opened last and continues through the directory
				 * of the include file that was opened first.
				 * 3. Along the path specified by each /I compiler option.
				 * 4. Along the paths specified by the INCLUDE environment variable.
				 * The preprocessor stops searching as soon as it finds a file with the given
				 * name. If you specify a complete, unambiguous path specification for the
				 * include file between double quotation marks (" "), the preprocessor searches
				 * only that path specification and ignores the standard directories.
				 *
				 * @param {String} filename file to include
				 * @param {Function} callback the completion listener
				 * @param {Object} namespace the named scope
				 * @return the compiled object
				 */
				includes : function includes(filenames, callback, namespace) {
					var classes = filenames.split(",");
					var i, len = classes.length;
					var tmp = [];
					for ( i = 0; i < len; i++) {
						tmp.push(Linker.loadClass(classes[i], callback, namespace));
					}
					return tmp.length > 1 ? tmp : tmp[0];
				},
				/**
				 * Initialize the Linker paths system
				 *
				 * @param {String} ldpath the paths
				 * @return the path list
				 */
				initializePath : function initializePath(ldpath) {
					var ps = ";";
					var i, j, n, ldlen = ldpath.length;
					// Count the separators in the path
					i = ldpath.indexOf(ps);
					n = 0;
					while (i >= 0) {
						n++;
						i = ldpath.indexOf(ps, i + 1);
					}
					// allocate the array of paths - n :'s = n + 1 path elements
					var paths = new Array(n + 1);
					// Fill the array with paths from the ldpath
					n = i = 0;
					j = ldpath.indexOf(ps);
					while (j >= 0) {
						if (j - i > 0) {
							paths[n++] = ldpath.substring(i, j);
						} else if (j - i == 0) {
							paths[n++] = ".";
						}
						i = j + 1;
						j = ldpath.indexOf(ps, i);
					}
					paths[n] = ldpath.substring(i, ldlen);
					return paths;
				},
				/**
				 * Initialize the default system class Linker
				 *
				 * @return the default class Linker
				 */
				initSystemClassLinker : function initSystemClassLinker() {
					if (!Linker.sclSet) {
						if (Linker.scl != null) {
							throw new Error("IllegalStateException recursive invocation");
						}
						Linker.scl = new SystemClassLinker();
						Linker.sclSet = Linker.scl != null;
					}
					return Linker.scl;
				},
				/**
				 * Add the specified path to the Linker include file search path
				 *
				 * @param {String} path the new include search path
				 * @return the inserted path
				 */
				ipath : function ipath(path) {
					var processorPaths = Linker.INCLUDE_PATHS.split(";");
					var locdir = Linker.LOCATION_HREF.slice(0, Linker.LOCATION_HREF.lastIndexOf("/") + 1);
					var p = locdir + path, len = processorPaths.length;
					while(len--) {
						if (processorPaths[len] == p) {
							return p;
						}
					}	
					p = Linker.INCLUDE_PATHS != "" ? ";" + p : p;
					Linker.INCLUDE_PATHS += p;
					return p;
				},
				/**
				 * Retrieve the longest common string sequence
				 *
				 * @param {String} lcstest first string
				 * @param {String} lcstarget second string
				 * @return  the longest common string sequence
				 */
				lcs : function lcs(lcstest, lcstarget) {
					var matchfound = 0
					var lsclen = lcstest.length
					for ( lcsi = 0; lcsi < lcstest.length; lcsi++) {
						lscos = 0
						for ( lcsj = 0; lcsj < lcsi + 1; lcsj++) {
							re = new RegExp("(?:.{" + lscos + "})(.{" + lsclen + "})", "i");
							temp = re.test(lcstest);
							re = new RegExp("(" + RegExp.$1 + ")", "i");
							if (re.test(lcstarget)) {
								matchfound = 1;
								result = RegExp.$1;
								break;
							}
							lscos = lscos + 1;
						}
						if (matchfound == 1) {
							return result;
						}
						lsclen = lsclen - 1;
					}
					result = "";
					return result;
				},
				/**
				 * Get the content of the specified file
				 *
				 * @param {Object} url file content
				 * @return the content of the file otherwise null
				 */
				load : function load(url) {
					var req = Linker.getXMLHttpRequest();
					if (!req) {
						throw new Error('XMLHttpRequest not supported');
					}
					try {
						// HEAD Results are usually shorter (faster) than GET
						req.open('GET', url, false);
						req.send(null);
						if (req.status == 0 || req.status == 200) {
							return req.responseText;
						}
					} catch(e) {
					}
					return null;
				},
				/**
				 *
				 * @param {Object} xml
				 */
				loadDocument : function loadDocument(xml) {
					if ( xml instanceof Document) {
						return xml;
					} else if ( typeof xml == "string") {
						// if responseXML is not valid, try to create the XML document from the responseText property
						var xmlDoc;
						if (window["DOMParser"]) {
							var parser = new window["DOMParser"]();
							try {
								xmlDoc = parser.parseFromString(xml, "text/xml");
							} catch (e) {
								return null;
							};
						} else {
							xmlDoc = Linker.createMSXMLDocumentObject();
							if (!xmlDoc) {
								return null;
							}
							xmlDoc.loadXML(xml);
						}
						//document.documentElement.setAttributeNS('http://www.w3.org/XML/1998/namespace', 'xml:lang', 'en-au-tas');
						// ok, the XML document is valid
						return xmlDoc;
					}
					return null;
				},
				/**
				 * Evaluates or executes an argument. If the argument is one or more
				 * JavaScript statements, loadByte() executes the statements.
				 *
				 * @param {String} expression A JavaScript expression, variable, statement,
				 * 					or sequence of statements
				 * @return the evaluated expression
				 */
				loadByte : function loadByte(expression) {
					return eval(expression);
				},
				/**
				 * Loads the class with the specified file name.
				 *
				 * @param {String} filename the location of the class
				 * @param {Function} callback the completion listener
				 * @param {Object} namespace the named scope
				 * @return the class that was not found otherwise null
				 */
				loadClass : function loadClass(qualifiedClassName, callback, namespace) {
					//0-search an object on a specified namespace
					var type = Type.getTypeByName(qualifiedClassName, namespace);
					if (type) {
						return type;
					}
					var filename = Linker.getClassPath(qualifiedClassName);
					if (Linker.INCLUDE_ALIASES[filename]) {
						filename = Linker.INCLUDE_ALIASES[filename];
					}
					if (Linker.INCLUDE_CLASSES[filename]) {
						return Linker.INCLUDE_CLASSES[filename];
					} else {
						//1-search the same directory as the file that contains the includes
						//statement.
						if (Linker.fileExist(Linker.LOCATION_HREF + filename)) {
							filename = Linker.LOCATION_HREF + filename;
							return Linker.loadFile(filename, callback);
						}
						//2-search the directories of any previously opened include files
						//in the reverse order in which they were opened.
						//3- Along the path specified by each ipath option.
						filename = Linker.resolveIncludePathsDirectories(filename) || Linker.resolveOpenedDirectories(filename);
						if (filename) {
							return Linker.loadFile(filename, callback);
						}
					}
					return null;
				},
				/**
				 *
				 * @param {Object} path
				 * @param {Object} callback
				 * @return
				 */
				loadFile : function loadFile(path, callback) {
					if (!Linker.INCLUDE_CLASSES[path]) {
						var source = Linker.load(path);
						if (source) {
							var dirs = path.split('/');
							if (dirs.length > 1) {
								Linker.OPENED_DIRECTORIES.push(dirs.splice(0, dirs.length - 1).join("/"));
							}
							Linker.INCLUDE_FILES.push(path);
							Linker.INCLUDE_CLASSES[path] = Linker.loadByte(source);
						}
					}
					return callback ? callback(Linker.INCLUDE_CLASSES[path]) : Linker.INCLUDE_CLASSES[path];
				},
				/**
				 *
				 * @param {String} path
				 */
				loadJson : function loadJson(path) {
					var json = Linker.load(path);
					if (json) {
						return Linker.createJsonDocument(json);
					}
					return null;
				},
				/**
				 * Invoked in Shinobi class to implement load and loadLibrary.
				 *
				 * @param {Function} fromClass
				 * @param {String} name
				 * @param {Boolean} isAbsolute
				 * @param {Function} callback
				 * @param {Object} namespace
				 * @return the loaded library
				 */
				loadLibrary : function loadLibrary(fromClass, name, isAbsolute, callback, namespace) {
					var loader = (fromClass == null) ? null : Linker.getClassLinker(fromClass);
					if (Linker.INCLUDE_SYSTEM_PATHS == null || Linker.INCLUDE_SYSTEM_PATHS == "") {
						//"project.library.path"
						//"project.boot.library.path"
						Linker.INCLUDE_PATHS = Linker.initializePath(Linker.LOCATION_HREF);
						Linker.INCLUDE_SYSTEM_PATHS = Linker.initializePath("project.boot.library.path");
					}
					var lib, i;
					if (isAbsolute) {
						lib = Linker.loadLibraryModule(name, callback, namespace);
						if (lib) {
							return lib;
						} else {
							throw new ReferenceError("UnsatisfiedLinkError Can't load library: " + name);
						}
					}
					if (loader != null) {
						var libfilename = loader.findLibrary(name);
						if (libfilename != null) {
							var libfile = libfilename;
							if (!Linker.isAbsolute(libfile)) {
								throw new ReferenceError("Linker.findLibrary failed to return an absolute path: " + libfilename);
							}
							if (lib) {
								Linker.mapLibraryName(name, libfile);
								return lib;
							} else {
								throw new ReferenceError("UnsatisfiedLinkError Can't load library: " + libfilename);
							}
						}
					}
					var sys_paths = Linker.INCLUDE_SYSTEM_PATHS.split(";");
					for ( i = 0; i < sys_paths.length; i++) {
						libfile = sys_paths[i];
						lib = Linker.loadLibraryModule(libfile, callback, namespace);
						if (lib) {
							return lib;
						} else {
							throw new ReferenceError("UnsatisfiedLinkError Can't load library: " + libfilename);
						}
						Linker.mapLibraryName(name, libfile);
					}
					if (loader != null) {
						var inc_paths = Linker.INCLUDE_PATHS.split(";");
						for ( i = 0; i < inc_paths.length; i++) {
							libfile = inc_paths[i];
							lib = Linker.loadClassFile(libfile, callback, namespace);
							if (lib) {
								return lib;
							} else {
								throw new ReferenceError("UnsatisfiedLinkError Can't load library: " + libfilename);
							}
						}
					}
					throw new ReferenceError("UnsatisfiedLinkError no " + name + " in project.library.path");
				},
				/**
				 * The loadModule directive tells the Linker to incorporate information
				 * from a type library. The content of the type library is converted
				 * into .js classes.
				 * The linker searches for include files in the following order:
				 * 1. In the same directory as the file that contains the loadModule
				 * statement.
				 * 2. In the directories of any previously opened include files in the
				 * reverse order in which they were opened. The search starts from the
				 * directory of the include file that was opened last and continues
				 * through the directory of the include file that was opened first.
				 * 3. Along the path specified by each /I compiler option.
				 * 4. Along the paths specified by the INCLUDE environment variable.
				 * The preprocessor stops searching as soon as it finds a file with
				 * the given name. If you specify a complete, unambiguous path
				 * specification for the include file between double quotation marks
				 * (" "), the linker searches only that path specification and ignores
				 * the standard directories.
				 *
				 * @param {String} filename file to include allows you to specify which type of library
				 * 			is required. filename can be precede by one of the following keys:
				 * 			-The progid of a control in the type library. Note that 'progid:'
				 * 			key must precede each progid.
				 * 			-The library ID of the type library. Note that 'libid:' must precede
				 * 			each library ID.
				 * 			-If you do not specify version, the rules that are applied to 'progid:'
				 * 			are also applied to 'libid:'.
				 * @param {Function} callback
				 * @param {Object} namespace
				 * @return the loaded library otherwise null
				 */
				loadModule : function loadModule(filename, callback, namespace) {
					var parts = filename.split(" ");
					var hasProgid = false;
					var hasLibid = false;
					var hasVersion = false;
					var len = parts.length;
					var progidIndex = -1;
					var libidIndex = -1;
					var versionIndex = -1;
					while (len--) {
						if (parts[len].indexOf("progid:") != -1) {
							hasProgid = true;
							progidIndex = len;
						} else if (parts[len].indexOf("libid:") != -1) {
							hasLibid = true;
							libidIndex = len;
						} else if (parts[len].indexOf("version:") != -1) {
							hasVersion = true;
							versionIndex = len;
						}
					}
					//no id return
					if (!hasLibid) {
						return null;
					}
					var file = parts[parts.length - 1];
					var libparts = parts[libidIndex].split("libid:");
					//libid form <com.mylib::Toto>|<com.mylib.Toto>|<Toto>
					var libname = libparts[1].replace("::", ".");
					if (Type.ownedProperty(Linker.INCLUDE_LIB, libname)) {
						return Linker.INCLUDE_LIB[libname]["lib"];
					}
					var included = Linker.includes(file, callback, namespace);
					if (included) {
						Linker.INCLUDE_LIB[libname] = {};
						if (hasProgid) {
							//programatic id <Vendor>.<Component>.<Version>
							var progparts = parts[progidIndex].split("progid:");
							Linker.INCLUDE_LIB[libname]["progid"] = progparts[progparts.length - 1];
						}
						if (hasVersion) {
							//version form <Major>.<Minor>.<Revision>
							var versionparts = parts[versionIndex].split("version:");
							Linker.INCLUDE_LIB[libname]["version"] = versionparts[versionparts.length - 1];
						}
						var libns = libname.split(".");
						var i, len = libns.length;
						var ns = window;
						for ( i = 0; i < len; i++) {
							if (!ns[libns[i]]) {
								return null;
							}
							ns = ns[libns[i]];
						}
						return Linker.INCLUDE_LIB[libname]["lib"] = ns;
					}
					return null;
				},
				/**
				 * Get the content of the specified file
				 *
				 * @param {Object} url file content
				 * @return the content of the file otherwise null
				 */
				loadXml : function loadXml(url) {
					var xml = Linker.load(url);
					if (xml != null) {
						return Linker.loadDocument(xml);
					}
					return null;
				},
				/**
				 * Import an external module. External modules are a mechanism to add
				 * extensions (written in javascript) to Shinobi. Extending Shinobi
				 * using an external module requires creating and adding it to an
				 * existing linking set using the modules method to prodice a new linking
				 * set which contains the extension. A module is a piece of code which
				 * defines extra Shinobi objects, symbols and functions. Together with
				 * Linker which describes how to add the module to an existing Shinobi
				 * Application, it comprises a module set. More formally, module set
				 * is a directory containing the modules files. A module name must consist
				 * of the characters A-Z, a-z, _, 0-9. The module name “shinobi” is
				 * reserved.
				 *
				 * @param {Object} filenames all comma separeted module names.
				 * @param {Object} callback the completion listener
				 * @param {Object} namespace a named scope
				 * @return The return value is a new reference to the imported module
				 * 			or top-level package. the return value when a submodule
				 * 			of a package was requested is normally the top-level
				 * 			package
				 */
				modules : function modules(filenames, callback, namespace) {
					var classes = filenames.split(",");
					var i, len = classes.length;
					var tmp = [];
					for ( i = 0; i < len; i++) {
						tmp.push(Linker.loadModule(classes[i], callback, namespace));
					}
					return tmp.length > 1 ? tmp : tmp[0];
				},
				/**
				 *
				 * @param {String} dir
				 * @param {String} path
				 * @param {String} filename
				 */
				parsePath : function parsePath(dir, path, filename) {
					if (path) {
						var index = path.length > filename.length ? path.indexOf(filename) : filename.indexOf(path);
						if (index != -1) {
							path = dir.substring(0, dir.indexOf(path)) + filename;
						}
					} else {
						path = dir + filename;
					}
					return path;
				},
				/**
				 * Resolve the specified filename has a known absolute include file.
				 * Search in all include paths.
				 *
				 * @param {Object} filename the path to resolve
				 * @param {Boolean} uselcs
				 * @return the resolved path otherwise null
				 */
				resolveIncludePathsDirectories : function resolveIncludePathsDirectories(filename, uselcs) {
					//search Along the path specified by each ipath option.
					var paths = Linker.INCLUDE_SYSTEM_PATHS.split(";").concat(Linker.INCLUDE_PATHS.split(";"));
					var index, dir, path = "", len = paths.length;
					while (len--) {
						dir = paths[len];
						path = Linker.parsePath(dir, null, filename);
						path = Linker.setIncludeDir(path);
						if (path == null && uselcs) {
							path = Linker.lcs(dir, filename);
							path = Linker.parsePath(dir, path, filename);
							path = Linker.setIncludeDir(path);
						}
						if (path != null) {
							return path;
						}
					}
					return null;
				},
				/**
				 * Resolve the specified filename has a known absolute opened directory.
				 * Search in all opened paths.
				 *
				 * @param {Object} filename the path to resolve
				 * @return the resolved path otherwise null
				 */
				resolveOpenedDirectories : function resolveOpenedDirectories(filename, uselcs) {
					//search the directories of any previously opened include files
					//in the reverse order in which they were opened.
					var index, dir, qname, path = "", len = Linker.OPENED_DIRECTORIES.length;
					while (len--) {
						dir = Linker.OPENED_DIRECTORIES[len];
						path = Linker.parsePath(dir, null, filename);
						path = Linker.setIncludeFile(path);
						if (path == null && uselcs) {
							path = Linker.lcs(dir, filename);
							path = Linker.parsePath(dir, path, filename);
							path = Linker.setIncludeFile(path);
						}
						if (path != null) {
							return path;
						}
					}
					return null;
				},
				/**
				 *
				 * @param {String} path
				 * @return
				 */
				setIncludeFile : function setIncludeFile(path) {
					if (Linker.fileExist(path)) {
						Linker.INCLUDE_FILES.push(path);
						return path;
					}
					return null;
				},
				/**
				 *
				 * @param {String} path
				 * @return
				 */
				setIncludeDir : function setIncludeDir(path) {
					if (Linker.fileExist(path)) {
						Linker.INCLUDE_FILES.push(path);
						var dirs = path.split('/');
						if (dirs.length > 1) {
							Linker.OPENED_DIRECTORIES.push(dirs.splice(0, dirs.length - 1).join("/"));
						}
						return path;
					}
					return null;
				},
				/**
				 * Add the specified path to the Linker system include file search path
				 *
				 * @param {String} path the new system include search path
				 * @return the inserted path
				 */
				syspath : function syspath(path) {
					var processorPaths = Linker.INCLUDE_SYSTEM_PATHS.split(";");
					var locdir = Linker.LOCATION_HREF_DIRECTORY;
					var p = locdir + path, len = processorPaths.length;
					while(len--) {
						if (processorPaths[len] == p) {
							return p;
						}
					}
					p = Linker.INCLUDE_SYSTEM_PATHS != "" ? ";" + p : p;
					Linker.INCLUDE_SYSTEM_PATHS += p;				
					return p;
				},
				/**
				 *
				 * @param {String} json
				 */
				testJson : function testJson(json) {
					return /^[\],:{}\s]*$/.test(json.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, "@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, "]").replace(/(?:^|:|,)(?:\s*\[)+/g, ""));
				},
				//Main location
				LOCATION_HREF : window.location.href,
				//Main directory
				LOCATION_HREF_DIRECTORY : window.location.href.slice(0, window.location.href.lastIndexOf("/") + 1),
				NAVIGATOR : window.navigator,
				//inclusion alias
				INCLUDE_ALIASES : {},
				//inclusion files
				INCLUDE_FILES : [],
				//inclusion lib
				INCLUDE_LIB : {},
				//inclusion path
				INCLUDE_PATHS : "",
				//inclusion system path
				INCLUDE_SYSTEM_PATHS : "",
				//inclusion classes
				INCLUDE_CLASSES : {},
				//opened directories
				OPENED_DIRECTORIES : [],
				//all packages
				PACKAGES : {},
				//all linkers
				LINKERS : [],
				//The class linker for the system
				scl : null,
				//Set to true once the system class linker has been set
				sclSet : false,
				/**
				 *
				 */
				supportJson : function supportJson() {
					try {
						JSON.parse("{ a : 1 }");
						return true;
					} catch(e) {
					}
					return false;
				}()
			},
			//The classes loaded by this class linker. The only purpose of this table
			// is to keep the classes from being GC'ed until the loader is GC'ed.
			classes : {},
			//The packages defined in this class linker. Each package name is mapped
			//to its corresponding Package object.
			packages : {},
			//The parent class linker for delegation
			parent : null,
			//The class paths owened by the class Linker
			classPaths : [],
			//Native libraries associated with the class Linker
			nativeLibraries : {}

		},
		namespace : SHINOBI_NAMESPACE
	});

	/*****************************
	 *
	 * SYSTEMCLASSLINKER
	 *
	 ******************************/

	/**
	 * The system class linker
	 *
	 * @see Type
	 * @see Linker
	 * @author Aime Biendo
	 */
	var SystemClassLinker = Type.inherit({
		qname : "SystemClassLinker",
		superclass : Linker,
		subclass : {
			/**
			 * Create a new System class linker
			 */
			constructor : function SystemClassLinker() {
				SystemClassLinker.base.call(this);
			},
			/**
			 * Get the linker associated with the specified invoker class
			 *
			 * @param {Object} invoker the class
			 *@return the class invoker
			 */
			getLinker : function getLinker(invoker) {
				var linker, len = Linker.LINKERS.length;
				while (len--) {
					linker = Linker.LINKERS[len];
					if (linker.hasClass(invoker)) {
						return linker;
					}
				}
				var qname = "";
				if (invoker.slot != null) {
					qname = invoker.slot;
				} else {
					qname = Type.getClassName(invoker);
				}
				this.classes[qname] = invoker;
				return this;
			},
			statics : {
				/**
				 * Get the name of the current directory source file
				 *
				 * @param {Array} scripts the script element list
				 * @return The name of the current directory running script
				 */
				__DIR__ : function __DIR__(scripts) {
					var scripts = scripts || document.getElementsByTagName('script');
					if (scripts != null && scripts.length) {
						var script = scripts[scripts.length - 1].getAttribute("src");
						if (script != null) {
							return script.substring(0, script.lastIndexOf('/')) + '/';
						}
					}
					return null;
				},
				/**
				 * Get the name of the current source file
				 *
				 * @param {Array} scripts the script element list
				 * @return The name of the current running script
				 */
				__FILE__ : function __FILE__(scripts) {
					scripts = scripts || document.getElementsByTagName('script');
					if (scripts != null && scripts.length) {
						var parts, script = scripts[scripts.length - 1].getAttribute("src");
						if (script != null) {
							return script;
						}
					}
					return null;
				},
				/**
				 *
				 */
				__PARAMETERS__ : function __PARAMETERS__() {
					var parts, query, params, items, parameters = {}, script = SystemClassLinker.__FILE__();
					if (script.indexOf("?") != -1) {
						parts = script.split("?");
						query = parts[1];
						params = query.split("&");
						len = params.length;
						while (len--) {
							items = params[len].split("=");
							parameters[items[0]] = items[1];
						}
					}
					return parameters;
				},
				/**
				 * The current compilation time of the current source file. The time is a
				 * string literal of the form hh:mm:ss.
				 *
				 * @param {String} url an alternate file
				 * @return The current compilation time in the form hh:mm:ss.
				 */
				__TIME__ : function __TIME__(url) {
					var req = Linker.getXMLHttpRequest();
					if (!req) {
						throw new Error('XMLHttpRequest not supported');
					}
					try {
						req.open('GET', url || SystemClassLinker.__FILE__(), false);
						req.send(null);
						if (req.status == 0 || req.status == 200) {
							return new Date(req.getResponseHeader("Last-Modified"));
						}
					} catch(e) {
					}
					return null;
				},
				/**
				 * The date and time of the last modification of the current source file,
				 * expressed as a string literal in the form Ddd Mmm Date hh:mm:ss yyyy,
				 * where Ddd is the abbreviated day of the week and Date is an integer from
				 * 1 to 31.
				 *
				 * @param {String} url an alternate file
				 * @return The date and time of the last modification of the current source
				 * 			file
				 */
				__TIMESTAMP__ : function __TIMESTAMP__(url) {
					var req = Linker.getXMLHttpRequest();
					if (!req) {
						throw new Error('XMLHttpRequest not supported');
					}
					try {
						req.open('GET', url || SystemClassLinker.__FILE__(), false);
						req.send(null);
						if (req.status == 0 || req.status == 200) {
							return new Date(req.getResponseHeader("Last-Modified")).getTime() / 1000;
						}
					} catch(e) {
					}
					return null;
				}
			}
		},
		namespace : SHINOBI_NAMESPACE
	});

	/*****************************
	 *
	 * PROPERTIES
	 *
	 ******************************/

	/**
	 * The <code>Properties</code> class represents a persistent set of
	 * properties. The <code>Properties</code> can be saved to a stream
	 * or loaded from a stream. Each key and its corresponding value in
	 * the property list is a string.
	 * <p>
	 * A property list can contain another property list as its
	 * "defaults"; this second property list is searched if
	 * the property key is not found in the original property list.
	 * <p>
	 * @see Type
	 * @see Linker
	 * @author  Aime Biendo
	 */
	var Properties = Type.inherit({
		qname : "Properties",
		subclass : {
			/**
			 * Creates an empty property list with the specified defaults.
			 *
			 * @param {Object} defaults the defaults.
			 */
			constructor : function Properties(defaults) {
				if ( defaults instanceof Properties) {
					this.defaults = defaults;
					this.map = [];
				} else if ( defaults instanceof Array) {
					this.map = defaults;
				} else if ( typeof defaults == "object") {
					var p;
					this.map = [];
					for (p in defaults) {
						this.setProperty(p, defaults[p]);
					}
				} else {
					this.map = [];
				}
			},
			/**
			 * Clears this hashtable so that it contains no keys.
			 */
			clear : function clear() {
				this.map = [];
			},
			/**
			 * Creates a shallow copy of this hashtable. All the structure of the
			 * hashtable itself is copied, but the keys and values are not cloned.
			 * This is a relatively expensive operation.
			 *
			 * @return  a clone of the hashtable
			 */
			clone : function clone() {
				var t = new Properties();
				this.enumerte(t);
				return t;
			},
			/**
			 * Tests if the specified object is a key in this hashtable.
			 *
			 * @param {String} key possible key
			 * @return <code>true</code> if and only if the specified object
			 *          is a key in this hashtable, as determined by the
			 *          <tt>equals</tt> method; <code>false</code> otherwise.
			 */
			containsKey : function containsKey(key) {
				if (key == null) {
					throw new Error("NullPointerException");
				}
				var n = this.map.length;
				while (n--) {
					if (this.map[n].key == key) {
						return true;
					}
				}
				return false;
			},
			/**
			 * Tests if some key maps into the specified value in this hashtable.
			 *
			 * @param      {Object} value   a value to search for
			 * @return     <code>true</code> if and only if some key maps to the
			 *             <code>value</code> argument in this hashtable as
			 *             determined by the <tt>equals</tt> method;
			 *             <code>false</code> otherwise.
			 */
			contains : function containsValue(value) {
				if (value == null) {
					throw new Error("NullPointerException");
				}
				var n = this.map.length;
				while (n--) {
					if (this.map[n].value == value) {
						return true;
					}
				}
				return false;
			},
			/**
			 * Enumerate all the the values in this hashtable.
			 */
			elements : function elements(callback, scope) {
				this.map.forEach(function forEach(e, i, arr) {
					callback.apply(scope, [e.value]);
				}, scope);
			},
			/**
			 * Enumerates all key/value pairs in the specified hashtable.
			 *
			 * @param {Object} h the hashtable
			 */
			enumerate : function enumerate(h) {
				if (this.defaults != null) {
					this.defaults.enumerate(h);
				}
				map.forEach(function(e, i, arr) {
					if ( h instanceof Properties) {
						h.put(e.name, e.value);
					} else if ( h instanceof Array) {
						h.push(e.name, e.value);
					} else {
						h[e.name] = e.value;
					}
				});
			},
			/**
			 * Enumerates all key/value pairs in the specified hashtable
			 * and omits the property if the key or value is not a string.
			 *
			 * @param {Object} h the hashtable
			 */
			enumerateStringProperties : function enumerateStringProperties(h) {
				if (this.defaults != null) {
					this.defaults.enumerateStringProperties(h);
				}
				var k, v;
				map.forEach(function(e, i, arr) {
					k = e.name;
					v = e.value;
					if ( typeof k == "String" && typeof v == "string") {
						if ( h instanceof Properties) {
							h.put(k, v);
						} else if ( h instanceof Array) {
							h.push(e.name, e.value);
						} else {
							h[e.name] = e.value;
						}
					}
				});
			},
			/**
			 * Returns the value to which the specified key is mapped,
			 * or {@code null} if this map contains no mapping for the key.
			 *
			 * <p>More formally, if this map contains a mapping from a key
			 * {@code k} to a value {@code v} such that {@code (key.equals(k))},
			 * then this method returns {@code v}; otherwise it returns
			 * {@code null}.  (There can be at most one such mapping.)
			 *
			 * @param {Object} key the key whose associated value is to be returned
			 * @return the value to which the specified key is mapped, or
			 *         {@code null} if this map contains no mapping for the key
			 */
			get : function get(key) {
				var n = this.map.length;
				while (n--) {
					if (this.map[n].key == key) {
						return this.map[n].value;
					}
				}
				return null;
			},
			/**
			 * Searches for the property with the specified key in this property list.
			 * If the key is found in this property list, replace any numerical tokens in
			 * the property value with values passed in via the optionals parameters
			 *
			 * @param {String} key the key to be placed into this property list.
			 * @param {Array} vargs the values corresponding to <tt>value</tt> to replace.
			 * @return the previous value of the specified key in this property
			 *         list, or <code>null</code> if it did not have one.
			 */
			getDefaultProperty : function getDefaultProperty(key) {
				var parameters, len, value = this.getProperty(key);
				if (value != null) {
					parameters = Type.toArray(arguments).splice(1, arguments.length);
					len = parameters.lengh;
					while (len--) {
						value = value.split("{" + (len + 1) + "}").join(parameters[m]);
					}
				}
				return value;
			},
			/**
			 * Searches for the property with the specified key in this property list.
			 * If the key is not found in this property list, the default property list,
			 * and its defaults, recursively, are then checked. The method returns the
			 * default value argument if the property is not found.
			 *
			 * @param 	{String} key            the property key.
			 * @param   {String} defaultValue   a default value.
			 * @return  the value in this property list with the specified key value.
			 */
			getProperty : function getProperty(key, defaultValue) {
				var value, name = arguments[0];
				var n = this.map.length;
				while (n--) {
					if (this.map[n].name == key) {
						value = this.map[n].value;
						break;
					}
				}
				if (defaultValue != undefined) {
					return (value == null) ? defaultValue : value;
				}
				var sval = ( typeof value == "string") ? value : null;
				return ((sval == null) && (this.defaults != null)) ? this.defaults.getProperty(key) : sval;
			},
			/**
			 * Return the index of the specified key
			 *
			 * @param {String} key the searched element
			 * @return the index of the specified key or -1
			 */
			indexOf : function indexOf(key) {
				var n = this.map.length;
				while (n--) {
					if (this.map[n].name == key) {
						return n;
					}
				}
				return -1;
			},
			/**
			 * Tests if this hashtable maps no keys to values.
			 *
			 * @return  <code>true</code> if this hashtable maps no keys to values;
			 *          <code>false</code> otherwise.
			 */
			isEmpty : function isEmpty() {
				return this.map.length == 0;
			},
			/**
			 * Enumerate all the keys in this hashtable.
			 */
			keys : function keys(callback, scope) {
				this.map.forEach(function forEach(e, i, arr) {
					callback.apply(scope, [e.name]);
				}, scope);
			},
			/**
			 * Prints this property list out to the system output stream.
			 * This method is useful for debugging.
			 */
			list : function list() {
				console.log("-- listing properties --");
				var key, val, o, n = this.map.length;
				while (n--) {
					o = this.map[n];
					key = o.name;
					val = o.value;
					if (val.length > 40) {
						val = val.substring(0, 37) + "...";
					}
					console.log(key + "=" + val);
				}
			},
			/**
			 * Reads a property list (key and element pairs) from the input
			 * file. The input file is in a simple line-oriented
			 * format as specified in Shinobi format and is assumed to use
			 * the ISO 8859-1 character encoding; that is each byte is one Latin1
			 * character. Characters not in Latin1, and certain special characters,
			 * are represented in keys and elements using Unicode escapes.
			 * The specified stream remains open after this method returns.
			 *
			 * @param {String} file the input file.
			 * @return the properties
			 */
			load : function load(file) {
				return Properties.open(file, this);
			},
			/**
			 * Returns an array of all the keys in this property list,
			 * including distinct keys in the default property list if a key
			 * of the same name has not already been found from the main
			 * properties list.
			 *
			 * @return  an array of all the keys in this property list, including
			 *          the keys in the default property list.
			 */
			propertyNames : function propertyNames() {
				var arr = [];
				var n = this.map.length;
				while (n--) {
					arr[n] = this.map[n].name;
				}
				return arr;
			},
			/**
			 * Maps the specified <code>key</code> to the specified
			 * <code>value</code> in this hashtable. Neither the key nor the
			 * value can be <code>null</code>. <p>
			 *
			 * The value can be retrieved by calling the <code>get</code> method
			 * with a key that is equal to the original key.
			 *
			 * @param      {Object} key     the hashtable key
			 * @param      {Object} value   the value
			 * @return     the previous value of the specified key in this hashtable,
			 *             or <code>null</code> if it did not have one
			 */
			put : function put(key, value) {
				// Make sure the value is not null
				if (value == null) {
					throw new Error("NullPointerException");
				}
				var old, n = this.map.length;
				while (n--) {
					if (this.map[n].name == key) {
						old = this.map[n].value;
						this.map[n].value = value;
						return old;
					}
				}
				// Creates the new entry.
				this.map.push({
					name : key,
					value : value
				});
				return null;
			},
			/**
			 * Copies all of the mappings from the specified map to this hashtable.
			 * These mappings will replace any mappings that this hashtable had for
			 * any of the keys currently in the specified map.
			 *
			 * @param t mappings to be stored in this map
			 */
			putAll : function putAll(t) {
				var p, map;
				if ( t instanceof Properties) {
					t.enumerate(this);
				} else if ( t instanceof Array || typeof t == "object") {
					for (p in t) {
						this.setProperty(p, t[p]);
					}
				}
			},
			/**
			 * Removes the key (and its corresponding value) from this
			 * hashtable. This method does nothing if the key is not in the hashtable.
			 *
			 * @param   {Object} key   the key that needs to be removed
			 * @return  the value to which the key had been mapped in this hashtable,
			 *          or <code>null</code> if the key did not have a mapping
			 */
			remove : function remove(key) {
				if (key == null) {
					throw new Error("NullPointerException");
				}
				var i = this.indexOf(key);
				if (i != -1) {
					var value = this.map.splice(i, 1)[0];
					return value;
				}
				return null;
			},
			/**
			 * Remove the specified property from this hashtable. This method does
			 * nothing if the key is not in the properties.
			 *
			 * @param {String} key the key that needs to be removed
			 * @return the value to which the key had been mapped in this hashtable,
			 *          or <code>null</code> if the key did not have a mapping
			 */
			removeProperty : function removeProperty(key) {
				if ( typeof key != "string") {
					throw new Error("IllegalArgumentsException");
				}
				return this.remove(key);
			},
			/**
			 * Maps the specified <code>key</code> to the specified <code>value</code>
			 * in this hashtable. Neither the key nor the value can be <code>null</code>.
			 * Ensure that key and value are strings. The value can be retrieved by
			 * calling the <code>get</code> method with a key that is equal to the
			 * original key.
			 *
			 * @param {String} key the hashtable key
			 * @param {String} value the value
			 * @return the previous value of the specified key in this hashtable, or
			 * 			<code>null</code> if it did not have one
			 */
			setProperty : function setProperty(key, value) {
				// Make sure the value is not null
				if (key == null || value == null) {
					throw new Error("NullPointerException");
				}
				if ( typeof key != "string" || typeof value != "string") {
					throw new Error("IllegalArgumentsException");
				}
				var i = this.indexOf(key);
				var old;
				if (i == -1) {
					this.map.push({
						name : key,
						value : value
					});
				} else {
					old = this.map[i].value;
					this.map[i] = {
						name : key,
						value : value
					};
				}
				return old;
			},
			/**
			 * Returns the number of keys in this hashtable.
			 *
			 * @return  the number of keys in this hashtable.
			 */
			size : function size() {
				return this.map.length;
			},
			/**
			 * Returns an array of keys in this property list where
			 * the key and its corresponding value are strings,
			 * including distinct keys in the default property list if a key
			 * of the same name has not already been found from the main
			 * properties list.  Properties whose key or value is not
			 * of type <tt>String</tt> are omitted.
			 * <p>
			 * The returned set is not backed by the <tt>Properties</tt> object.
			 * Changes to this <tt>Properties</tt> are not reflected in the set,
			 * or vice versa.
			 *
			 * @return  an array of keys in this property list where
			 *          the key and its corresponding value are strings,
			 *          including the keys in the default property list.
			 */
			stringPropertyNames : function stringPropertyNames() {
				var arr = [];
				var n = this.map.length;
				while (n--) {
					if ( typeof this.map[n].value != "string") {
						continue;
					}
					arr[n] = this.map[n].name;
				}
				return arr;
			},
			/**
			 * Returns a string representation of this <tt>Hashtable</tt> object
			 * in the form of a set of entries, enclosed in braces and separated
			 * by the ASCII characters "<tt>,&nbsp;</tt>" (comma and space). Each
			 * entry is rendered as the key, an equals sign <tt>=</tt>, and the
			 * associated element, where the <tt>toString</tt> method is used to
			 * convert the key and element to strings.
			 *
			 * @return  a string representation of this hashtable
			 */
			toString : function toString() {
				var len = this.size();
				var max = len - 1;
				if (max == -1) {
					return "[]";
				}
				var K, V, i, sb = "{", n = this.map.length;
				for ( i = 0; i < len; i++) {
					K = this.map[n].name;
					V = this.map[n].value;
					sb += key == this ? "(this Map)" : key.toString();
					sb += '=';
					sb += value == this ? "(this Map)" : value.toString();
					if (i == max) {
						sb += "}";
					} else {
						sb += ",";
					}
				}
				return sb;
			},
			statics : {
				/**
				 * Split the specified string into tokens and return the splitting
				 * index.
				 *
				 * @param {String} value the pairs key/value
				 * @return return the spliting index
				 */
				getSplitIndex : function getSplitIndex(value) {
					var s = ["=", ":"];
					// can split on '=' or ':'
					var n = 2;
					var index1;
					var index2 = value.length;
					while (--n > -1) {
						index1 = value.indexOf(s[n]);
						if (index1 > -1 && index1 < index2) {
							index2 = index1;
						}
					}
					return (index2 == value.length - 1) ? -1 : index2;
				},
				/**
				 * Reads a property list (key and element pairs) from the input
				 * file. The input file is in a simple line-oriented
				 * format as specified in Shinobi format and is assumed to use
				 * the ISO 8859-1 character encoding; that is each byte is one Latin1
				 * character. Characters not in Latin1, and certain special characters,
				 * are represented in keys and elements using Unicode escapes.
				 * The specified stream remains open after this method returns.
				 *
				 * @param {String} filename the input file.
				 * @param {Poperties} properties the file buffer.
				 * @return the properties buffer
				 */
				open : function open(filename, properties) {
					var file = Linker.load(filename);
					return Properties.parse(file, properties);
				},
				/**
				 * Read in a "logical line" from an String, skip all comment and blank
				 * lines and filter out those leading whitespace characters (\u0020, \u0009 and \u000c)
				 * from the beginning of a "natural line". Th method returns a Properties
				 * buffer.
				 *
				 * @param {Object} value
				 * @param {Properties} properties
				 * @return
				 */
				parse : function parse(value, properties) {
					if (value == null) {
						throw new Error("ReferenceError Unabled to parse properties - parameter was null");
					}
					var name, splitIndex, lines, s, props = [], i = -1, multiline = false, CR = String.fromCharCode(13), LF = String.fromCharCode(10), hasCR = value.indexOf(CR) > -1, hasLF = value.indexOf(LF) > -1;
					// remove tabs
					value = value.replace(new RegExp(String.fromCharCode(3), "g"), "");
					// split into lines (depending on the line-end type, will split on CRLF, CR, or LF)
					lines = value.split((hasCR && hasLF) ? CR + LF : hasCR ? CR : LF);
					// build into array with each property
					while (++i < lines.length) {
						s = Properties.stripWhitespace(lines[i]);
						if (s.length > 1 && s.charAt(0) != "#" && s.charAt(0) != "!") {//Ignore comments and empty lines
							// if it's a multiline var, add this to the last one
							if (multiline) {
								props[props.length - 1] = props[props.length - 1].substr(0, -1) + s;
							} else {
								props.push(s);
							}
							//does the property extend over more than one line?
							multiline = s.charAt(s.length - 1) == "\\";
						}
					}
					// parse into name / value pairs
					i = props.length;
					while (i--) {
						s = props[i];
						splitIndex = Properties.getSplitIndex(s);
						if (splitIndex == -1) {
							props.splice(i, 1);
							continue;
						}
						// extract and clean whitespace
						name = s.substring(0, splitIndex);
						name = Properties.stripWhitespace(name);
						//
						value = s.substring(splitIndex + 1);
						value = Properties.stripWhitespace(value);
						//
						props[i] = {
							name : name,
							value : value
						};
					}
					Properties.substituteVars(props);
					if (properties) {
						properties.putAll(props);
						return properties;
					}
					return new Properties(props);
				},
				/**
				 * @param {String} value
				 * @return
				 */
				stripWhitespace : function stripWhitespace(value) {
					// strip empty space left and right, and consecutive spaces
					return value.replace(/^[ \s]+|[ \s]+$/g, "");
				},
				/**
				 * @param {Object} props
				 * @return
				 */
				substituteVars : function substituteVars(props) {
					var n = props.length;
					var i = -1;
					var name, value, j, found, matches, sv;
					//match strings between ${ and } to extract variable names
					var varPattern = /\${(.+?)\}/;
					while (++i < n) {
						name = props[i].name;
						value = props[i].value;
						matches = value.match(varPattern);
						if (matches != null && (matches && matches[1] != null)) {
							while (true) {
								sv = matches[1];
								found = false;
								j = -1;
								while (++j < n) {
									if (props[j].name == sv) {
										value = value.replace(varPattern, props[j].value);
										found = true;
									}
								}
								matches = value.match(varPattern);
								if (!found || matches == null || (matches && matches[1] == null))
									break;
							}
							//if we've had a positive match, go back and try again on this string until we replace all variables
							if (found)
								props[i--].value = value;
						}
					}
				},
				defaults : null,
				map : null
			}
		},
		namespace : SHINOBI_NAMESPACE
	});

	/*****************************
	 *
	 * VERSION
	 *
	 ******************************/

	/**
	 * A <code>Vrsion</code> provides information about, and access to, versions
	 * informations on Shinobi API.
	 * The first 4 bytes are a magic number 0xCAFEBABe  to identify a valid class
	 * file then the next 2 bytes identify the class format version (major and minor).
	 * Possible major/minor value :
	 *
	 * major  minor Shinobi platform version
	 * 45       3           	1.0
	 * 45       3           	1.1
	 * 46       0           	1.2
	 * 47       0           	1.3
	 * 48       0           	1.4
	 * 49       0           	1.5
	 * 50       0           	1.6
	 *
	 * -magic
	 * The magic item supplies the magic number identifying the class file format;
	 * it has the value 0xCAFEBABE.
	 *
	 * -minor_version, major_version
	 * The values of the minor_version and major_version items are the minor and
	 * major version numbers of this class file.Together, a major and a minor version
	 * number determine the version of the class file format. If a class file has
	 * major version number M and minor version number m, we denote the version
	 * of its class file format as M.m. Thus, class file format versions may be
	 * ordered lexicographically, for example, 1.5 < 2.0 < 2.1.
	 * A Shinobi implementation can support a class file format of version
	 * v if and only if v lies in some contiguous range Mi.0 v Mj.m. Only Shinobi
	 * can specify what range of versions a Shinobi implementation
	 * conforming to a certain release level of the Shinobi platform may support.
	 *
	 * @see Type
	 * @see System
	 * @author Aime Biendo
	 */
	var Version = Type.inherit({
		qname : "Version",
		subclass : {
			/**
			 *
			 */
			constructor : function Version() {
				throw new TypeError("Illegal Instansiation Exception");
			},

			statics : {
				/**
				 * Gets the Shinobi Dev Kit version info if available, and its
				 * capabilities.
				 *
				 * @return the Shinobi Dev Kit version info availability
				 */
				getSdkVersionInfo : function getSdkVersionInfo() {
					return Version.sdk_major_version != -1 && Version.sdk_minor_version != -1 && Version.sdk_micro_version != -1 && Version.sdk_update_version != -1 && Version.sdk_build_number != -1 && Version.sdk_special_version != null
				},
				/**
				 * Gets the Shinobi version info if available, and its capabilities.
				 *
				 * @return the Shinobi info availability
				 */
				getShinobiVersionInfo : function getShinobiVersionInfo() {
					return Version.shinobi_major_version != -1 && Version.shinobi_minor_version != -1 && Version.shinobi_micro_version != -1 && Version.shinobi_update_version != -1 && Version.shinobi_build_number != -1 && Version.shinobi_special_version != null
				},
				/**
				 * Initialize the Shinobi's platform related name, version and info
				 *
				 * @param {String} name the code name
				 * @param {String} version the build version
				 * @param {String} info optionals informations
				 */
				init : function init(v, prefix, name, version, info) {
					v[prefix + "_name"] = name;
					v[prefix + "_version"] = version;
					v[prefix + "_info"] = info;
				},
				/**
				 *
				 * @param {Boolean} release
				 */
				initVersions : function initVersions(release) {
					if (Version.versionsInitialized) {
						return;
					}
					var leading = "-" + ( release ? "release" : "debug")
					Version.shinobiVersionInfoAvailable = Version.getShinobiVersionInfo();
					if (!Version.shinobiVersionInfoAvailable) {
						// parse shinobi.version for older Shinobi before
						// valid format of the version string is:
						// n.n.n[_uu[c]][-<identifer>]-bxx
						Version.parseVersion(Version, "shinobi", Version.shinobi_version + leading);
						Version.shinobiVersionInfoAvailable = Version.getShinobiVersionInfo();
					}
					Version.sdkVersionInfoAvailable = Version.getSdkVersionInfo();
					if (!Version.sdkVersionInfoAvailable) {
						Version.parseVersion(Version, "sdk", Version.sdk_version + leading);
						Version.sdkVersionInfoAvailable = Version.getSdkVersionInfo();
					}
					Version.versionsInitialized = Version.sdkVersionInfoAvailable && Version.shinobiVersionInfoAvailable;
				},
				/**
				 * @param {String} c
				 * @return
				 */
				isDigit : function isDigit(c) {
					var code = c.charCodeAt(0);
					if ((code > 47) && (code < 58)) {
						return true;
					}
					return false;
				},
				/**
				 * Parse the version parameter on the specified object v the property
				 * begining with the prefix
				 *
				 * @param {Object} v the object
				 * @param {String} prefix the begining prefix
				 * @param {String} version the build version
				 */
				parseVersion : function parseVersion(v, prefix, version) {
					var cs = version;
					if (cs.length >= 5 && Version.isDigit(cs.charAt(0)) && cs.charAt(1) == '.' && Version.isDigit(cs.charAt(4))) {
						v[prefix + "_major_version"] = parseInt(cs.charAt(0));
						v[prefix + "_minor_version"] = parseInt(cs.charAt(2));
						v[prefix + "_micro_version"] = parseInt(cs.charAt(4));
						cs = cs.substring(5, cs.length);
						if (cs.charAt(0) == '_' && cs.length >= 3 && Version.isDigit(cs.charAt(1)) && Version.isDigit(cs.charAt(2))) {
							var nextChar = 3;
							var uu = cs.substring(1, 3);
							v[prefix + "_update_version"] = parseInt(uu);
							if (cs.length >= 4) {
								var c = cs.charAt(3).charCodeAt(0);
								if (c >= 'a'.charCodeAt(0) && c <= 'z'.charCodeAt(0)) {
									v[prefix + "_special_version"] = c;
									nextChar++;
								}
							}
							cs = cs.substring(nextChar, cs.length);
						}
						if (cs.charAt(0) == '-') {
							// skip the first character
							// valid format: <identifier>-bxx or bxx
							// non-product Shinobi will have -debug|-release appended
							cs = cs.substring(1, cs.length);
							var res = cs.split("-");
							var i, s, len = res.length;
							for (i == 0; i < len; i++) {
								s = res[i];
								if (s.charAt(0) == 'b' && s.length == 3 && Version.isDigit(s.charAt(1)) && Version.isDigit(s.charAt(2))) {
									v[prefix + "_build_number"] = parseInt(s.substring(1, 3));
									break;
								}
							}
						}
					}
				},
				/**
				 * Print some shinobi version informations
				 */
				print : function print() {
					if (!Version.versionsInitialized) {
						Version.initVersions();
					}
					console.log("-- SHINOBI ENV --");
					/* First line: platform version. */
					console.log("Platform " + Version.platform_name + " version \"" + Version.platform_version + "\"");
					/* Second line: shinobi dev kit version (ie, libraries). */
					console.log(Version.sdk_name + " (build " + Version.sdk_version + ", " + Version.sdk_info + ")");
					/* Third line: Shinobi code information. */
					var shinobi_name = Version.shinobi_name;
					var shinobi_version = Version.shinobi_version;
					var shinobi_info = Version.shinobi_info;
					console.log("API " + shinobi_name + " (build " + shinobi_version + ", " + shinobi_info + ")");
				},
				/**
				 * Returns the major version of the running SDK.
				 *
				 * @return the major version of the running shinobi dev kit
				 */
				sdkMajorVersion : function sdkMajorVersion() {
					if (!Version.versionsInitialized) {
						Version.initVersions();
					}
					return Version.sdk_major_version;
				},
				/**
				 * Returns the minor version of the running SDK.
				 *
				 * @return the minor version of the running shinobi dev kit
				 */
				sdkMinorVersion : function sdkMinorVersion() {
					if (!Version.versionsInitialized) {
						Version.initVersions();
					}
					return Version.sdk_minor_version;
				},
				/**
				 * Returns the micro version of the running SDK.
				 *
				 * @return the micro version of the running shinobi dev kit
				 */
				sdkMicroVersion : function sdkMicroVersion() {
					if (!Version.versionsInitialized) {
						Version.initVersions();
					}
					return Version.sdk_micro_version;
				},
				/**
				 * Returns the update release version of the running SDK if it's
				 * a RE build. It will return 0 if it's an internal build.
				 *
				 * @return the update version of the running shinobi dev kit
				 */
				sdkUpdateVersion : function sdkUpdateVersion() {
					if (!Version.versionsInitialized) {
						Version.initVersions();
					}
					return Version.sdk_update_version;
				},
				/**
				 * Returns the special version of the running SDK.
				 *
				 * @return the special version of the running shinobi dev kit
				 */
				sdkSpecialVersion : function sdkSpecialVersion() {
					if (!Version.versionsInitialized) {
						Version.initVersions();
					}
					if (Version.sdk_special_version == null) {
						Version.sdk_special_version = Version.getSdkSpecialVersion();
					}
					return Version.sdk_special_version;
				},
				/**
				 * Returns the build number of the running SDK if it's a RE build
				 * It will return 0 if it's an internal build.
				 *
				 * @return the shinobi dev kit build version
				 */
				sdkBuildNumber : function sdkBuildNumber() {
					if (!Version.versionsInitialized) {
						Version.initVersions();
					}
					return Version.sdk_build_version;
				},
				/**
				 * Returns the major version of the running Shinobi if it's 1.6 or newer
				 * or any RE VM build. It will return 0 if it's an internal 1.5 or
				 * 1.4.x build.
				 *
				 * @return the shinobi major version
				 */
				shinobiMajorVersion : function shinobiMajorVersion() {
					if (!Version.versionsInitialized) {
						Version.initVersions();
					}
					return Version.shinobi_major_version;
				},
				/**
				 * Returns the minor version of the running Shinobi if it's 1.6 or newer
				 * or any RE VM build. It will return 0 if it's an internal 1.5 or
				 * 1.4.x build.
				 *
				 * @return the shinobi minor version
				 */
				shinobiMinorVersion : function shinobiMinorVersion() {
					if (!Version.versionsInitialized) {
						Version.initVersions();
					}
					return Version.shinobi_minor_version;
				},
				/**
				 * Returns the minor version of the running Shinobi if it's 1.6 or newer
				 * or any RE VM build. It will return 0 if it's an internal 1.5 or
				 * 1.4.x build.
				 *
				 * @return the shinobi micro version
				 */
				shinobiMicroVersion : function shinobiMicroVersion() {
					if (!Version.versionsInitialized) {
						Version.initVersions();
					}
					return Version.shinobi_micro_version;
				},
				/**
				 * Returns the minor version of the running Shinobi if it's 1.6 or newer
				 * or any RE VM build. It will return 0 if it's an internal 1.5 or
				 * 1.4.x build.
				 *
				 * @return the shinobi special version
				 */
				shinobiSpecialVersion : function shinobiSpecialVersion() {
					if (!Version.versionsInitialized) {
						Version.initVersions();
					}
					if (Version.shinobi_special_version == null) {
						Version.shinobi_special_version = Version.getShinobiSpecialVersion();
					}
					return Version.shinobi_special_version;
				},
				/**
				 * Returns the minor version of the running Shinobi if it's 1.6 or newer
				 * or any RE VM build. It will return 0 if it's an internal 1.5 or
				 * 1.4.x build.
				 *
				 * @return the shinobi update version
				 */
				shinobiUpdateVersion : function shinobiUpdateVersion() {
					if (!Version.versionsInitialized) {
						Version.initVersions();
					}
					return Version.shinobi_update_version;
				},
				/**
				 * Returns the build number of the running Shinobi if it's a RE build
				 * It will return 0 if it's an internal build.
				 *
				 * @return the shinobi build version
				 */
				shinobiBuildNumber : function shinobiBuildNumber() {
					if (!Version.versionsInitialized) {
						Version.initVersions();
					}
					return Version.shinobi_build_version;
				},
				//DEFUALTS VERSIONS
				DEFAULT_DEBUG_VERSION : "0.0.0_00c-b00-debug",
				DEFAULT_RELEASE_VERSION : "0.0.0_00c-b00-release",
				//shinobi platform infos
				platform_name : "",
				platform_version : "",
				platform_info : "",
				//shinobi app infos
				shinobi_name : "",
				shinobi_version : "",
				shinobi_info : "",
				//shinobi versioning
				shinobi_major_version : -1,
				shinobi_minor_version : -1,
				shinobi_micro_version : -1,
				shinobi_update_version : -1,
				shinobi_build_number : -1,
				shinobi_special_version : null,
				//shinobi dev kit infos
				sdk_name : "",
				sdk_version : "",
				sdk_info : "",
				//shinobi dev kit versioning
				sdk_major_version : -1,
				sdk_minor_version : -1,
				sdk_micro_version : -1,
				sdk_update_version : -1,
				sdk_build_number : -1,
				sdk_special_version : null,
				// true if Shinobi exports the version info including the capabilities
				shinobiVersionInfoAvailable : false,
				// true if Shinobi Dev Kit exports the version info including the capabilities
				sdkVersionInfoAvailable : false,
				versionsInitialized : false
			}

		},
		namespace : SHINOBI_NAMESPACE
	});

	/*****************************
	 *
	 * PACKAGE
	 *
	 ******************************/

	/**
	 * <code>Package</code> objects contain version information
	 * about the implementation and specification of a Java package.
	 * This versioning information is retrieved and made available
	 * by the Linker instance that loaded the class(es).  Typically, it is stored
	 * in the manifest that is distributed with the classes.
	 *
	 * <p>The set of classes that make up the package may implement a
	 * particular specification and if so the specification title, version number,
	 * and vendor strings identify that specification.
	 * An application can ask if the package is
	 * compatible with a particular version.
	 *
	 * <p>Specification version numbers use a syntax that consists of positive
	 * decimal integers separated by periods ".", for example "2.0" or
	 * "1.2.3.4.5.6.7".  This allows an extensible number to be used to represent
	 * major, minor, micro, etc. versions.  The version specification is described
	 * by the following formal grammar:
	 * <blockquote>
	 * <dl>
	 * <dt><i>SpecificationVersion:
	 * <dd>Digits RefinedVersion<sub>opt</sub></i>

	 * <p><dt><i>RefinedVersion:</i>
	 * <dd><code>.</code> <i>Digits</i>
	 * <dd><code>.</code> <i>Digits RefinedVersion</i>
	 *
	 * <p><dt><i>Digits:
	 * <dd>Digit
	 * <dd>Digits</i>
	 *
	 * <p><dt><i>Digit:</i>
	 * <dd>any character for which isDigit returns <code>true</code>,
	 * e.g. 0, 1, 2, ...
	 * </dl>
	 * </blockquote>
	 *
	 * <p>The implementation title, version, and vendor strings identify an
	 * implementation and are made available conveniently to enable accurate
	 * reporting of the packages involved when a problem occurs. The contents
	 * all three implementation strings are vendor specific. The
	 * implementation version strings have no specified syntax and should
	 * only be compared for equality with desired version identifiers.
	 *
	 * <p>Within each <code>ClassLoader</code> instance all classes from the same
	 * java package have the same Package object.  The static methods allow a package
	 * to be found by name or the set of all packages known to the current class
	 * loader to be found.
	 *
	 * @see Type
	 * @see Class
	 * @see Linker
	 * @author Aime Biendo
	 */
	var Package = Type.inherit({
		qname : "Package",
		subclass : {
			/**
			 * Construct a package instance with the specified name, parent and
			 * optional linker.
			 *
			 * @param {String} name the name of the package
			 * @param {Package} parent the named scope
			 * @param {Linker} linker this package linker
			 * @param {String} dir the root folder only used by the parent package
			 */
			constructor : function Package(name, parent, linker, dir) {
				this.name = name;
				this.parent = parent == window ? null : parent;
				if (this.parent == null) {
					this.dir = dir || "";
				} else {
					this.dir = this.parent.dir;
				}
				this.path = (this.parent != null ? (this.parent.path + this.name) : (this.dir + this.name)) + "/";
				this.qname = (this.parent != null ? (this.parent.qname + "." + this.name) : this.name);
				this.version = "0.0.0";
				this.linker = linker || (this.parent != null ? this.parent.linker : Linker.getSystemClassLinker());
				this.setProperties(new Properties());
				if (this.linker) {
					this.linker.addPackage(this);
				}
			},
			/**
			 * The Class method is used to declare a new Javascript class, which is
			 * a collection of related variables and/or methods. Types are the basic
			 * building blocks of object−oriented programming. A type typically represents
			 * some real−world entity such as a geometric Shape or a Person. A class
			 * is a template for an object. Every object is an instance of a class. To
			 * use a class, you instantiate an object of the class, typically with the
			 * new operator, then call the declared methods to access the features of
			 * the class.
			 *
			 * @param {String} qname the fully qualified class name
			 * @param {Object} superclass the super class
			 * @param {Array} interfaces a list of interfaces to implements
			 * @param {Object} subclass the class definition
			 * @param {Object} namespace the global scope where live the class
			 * @return the created class otherwise null
			 */
			class_ : function class_(parameters/*qname, superclass, interfaces, subclass, namespace*/) {
				parameters.qname = this.qname + parameters.qname;
				return Class.create(parameters);
			},
			/**
			 * Defines a package by name in this package <tt>Linker</tt>.  This allows
			 * class linkers to define the packages for their classes. Packages must
			 * be created before the class is defined, and package names must be
			 * unique within a class linker and cannot be redefined or changed once
			 * created.  </p>
			 *
			 * @param {String} name The package name
			 * @param {Linker} name The package optional linker
			 * @return  The newly defined <tt>Package</tt> object
			 */
			definePackage : function definePackage(name, linker) {
				var pkg = this.getPackage(name);
				if (pkg != null) {
					throw new Error("IllegalArgumentException " + name);
				}
				return Package.create(name, this, linker || this.linker);
			},
			/**
			 * Get all classes that reside on this package
			 *
			 * @return all registered classes on this pacakge
			 */
			getClasses : function getClasses() {
				var cls, classes = [];
				for (cls in this) {
					if ( typeof this[cls] == "function" && !this.isPackageMethod(cls)) {
						classes.push(this[cls]);
					}
				}
				return classes;
			},
			/**
			 * Return the root package directory
			 *
			 * @return this package directory
			 */
			getDir : function getDir() {
				return this.parent != null ? this.parent.getDir() : this.dir;
			},
			/**
			 * Return this package application entry point map key
			 *
			 * @return this package application entry point map key otherwise null
			 */
			getEntryPoint : function getEntryPoint() {
				return this.entryPoint;
			},
			/**
			 * Return the title of this package.
			 *
			 * @return the title of the implementation, null is returned if it is not known.
			 */
			getImplementationTitle : function getImplementationTitle() {
				return this.implTitle;
			},
			/**
			 * Return the version of this implementation. It consists of any string
			 * assigned by the vendor of this implementation and does
			 * not have any particular syntax specified or expected by the Java
			 * runtime. It may be compared for equality with other
			 * package version strings used for this implementation
			 * by this vendor for this package.
			 *
			 * @return the version of the implementation, null is returned if it is not known.
			 */
			getImplementationVersion : function getImplementationVersion() {
				return this.implVersion;
			},
			/**
			 * Returns the name of the organization,
			 * vendor or company that provided this implementation.
			 *
			 * @return the vendor that implemented this package..
			 */
			getImplementationVendor : function getImplementationVendor() {
				return this.implVendor;
			},
			/**
			 * Return the binary name of this package.
			 *
			 * @return The fully-qualified name.
			 */
			getName : function getName() {
				return this.qname;
			},
			/**
			 * Return the specified package by it's name
			 *
			 * @param {String} pkg the package name
			 * @return the specified package otherwise null
			 */
			getPackage : function getPackage(pkg) {
				var len, pkg, pkgs = this.getPackages();
				while (len--) {
					pkg = pkgs[len];
					if (pkg.qname == pkg) {
						return pkg;
					}
				}
				return null;
			},
			/**
			 * Return this package .package-info file object. Each package can be
			 * associated with a .package-info file that reside on the server side.
			 * This file format descbe a package and it's dependencies.
			 *
			 * Name: shinobi
			 * Specification-Title:
			 * Specification-Version:
			 * Specification-Vendor:
			 * Implementation-Title:
			 * Implementation-Version:
			 * Implementation-Vendor:
			 * Implementation-Profile
			 * Include-Dependencies:
			 * Entry-Point:
			 * User-Info:
			 *
			 * @return the .package-info object of this package if any
			 */
			getPackageInfo : function getPackageInfo() {
				if (this.packageInfo == null) {
					var path, file, data, i, key, value, tulp, len, parts, trim = function trim(str) {
						return str.replace(/^\s+/g, '').replace(/\s+$/g, '');
					}
					path = this.getPath();
					file = path.substring(0, path.lastIndexOf("/") + 1) + this.getName() + ".package-info";
					data = Linker.load(file);
					if (data) {
						parts = data.split("\r");
						len = parts.length;
						this.packageInfo = {};
						for ( i = 0; i < len; i++) {
							tulp = parts[i].split(":");
							key = trim(tulp[0]);
							value = trim(tulp[1]);
							this.packageInfo[key] = value;
						}
					} else {
						throw new Error("FileNotFoundException " + file);
					}
				}
				return this.packageInfo;
			},
			/**
			 * Return all packages var reside on this package
			 *
			 * @return all packages that reside on this package
			 */
			getPackages : function getPackages() {
				var pkg, pkgs = [];
				for (pkg in this) {
					if (this[pkg] instanceof Package) {
						pkgs.push(this[pkg]);
					}
				}
				return pkgs;
			},
			/**
			 * this package path
			 *
			 * @return this package path
			 */
			getPath : function getPath() {
				return this.path;
			},
			/**
			 * Return this package optional associated profile information.
			 *
			 * @return this package profile otherwise null
			 */
			getProfile : function getProfile() {
				return this.profile;
			},
			/**
			 * Get a user define property
			 *
			 * @param {String} key the property name
			 * @param {Object} def the default associated property value
			 * @return the user define property value
			 */
			getProperty : function getProperty(key, def) {
				return this.properties.getProperty(key, def);
			},
			/**
			 * Return the title of the specification that this package implements.
			 *
			 * @return the specification title, null is returned if it is not known.
			 */
			getSpecificationTitle : function getSpecificationTitle() {
				return this.specTitle;
			},
			/**
			 * Return the name of the organization, vendor,
			 * or company that owns and maintains the specification
			 * of the classes that implement this package.
			 *
			 * @return the specification vendor, null is returned if it is not known.
			 */
			getSpecificationVendor : function getSpecificationVendor() {
				return this.specVendor;
			},
			/**
			 * Returns the version number of the specification
			 * that this package implements.
			 * This version string must be a sequence of positive decimal
			 * integers separated by "."'s and may have leading zeros.
			 * When version strings are compared the most significant
			 * numbers are compared.
			 *
			 * @return the specification version, null is returned if it is not known.
			 */
			getSpecificationVersion : function getSpecificationVersion() {
				return this.specVersion;
			},
			/**
			 * Get a list of all symbols that resides on this package
			 *
			 * @return the list of all symbols
			 */
			getSymbols : function getSymbols() {
				var o, s, symbols = [];
				for (s in this) {
					if (!this.isPackageMethod(p) && !this.isPackageField(p) && !(this[s] instanceof Package)) {
						o = {};
						o[s] = this[s];
						symbols.push(o);
					}
				}
				return s;
			},
			/**
			 *
			 * @param name
			 */
			hasClass : function hasClass(name) {
				var parts = name.split(".");
				var classes = this.getClasses();
				return classes.indexOf(parts[0]) != -1;
			},
			/**
			 * Include the specified class on this package
			 *
			 * @param {String} qualifiedClassName the class binary name
			 * @param {Function} callback the completion listener
			 * @param {Object} namespace the named scope
			 * @return the included class object
			 */
			includes : function includes(qualifiedClassName, callback, namespace) {
				return Linker.includes(this.qname + qualifiedClassName, callback, namespace);
			},
			/**
			 * Imports the specified symbol on this package scope
			 *
			 * @param {String} qualifiedClassName the symbol fully qualfied path
			 * @return the specified otherwise null
			 */
			imports : function imports(qualifiedClassName) {
				var name = qualifiedClassName;
				var tmp = this.getClasses().concat(this.getSymbols());
				var o, ic, parts, len = tmp.length, internals, isinternal = name.indexOf("$"), isinterface = name.indexOf("@");
				if (isinternal || isinterface) {
					parts = isinternal ? name.split("$") : name.split("@");
					name = parts[0];
					ic = parts[1];
				}
				while (len--) {
					o = tmp[len];
					if (Type.ownedProperty(o, name)) {
						return ic ? o[name][ic] : o[name];
					}
				}
				return null;
			},
			/**
			 * Add the specified path on this package linker
			 *
			 * @param {String} path the new path
			 * @return the added path on this packae linker
			 */
			ipath : function ipath(path) {
				return this.linker.addClassPath(path);
			},
			/**
			 * Compare this package's specification version with a
			 * desired version. It returns true if
			 * this packages specification version number is greater than or equal
			 * to the desired version number. <p>
			 *
			 * Version numbers are compared by sequentially comparing corresponding
			 * components of the desired and specification strings.
			 * Each component is converted as a decimal integer and the values
			 * compared.
			 * If the specification value is greater than the desired
			 * value true is returned. If the value is less false is returned.
			 * If the values are equal the period is skipped and the next pair of
			 * components is compared.
			 *
			 * @param {String} desired the version string of the desired version.
			 * @return true if this package's version number is greater
			 * 		than or equal to the desired version number
			 */
			isCompatibleWith : function isCompatibleWith(desired) {
				if (this.specVersion == null || this.specVersion.length < 1) {
					throw new Error("NumberFormatException Empty version string");
				}
				var sa = this.specVersion.split("\\.", -1);
				var si = new Array(sa.length);
				var i, d, s;
				for ( i = 0; i < sa.length; i++) {
					si[i] = parseInt(sa[i]);
					if (si[i] < 0)
						throw new Error("NumberFormatException " + si[i]);
				}
				var da = desired.split("\\.", -1);
				var di = new Array(da.length);
				for ( i = 0; i < da.length; i++) {
					di[i] = parseInt(da[i]);
					if (di[i] < 0)
						throw new Error("NumberFormatException " + di[i]);
				}
				var len = Math.max(di.length, si.length);
				for ( i = 0; i < len; i++) {
					d = (i < di.length ? di[i] : 0);
					s = (i < si.length ? si[i] : 0);
					if (s < d)
						return false;
					if (s > d)
						return true;
				}
				return true;
			},
			isPackageField : function isPackageField(property) {
				return (/properties|packageInfo|name|qname|path|specTitle|specVersion|specVendor|implTitle|implVersion|implVendor|parent/.test(property));
			},

			isPackageMethod : function isPackageMethod(property) {
				return (/__proto__|constructor|Class|checkKey|clearProperty|isCompatibleWith|isPackageField|isPackageMethod|getPath|getPackageInfo|getName|getClasses|getPackage|getPackages|getProperty|getSymbols|getSpecificationTitle|getSpecificationVendor|getSpecificationVersion|getImplementationTitle|getImplementationVersion|getImplementationVendor|includes|imports|setProperties|setProperty|setup|toString|valueOf|/.test(property));
			},
			/**
			 * Set up this Package initialization values
			 *
			 * @return the initialized Package
			 */
			setup : function setup() {
				var p, pkgs, len, value, path = this.getPath(), pinfo = this.getPackageInfo();
				for (p in pinfo) {
					value = pinfo[p];
					if (p == "Name") {
						this.name = value;
					} else if (p == "Specification-Title") {
						this.specTitle = value;
					} else if (p == "Specification-Version") {
						this.specVersion = value;
					} else if (p == "Specification-Vendor") {
						this.specVendor = value;
					} else if (p == "Implementation-Title") {
						this.implTitle = value;
					} else if (p == "Implementation-Version") {
						this.implVersion = value;
					} else if (p == "Implementation-Vendor") {
						this.implVendor = value;
					} else if (p == "Include-Dependencies") {
						paths = value.split(",");
						len = paths.length;
						while (len--) {
							this.ipath(path + paths[len]);
						}
					} else if (p == "Implementation-Profile") {
						this.profile = value;
					} else if (p == "User-Info") {
						if (this.properties == undefined) {
							this.properties = new Properties();
						}
						if (value.indexOf(".xml") != -1) {
							var xml = Linker.loadXml(path + value);
							var rootNode = xml.childNodes[0];
							var children = rootNode.childNodes;
							var len = children.length;
							var node, nodes = [];
							while (len--) {
								node = children[len];
								if (node.nodeType == 1) {
									this.properties.put(node.localName, node);
								}
							}
						} else if (value.indexOf(".json") != -1) {
							var json = Linker.loadJson(path + value);
						} else if (value.indexOf(".properties") != -1) {
							this.properties.load(path + value);
						} else if (value.indexOf(".txt") != -1) {
							var txt = Linker.load(path + value);
							var parts = txt.split("\n");

						} else {

						}
					} else if (p == "Entry-Point") {
						this.entryPoint = value;
					}
				}
				return this;
			},
			/**
			 * Set the specified user defined Properties onto this package
			 *
			 * @param {Properties} props the Properties to add
			 */
			setProperties : function setProperties(props) {
				this.properties = props || new Properties();
			},
			/**
			 * Set the specified user defined property
			 *
			 * @param {String} key the property name
			 * @param {Object} value the property value
			 * @return the old valu if any otherwise null
			 */
			setProperty : function setProperty(key, value) {
				return this.properties.setProperty(key, value);
			},
			/**
			 * Returns the string representation of this Package.
			 * Its value is the string "package " and the package name.
			 * If the package title is defined it is appended.
			 * If the package version is defined it is appended.
			 *
			 * @return the string representation of the package.
			 */
			toString : function toString() {
				var spec = this.specTitle;
				var ver = this.specVersion;
				if (spec != null && spec.length() > 0)
					spec = ", " + spec;
				else
					spec = "";
				if (ver != null && ver.length > 0)
					ver = ", version " + ver;
				else
					ver = "";
				return "package " + this.qname + spec + ver;
			},
			statics : {
				/**
				 * Construct a package instance with the specified version
				 * information. The package qualifiedClassName must have an optional
				 * dir part specified like that : "src/-com.mylib" where the part
				 * before the "-" is the directory where live this package
				 *
				 * @param {String} qualifiedClassName the binary name of the package
				 * @param {Object} namespace the named scope
				 * @param {Linker} linker the package linker
				 * @return a new package for containing the specified information.
				 */
				create : function create(qualifiedClassName, namespace, linker) {
					if (!qualifiedClassName || typeof qualifiedClassName != "string") {
						return null;
					}
					if (qualifiedClassName == "*" || qualifiedClassName == "window" || qualifiedClassName == "globale") {
						return window;
					}
					var dir, name, components = Linker.extractPackageComponents(qualifiedClassName), namespace = Type.namespace(namespace);
					dir = components.dir;
					qualifiedClassName = components.path;
					if (Type.ownedProperty(namespace, qualifiedClassName)) {
						if (namespace[qualifiedClassName] == null) {
							namespace = namespace[qualifiedClassName] = new Package(qualifiedClassName, namespace, linker, dir);
						}
						return namespace;
					}
					var i, len, ns, pns, parent, p = Type.normalizeComponents(qualifiedClassName);
					i = len = p.length;
					for ( i = 0; i < len; i++) {
						ns = p[i];
						namespace = Type.ownedProperty(namespace, ns) ? namespace[ns] : (namespace[ns] = new Package(ns, namespace, linker, dir));
					}
					return namespace;
				},
				/**
				 * Defines a package by name in this package <tt>Linker</tt>.  This allows
				 * class linkers to define the packages for their classes. Packages must
				 * be created before the class is defined, and package names must be
				 * unique within a class linker and cannot be redefined or changed once
				 * created.  </p>
				 *
				 * @param {String} name The package name
				 * @param {Object} namespace named scope
				 * @param {Function} listener completion listener
				 * @param {Linker} name The class linker
				 * @return  The newly defined <tt>Package</tt> object
				 */
				definePackages : function definePackages(qname, listener, namespace, linker) {
					var pkg = Package.create(qname, namespace, linker);
					if (listener) {
						return listener.apply(namespace, [pkg]);
					}
					return pkg;
				},
				/**
				 * Exported modules are modules that are not necessary declared with the keyword
				 * imports. Exporting a class module is equivalent to exporting
				 * each of its static data members and each of its non-inline member functions.
				 * An exported module is special because its definition does not need to be
				 * present in a translation unit that uses that template. In other words, the
				 * definition of an exported template does not need to be explicitly or
				 * implicitly included in a translation unit that instantiates that template.
				 *
				 * @param {Object} module class template to export
				 * @param {Object} namespace the destination module
				 * @return the exported module otherwise null
				 */
				exports : function exports(module, namespace) {
					var lib, ns;
					function exp(type, exported) {
						var o;
						if ( typeof type == "string") {
							var wilcardIndex = type.indexOf(".*");
							var lindex = type.indexOf(".<");
							if (wilcardIndex != -1) {
								type = type.substring(0, wilcardIndex);
							} else if (lindex != -1) {
								exported.concat(type.substring(lindex, type.length - 1).split(","));
								type = type.substring(0, lindex);
							}
							o = Type.getTypeByName(type);
						} else if ( typeof type == "function") {
							var name = Type.getClassName(type);
							if (name == null || name == undefined) {
								o = type();
							} else {
								o = {};
								o[name] = type;
							}
						} else {
							o = type;
						}
						return o;
					}

					var len, props = [];
					lib = exp(module, props);
					ns = exp(namespace) || this;
					if (lib && ns) {
						var p;
						if (props.length == 0) {
							for (p in lib) {
								if (!Type.ownedProperty(ns, p)) {
									ns[p] = lib[p];
								}
							}
						} else {
							len = props.length;
							while (len--) {
								p = props[len];
								if (!Type.ownedProperty(ns, p)) {
									ns[p] = lib[p];
								}
							}
						}
						return ns;
					}
					return null;
				},
				/**
				 * Get the package for the specified class.
				 * The class's class linker is used to find the package instance
				 * corresponding to the specified class. If the class linker
				 * is the bootstrap class linker, which may be represented by
				 * <code>null</code> in some implementations, then the set of packages
				 * loaded by the bootstrap class loader is searched to find the package.
				 * <p>
				 * Packages have attributes for versions and specifications only
				 * if the class linker created the package instance with the appropriate
				 * attributes. Typically those attributes are defined in the manifests
				 * that accompany the package.
				 *
				 * @param {Function} c the class to get the package of.
				 * @param {Object} namespace the named scope
				 * @return the package of the class. It may be null if no package
				 * 		information is available from the archive or codebase.
				 */
				getClassPackage : function getClassPackage(c, namespace) {
					var className, i, cl;
					if ( c instanceof Class) {
						return c.getPackage();
					} else {
						className = Type.getClassName(c);
						cl = Linker.getCallerClassLinker(c);
					}
					i = className.lastIndexOf('.');
					if (i < 0) {
						return null;
					}
					className = className.substring(0, i);
					if (cl != null) {
						return cl.getPackage(className);
					}
					return Package.getPackage(className, namespace);
				},
				/**
				 * Find a package by name in the callers namespace instance. The callers namespace
				 * instance is used as root to find the package instance corresponding to the
				 * named package. If the callers namespace instance is null then the set of
				 * packages loaded in window by the system instance is searched to find the
				 * named package. Packages have attributes for versions and specifications
				 * only if the pakage loader created the package instance with the appropriate
				 * attributes.
				 *
				 * @param {String} name a package name, for example, shinobi.lang.
				 * @param {Object} namespace the named scope
				 * @return the package of the requested name. It may be null if no package
				 * 		information is available from the archive or codebase.
				 */
				getPackage : function getPackage(pkg, namespace) {
					namespace = Type.namespace(namespace);
					var name, i;
					if (pkg.indexOf("::") != -1 || pkg.indexOf("*") != -1) {
						throw new SyntaxError("illegal token :: or * was found");
					}
					var parts = Type.normalizeComponents(pkg);
					for ( i = 0; i < parts.length; i++) {
						name = parts[i];
						if (Type.ownedProperty(namespace, name)) {
							namespace = namespace[name];
						} else {
							return null;
						}
					}
					if ( namespace instanceof Package) {
						return namespace;
					}
					return null;
				},
				/**
				 * Get all the packages currently known for the caller's <code>Linker</code>
				 * instance.  Those packages correspond to classes loaded via or accessible by
				 * name to that <code>Linker</code> instance.  If the caller's
				 * <code>Linker</code> instance is the bootstrap <code>Linker</code>
				 * instance, which may be represented by <code>null</code> in some implementations,
				 * only packages corresponding to classes loaded by the bootstrap
				 * <code>Linker</code> instance will be returned.
				 *
				 * @return a new array of packages known to the callers <code>Linker</code>
				 * 			instance.  An zero length array is returned if none are
				 * 			known.
				 */
				getPackages : function getPackages() {
					return Linker.getPackages();
				}
			},
			/**
			 * Exported modules are modules that are not necessary declared with
			 * the keyword imports. Exporting a class module is equivalent to exporting
			 * each of its static data members and each of its non-inline member functions.
			 * An exported module is special because its definition does not need to be
			 * present in a translation unit that uses that template. In other words, the
			 * definition of an exported template does not need to be explicitly or
			 * implicitly included in a translation unit that instantiates that template.
			 *
			 * @param {Object} module class template to export
			 * @return the exported module otherwise null
			 */
			exports : function exports(module) {
				return Package.exports(module, this);
			},
			packageInfo : null,
			properties : null,
			name : null,
			path : null,
			qname : null,
			specTitle : null,
			specVersion : null,
			specVendor : null,
			implTitle : null,
			implVersion : null,
			implVendor : null,
			parent : null,
			linker : null,
			dir : null,
			profile : null,
			entryPoint : null
		},
		namespace : SHINOBI_NAMESPACE
	});

	/*****************************
	 *
	 * CLASS
	 *
	 ******************************/

	/**
	 * Instances of the class <code>Class</code> represent classes and
	 * interfaces in a running Object Oriented JS application.
	 *
	 * @see Type
	 * @see Constructor
	 * @see Method
	 * @see Field
	 * @see Package
	 * @author Aime Biendo
	 */
	var Class = Type.inherit({
		qname : "Class",
		subclass : {
			/**
			 * Create a <code>Class</code> from the specified type.
			 *
			 * @param {Object} type the object to reflect
			 */
			constructor : function Class(type) {
				this.type = typeof type == "function" ? type : type.constructor;
				this.name = type.slot || Type.getClassName(type);
				this.interfaces = type.interfaces || [];
				var e, tmp = [];
				this.interfaces.forEach(function(el, i, tmp) {
					e = Type.getTypeByName(el);
					tmp.push(e);
				});
				this.interfaces = tmp;
				this.superclass = Class.getSuperTypeOf(type);
			},
			/**
			 * Returns an array containing <code>Class</code> objects representing all
			 * the public classes and interfaces that are members of the class
			 * represented by this <code>Class</code> object.  This includes public
			 * class and interface members inherited from superclasses and public class
			 * and interface members declared by the class.  This method returns an
			 * array of length 0 if this <code>Class</code> object has no public member
			 * classes or interfaces.  This method also returns an array of length 0 if
			 * this <code>Class</code> object represents a primitive type, an array
			 * class, or void.
			 *
			 * @return the array of <code>Class</code> objects representing the public
			 * 			members of this class
			 */
			getClasses : function getClasses() {
				return null;
			},
			/**
			 * Returns the class linker for the class.  Some implementations may use
			 * null to represent the bootstrap class linker. This method will return
			 * null in such implementations if this class was loaded by the bootstrap
			 * class linker.
			 *
			 * <p>If this object
			 * represents a primitive type or void, null is returned.
			 *
			 * @return  the class loader that loaded the class or interface
			 *          represented by this object.
			 */
			getClassLinker : function getClassLinker() {
				var ccl = Linker.getCallerClassLinker(this);
				/*if (ccl != null && ccl != cl && !cl.isAncestor(ccl)) {

				 }*/
				return cl;
			},
			/**
			 * Returns an array containing <code>Constructor</code> objects reflecting
			 * all the public constructors of the class represented by this
			 * <code>Class</code> object.  An array of length 0 is returned if the
			 * class has no public constructors, or if the class is an array class, or
			 * if the class reflects a primitive type or void.
			 *
			 * @param {String} name the name of the constructor
			 * @return the array of <code>Constructor</code> objects representing the
			 *  		public constructors of this class
			 */
			getConstructor : function getConstructor(name) {
				var len, ctr, ctrs = this.getConstructors();
				while (len--) {
					ctr = ctrs[len];
					if (ctr.getName() == name) {
						return ctr;
					}
				}
				return null;
			},
			/**
			 * Returns an array containing <code>Constructor</code> objects reflecting
			 * all the public constructors of the class represented by this
			 * <code>Class</code> object.  An array of length 0 is returned if the
			 * class has no public constructors, or if the class is an array class, or
			 * if the class reflects a primitive type or void.
			 *
			 * @return the array of <code>Constructor</code> objects representing the
			 *  		public constructors of this class
			 */
			getConstructors : function getConstructors() {
				var p, sc, dc, constructors = this.getDeclaredConstructor();
				sc = this.getGenericSuperclass();
				while (sc) {
					constructors.push(sc.getDeclaredConstructor());
					if (sc.type == Object) {
						break;
					}
					sc = sc.getGenericSuperclass();
				}
				return constructors;
			},
			/**
			 * Returns a <code>Constructor</code> object that reflects the specified
			 * constructor of the class or interface represented by this
			 * <code>Class</code> object.
			 *
			 * @return    The <code>Constructor</code> object for the constructor.
			 */
			getDeclaredConstructor : function getDeclaredConstructor() {
				return new Constructor(this.type, this.getName());
			},
			/**
			 * Returns a <code>Field</code> object that reflects the specified declared
			 * field of the class or interface represented by this <code>Class</code>
			 * object. The <code>name</code> parameter is a <code>String</code> that
			 * specifies the simple name of the desired field.  Note that this method
			 * will not reflect the <code>length</code> field of an array class.
			 *
			 * @param {String} name the name of the field
			 * @return the <code>Field</code> object for the specified field in this
			 * 			class
			 */
			getDeclaredField : function getDeclaredField(name) {
				var len, field, fields = this.getDeclaredFields();
				while (len--) {
					field = fields[len];
					if (field.getName() == name) {
						return field;
					}
				}
				return null;
			},
			/**
			 * If the type represented by this <code>Class</code> object
			 * is a member of another class, returns the <code>type</code> function
			 * representing the class in which it was declared.
			 *
			 * @return the declaring type function for this class
			 */
			getDeclaringClass : function getDeclaringClass() {
				return this.type;
			},
			/**
			 * Returns an array of <code>Field</code> objects reflecting all the fields
			 * declared by the class or interface represented by this
			 * <code>Class</code> object. This includes public, protected, default
			 * (package) access, and private fields, but excludes inherited fields.
			 * The elements in the array returned are not sorted and are not in any
			 * particular order.  This method returns an array of length 0 if the class
			 * or interface declares no fields, or if this <code>Class</code> object
			 * represents a primitive type, an array class, or void.
			 *
			 * @return the array of <code>Field</code> objects representing all the
			 * 			declared fields of this class
			 */
			getDeclaredFields : function getDeclaredFields() {
				var p, fields = [], o = this.type.prototype;
				for (p in o) {
					if ( typeof o[p] != "function" && !/constructor|__proto__/.test(p)) {
						fields.push(new Field(this.type, p, o[p].constructor));
					}
				}
				o = this.type;
				for (p in o) {
					if ( typeof o[p] != "function" && !/constructor|__proto__/.test(p)) {
						fields.push(new Field(this.type, p, o[p].constructor, true));
					}
				}
				return fields;
			},
			/**
			 * Returns a <code>Method</code> object that reflects the specified
			 * declared method of the class or interface represented by this
			 * <code>Class</code> object.
			 *
			 * @param {String} name the name of the method
			 * @return the <code>Method</code> object for the method of this class
			 * 			matching the specified name and parameters
			 */
			getDeclaredMethod : function getDeclaredMethod(name) {
				var len, method, methods = this.getDeclaredMethods();
				while (len--) {
					method = methods[len];
					if (method.getName() == name) {
						return method;
					}
				}
				return null;
			},
			/**
			 * Returns an array of <code>Method</code> objects reflecting all the
			 * methods declared by the class or interface represented by this
			 * <code>Class</code> object. This includes public, protected, default
			 * (package) access, and private methods, but excludes inherited methods.
			 * The elements in the array returned are not sorted and are not in any
			 * particular order.  This method returns an array of length 0 if the class
			 * or interface declares no methods, or if this <code>Class</code> object
			 * represents a primitive type, an array class, or void.  The class
			 * initialization method <code>&lt;clinit&gt;</code> is not included in the
			 * returned array. If the class declares multiple public member methods
			 * with the same parameter types, they are all included in the returned
			 * array.
			 *
			 * @return the array of <code>Method</code> objects representing all the
			 * 			declared methods of this class
			 */
			getDeclaredMethods : function getDeclaredMethods() {
				var p, methods = [], o = this.type.prototype;
				for (p in o) {
					if (Type.ownedProperty(o, p) && typeof o[p] == "function" && !/constructor/.test(p)) {
						methods.push(new Method(this.type, p));
					}
				}
				o = this.type;
				for (p in o) {
					if (Type.ownedProperty(o, p) && typeof o[p] == "function" && !/constructor/.test(p)) {
						methods.push(new Method(this.type, p, true));
					}
				}
				return methods;
			},
			/**
			 * Returns the immediately enclosing class of the underlying
			 * class.  If the underlying class is a top level class this
			 * method returns <tt>null</tt>.
			 *
			 * @return the immediately enclosing class of the underlying class
			 */
			getEnclosingClass : function getEnclosingClass() {
				var name = "", index = this.getName().indexOf("$");
				if (index != -1) {
					name = this.getName().substring(0, index);
					return Type.getTypeByName(name, this);
				}
				return null;
			},
			/**
			 * Returns a <code>Field</code> object that reflects the specified public
			 * member field of the class or interface represented by this
			 * <code>Class</code> object. The <code>name</code> parameter is a
			 * <code>String</code> specifying the simple name of the desired field.
			 *
			 * <p> The field to be reflected is determined by the algorithm that
			 * follows.  Let C be the class represented by this object:
			 * <OL>
			 * <LI> If C declares a public field with the name specified, that is the
			 *      field to be reflected.</LI>
			 * <LI> If no field was found in step 1 above, this algorithm is applied
			 * 	    recursively to each direct superinterface of C. The direct
			 * 	    superinterfaces are searched in the order they were declared.</LI>
			 * <LI> If no field was found in steps 1 and 2 above, and C has a
			 *      superclass S, then this algorithm is invoked recursively upon S.
			 *      If C has no superclass, then a <code>NoSuchFieldException</code>
			 *      is thrown.</LI>
			 * </OL>
			 *
			 * @param name the field name
			 * @return  the <code>Field</code> object of this class specified by
			 * 			<code>name</code>
			 */
			getField : function getField(name) {
				var len, field, fields = this.getFields();
				while (len--) {
					field = fields[len];
					if (field.getName() == name) {
						return field;
					}
				}
				return null;
			},
			/**
			 * Returns an array containing <code>Field</code> objects reflecting all
			 * the accessible public fields of the class or interface represented by
			 * this <code>Class</code> object.  The elements in the array returned are
			 * not sorted and are not in any particular order.  This method returns an
			 * array of length 0 if the class or interface has no accessible public
			 * fields, or if it represents an array class, a primitive type, or void.
			 *
			 * <p> Specifically, if this <code>Class</code> object represents a class,
			 * this method returns the public fields of this class and of all its
			 * superclasses.  If this <code>Class</code> object represents an
			 * interface, this method returns the fields of this interface and of all
			 * its superinterfaces.
			 *
			 * @return the array of <code>Field</code> objects representing the
			 * 			public fields
			 */
			getFields : function getFields() {
				var fields = this.getDeclaredFields();
				var sc = this.getGenericSuperclass();
				while (sc) {
					fields = fields.concat(sc.getDeclaredFields());
					if (sc.type == Object) {
						break;
					}
					sc = sc.getGenericSuperclass();
				}
				return fields;
			},
			/**
			 * Returns the <tt>Class</tt>s representing the interfaces
			 * directly implemented by the class or interface represented by
			 * this object.
			 *
			 * @return an array of interfaces implemented by this class
			 */
			getGenericInterfaces : function getGenericInterfaces() {
				var tmp = [];
				this.interfaces.forEach(function(el, i, arr) {
					tmp.push(new Class(el));
				});
				return tmp;
			},
			/**
			 * Returns the <tt>Class</tt> representing the direct superclass of
			 * the entity (class, interface, primitive type or void) represented by
			 * this <tt>Class</tt>.
			 *
			 * @return The direct superclass of the entity (class, interface, primitive
			 * 			type or void) represented by this <tt>Class</tt>.
			 */
			getGenericSuperclass : function getGenericSuperclass() {
				return new Class(this.superclass);
			},
			/**
			 * Determines the interfaces implemented by the class or interface
			 * represented by this object.
			 *
			 * <p> If this object represents a class, the return value is an array
			 * containing objects representing all interfaces implemented by the
			 * class. The order of the interface objects in the array corresponds to
			 * the order of the interface names in the <code>implements</code> clause
			 * of the declaration of the class represented by this object.
			 * <p> If this object represents an interface, the array contains objects
			 * representing all interfaces extended by the interface. The order of the
			 * interface objects in the array corresponds to the order of the interface
			 * names in the <code>extends</code> clause of the declaration of the
			 * interface represented by this object.
			 *
			 * <p> If this object represents a class or interface that implements no
			 * interfaces, the method returns an array of length 0.
			 *
			 * @return an array of interfaces implemented by this class.
			 */
			getInterfaces : function getInterfaces() {
				return this.interfaces;
			},
			/**
			 * Returns a <code>Method</code> object that reflects the specified public
			 * member method of the class or interface represented by this
			 * <code>Class</code> object.
			 *
			 * <p> If the <code>name</code> isn't found
			 * <OL>
			 * <LI> C is searched for any <I>matching methods</I>. If no matching
			 * 	    method is found, the algorithm of step 1 is invoked recursively on
			 * 	    the superclass of C.</LI>
			 * <LI> If no method was found in step 1 above, the superinterfaces of C
			 *      are searched for a matching method. If any such method is found, it
			 *      is reflected.</LI>
			 * </OL>
			 *
			 * @param {String} name the name of the method
			 * @return a <code>Method</code> object that reflects the specified member
			 * 			method
			 */
			getMethod : function getMethod(name) {
				var len, method, methods = this.getMethods();
				while (len--) {
					method = methods[len];
					if (method.getName() == name) {
						return method;
					}
				}
				return null;
			},
			/**
			 * Returns an array containing <code>Method</code> objects reflecting all
			 * the public <em>member</em> methods of the class or interface represented
			 * by this <code>Class</code> object, including those declared by the class
			 * or interface and those inherited from superclasses and
			 * superinterfaces.  Array classes return all the (public) member methods
			 * inherited from the <code>Object</code> class.  The elements in the array
			 * returned are not sorted and are not in any particular order.  This
			 * method returns an array of length 0 if this <code>Class</code> object
			 * represents a class or interface that has no public member methods, or if
			 * this <code>Class</code> object represents a primitive type or void.
			 *
			 * @return the array of <code>Method</code> objects representing the
			 * 			public methods of this class
			 */
			getMethods : function getMethods() {
				var methods = this.getDeclaredMethods();
				var sc = this.getGenericSuperclass();
				while (sc) {
					methods = methods.concat(sc.getDeclaredMethods());
					if (sc.type == Object) {
						methods.push(new Method(sc.type, "hasOwnProperty"));
						methods.push(new Method(sc.type, "isPrototypeOf"));
						methods.push(new Method(sc.type, "propertyIsEnumerable"));
						methods.push(new Method(sc.type, "toLocaleString"));
						methods.push(new Method(sc.type, "toString"));
						methods.push(new Method(sc.type, "valueOf"));
						break;
					}
					sc = sc.getGenericSuperclass();
				}
				return methods;
			},
			/**
			 * Returns the  name of the entity (class, interface, array class,
			 * primitive type, or void) represented by this <tt>Class</tt> object,
			 * as a <tt>String</tt>.
			 *
			 * @return  the name of the class or interface
			 *          represented by this object.
			 */
			getName : function getName() {
				return this.name;
			},
			/**
			 * Gets the package for this class.  The class loader of this class is used
			 * to find the package.  If the class was loaded by the bootstrap class
			 * loader the set of packages loaded from CLASSPATH is searched to find the
			 * package of the class. Null is returned if no package object was created
			 * by the class loader of this class.
			 *
			 * <p> Packages have attributes for versions and specifications only if the
			 * information was defined in the manifests that accompany the classes, and
			 * if the class loader created the package instance with the attributes
			 * from the manifest.
			 *
			 * @return the package of the class, or null if no package
			 *         information is available from the archive or codebase.
			 */
			getPackage : function getPackage() {
				var pkname = this.getName().split(".");
				pkname = pkname.splice(0, pkname.length - 1);
				return Package.getPackage(pkname.join("."));
			},
			/**
			 * Returns the "simple binary name" of the underlying class, i.e.,
			 * the binary name without the leading enclosing class name.
			 * Returns <tt>null</tt> if the underlying class is a top level
			 * class.
			 *
			 * @return the binary name of the underlying class
			 */
			getSimpleBinaryName : function getSimpleBinaryName() {
				var enclosingClass = this.getEnclosingClass();
				// top level class
				if (enclosingClass == null)
					return null;
				//console.log(Type.getClassName(enclosingClass));
				// Otherwise, strip the enclosing class' name
				return this.getName().substring(Type.getClassName(enclosingClass).length);
			},
			/**
			 * Returns the simple name of the underlying class as given in the
			 * source code. Returns an empty string if the underlying class is
			 * anonymous.
			 *
			 * <p>The simple name of an array is the simple name of the
			 * component type with "[]" appended.  In particular the simple
			 * name of an array whose component type is anonymous is "[]".
			 *
			 * @return the simple name of the underlying class
			 */
			getSimpleName : function getSimpleName() {
				var simpleName = this.getSimpleBinaryName();
				if (simpleName == null) {// top level class
					simpleName = this.getName();
					return simpleName.substring(simpleName.lastIndexOf(".") + 1);
					// strip the package name
				}
				var length = simpleName.length;
				if (length < 1 || simpleName.charAt(0) != '$' || simpleName.charAt(0) != '@')
					throw new Error("InternalError Malformed class name");
				var index = 1;
				while (index < length && this.isAsciiDigit(simpleName.charAt(index)))
				index++;
				// Eventually, this is the empty string iff this is an anonymous class
				return simpleName.substring(index);
			},
			/**
			 * Returns the <code>Function</code> representing the superclass of the entity
			 * (class, interface, primitive type or void) represented by this
			 * <code>Class</code>.  If this <code>Class</code> represents either the
			 * <code>Object</code> class, an interface, a primitive type, or void, then
			 * null is returned.  If this object represents an array class then the
			 * <code>Class</code> object representing the <code>Object</code> class is
			 * returned.
			 *
			 * @return the superclass of the class represented by this object.
			 */
			getSuperclass : function getSuperclass() {
				return this.superclass;
			},
			/**
			 * Returns <tt>true</tt> if and only if the underlying class
			 * is an anonymous class.
			 *
			 * @return <tt>true</tt> if and only if this class is an anonymous class.
			 */
			isAnonymousClass : function isAnonymousClass() {
				return this.getSimpleName() == "";
			},
			/**
			 * Determines if this <code>Class</code> object represents an array class.
			 *
			 * @return  <code>true</code> if this object represents an array class;
			 *          <code>false</code> otherwise.
			 */
			isArray : function isArray() {
				return this.type == Array;
			},
			/**
			 * Test some non-ascii digits.
			 *
			 * @param {String} c the character to test
			 * @return false if this is non-ascii digits.
			 */
			isAsciiDigit : function isAsciiDigit(c) {
				return '0'.charCodeAt() <= c.charCodeAt() && c.charCodeAt() <= '9'.charCodeAt();
			},
			/**
			 * Determines if the class or interface represented by this
			 * <code>Class</code> object is either the same as, or is a superclass or
			 * superinterface of, the class or interface represented by the specified
			 * <code>Class</code> parameter. It returns <code>true</code> if so;
			 * otherwise it returns <code>false</code>. If this <code>Class</code>
			 * object represents a primitive type, this method returns
			 * <code>true</code> if the specified <code>Class</code> parameter is
			 * exactly this <code>Class</code> object; otherwise it returns
			 * <code>false</code>.
			 *
			 * @param {Function} cls the <code>Class</code> object to be checked
			 * @return the <code>boolean</code> value indicating whether objects of the
			 * 			type <code>cls</code> can be assigned to objects of this class
			 */
			isAssignableFrom : function isAssignableFrom(cls) {
				if ( cls instanceof Class) {
					return this.getInterfaces().indexOf(cls.getDeclaringClass()) != -1 || Class.getPrototypeChain(cls.getDeclaringClass()) != -1;
				} else if (cls == this.type || Class.getPrototypeChain( typeof cls == "function" ? cls : cls.constructor).indexOf(this.type) != -1) {
					return true;
				}
				return false;
			},
			/**
			 * Determines if the specified <code>Class</code> object represents an
			 * interface type.
			 *
			 * @return  <code>true</code> if this object represents an interface;
			 *          <code>false</code> otherwise.
			 */
			isInterface : function isInterface() {
				return this.constructor.itype;
			},
			/**
			 * Determines if the specified <code>Object</code> is assignment-compatible
			 * with the object represented by this <code>Class</code>.
			 *
			 * @param   obj the object to check
			 * @return  true if <code>obj</code> is an instance of this class
			 */
			isInstance : function isInstance(obj) {
				return obj instanceof this.type;
			},
			/**
			 * Returns <tt>true</tt> if and only if the underlying class
			 * is a local class.
			 *
			 * @return <tt>true</tt> if and only if this class is a local class.
			 */
			isLocalClass : function isLocalClass() {
				return !this.isAnonymousClass();
			},
			/**
			 * @return Returns <tt>true</tt> if this is a local class or an anonymous
			 * 			class. Returns <tt>false</tt> otherwise.
			 */
			isLocalOrAnonymousClass : function isLocalOrAnonymousClass() {
				return this.isLocalClass() || this.isAnonymousClass();
			},
			/**
			 * Returns <tt>true</tt> if and only if the underlying class
			 * is a member class.
			 *
			 * @return <tt>true</tt> if and only if this class is a member class.
			 */
			isMemberClass : function isMemberClass() {
				return this.getSimpleBinaryName() == null && !this.isLocalOrAnonymousClass();
			},
			/**
			 * Determines if the specified <code>Class</code> object represents a
			 * primitive type.
			 *
			 * @return true if and only if this class represents a primitive type
			 */
			isPrimitive : function isPrimitive() {
				return this.type == Boolean || this.type == String || this.type == Number;
			},
			/**
			 * Creates a new instance of the class represented by this <tt>Class</tt>
			 * object.  The class is instantiated as if by a <code>new</code>
			 * expression with an empty argument list.
			 * @param {Array} parameters vargs parameters
			 * @return a newly allocated instance of the class represented by this
			 *         object.
			 */
			newInstance : function newInstance() {
				return Type.getInstance.apply(Type, [this.type].concat(Type.toArray(arguments)));
			},
			/**
			 * Converts the object to a string. The string representation is the
			 * string "class" or "interface", followed by a space, and then by the
			 * fully qualified name of the class in the format returned by
			 * <code>getName</code>.  If this <code>Class</code> object represents a
			 * primitive type, this method returns the name of the primitive type.  If
			 * this <code>Class</code> object represents void this method returns
			 * "void".
			 *
			 * @return a string representation of this class object.
			 */
			toString : function toString() {
				return (this.isInterface() ? "interface " : "class ") + this.getName();
			},
			/**
			 * Returns an array of <code>Field</code> objects reflecting all the fields
			 * declared by the class or interface represented by this
			 * <code>Class</code> object. This includes public, protected, default
			 * (package) access, and private fields, but excludes inherited fields.
			 * The elements in the array returned are not sorted and are not in any
			 * particular order.  This method returns an array of length 0 if the class
			 * or interface declares no fields, or if this <code>Class</code> object
			 * represents a primitive type, an array class, or void.
			 *
			 * @return the array of <code>Field</code> objects representing all the
			 * 			declared fields of this class
			 */
			statics : {
				/**
				 * Bind the specified object to the the specified callback
				 *
				 * @param {Object} scope the subject
				 * @param {Function} callback the method to bind
				 * @return the binded function
				 */
				bind : function bind(scope, callback) {
					var args = Type.toArray(arguments);
					args = args.splice(2, args.length);
					return function doBinding() {
						return callback.apply(scope, args.concat(Type.toArray(arguments)));
					};
				},
				/**
				 * The create method is used to declare a new Javascript class, which is
				 * a collection of related variables and/or methods. Types are the basic
				 * building blocks of object−oriented programming. A type typically represents
				 * some real−world entity such as a geometric Shape or a Person. A class
				 * is a template for an object. Every object is an instance of a class. To
				 * use a class, you instantiate an object of the class, typically with the
				 * new operator, then call the declared methods to access the features of
				 * the class.
				 *
				 * @param {String} qname the fully qualified class name
				 * @param {Object} superclass the super class
				 * @param {Array} interfaces a list of interfaces to implements
				 * @param {Object} subclass the class definition
				 * @param {Object} namespace the global scope where live the class
				 * @return the created class otherwise null
				 */
				create : function create(parameters/*qname, superclass, interfaces, subclass, namespace*/) {
					var qname = parameters["qname"];
					var subclass = parameters["subclass"];
					var superclass = parameters["superclass"] || Object;
					var namespace = Type.namespace(parameters["namespace"]);
					var linker = parameters["linker"];
					var enclosingClass, pkg, cname = Type.normalizeComponents(qname);
					if (cname.length > 1) {
						var namespace, len = arguments.length;
						pkg = cname.splice(0, cname.length - 1);
						pkg = Package.create(pkg.join("."), namespace, linker);
						//internal class
						if (!( pkg instanceof Package)) {
							enclosingClass = pkg;
							var ns = pkg.slot.split(".");
							pkg = Package.create(ns.slice(0, ns.length - 1).join("."), namespace, linker);
						}
					}
					var c = Type.inherit(parameters);
					if (!Type.ownedProperty(subclass, "bind")) {
						c.prototype.bind = function bind() {
							return Class.bind.apply(Class, [this].concat(Type.toArray(arguments)));
						};
					}
					if (!Type.ownedProperty(subclass, "hashCode")) {
						c.prototype.hashCode = function hashCode() {
							return Class.hashCode(c);
						};
					}
					if (!Type.ownedProperty(subclass, "clone")) {
						c.prototype.clone = function clone() {
							return new c();
						};
					}
					if (!Type.ownedProperty(subclass, "finalize")) {
						c.prototype.finalize = function finalize() {
						};
					}
					if (!Type.ownedProperty(subclass, "equals")) {
						c.prototype.equals = function equals(obj) {
							if (this == obj) {
								return true;
							}
							return obj instanceof c && Type.objectEquals(this, obj);
						};
					}
					if (!Type.ownedProperty(subclass, "toString")) {
						c.prototype.toString = function toString() {
							return "[object " + c.slot + "@" + this.hashCode().toString(16) + "]";
						};
					}
					if (!Type.ownedProperty(subclass, "getClass")) {
						c.prototype.getClass = function getClass() {
							var c = new Class(this.constructor);
							c.getEnclosingClass = function getEnclosingClass() {
								return enclosingClass;
							};
							c.getPackage = function getPackage() {
								return pkg;
							};
							return c;
						};
					}
					return c;
				},
				/**
				 * Returns the <code>Class</code> object associated with the class or
				 * interface with the given string name.
				 *
				 * @param {String} className the fully qualified name of the desired class.
				 * @param {Object} namespace the optional namespace.
				 * @return the <code>Class</code> object for the class with the
				 *         specified name.
				 */
				forName : function forName(qualifiedClassName, namespace) {
					return Type.getTypeByName(qualifiedClassName, namespace);
				},
				/**
				 * Creates a new instance of the class represented by the specified
				 * class object.
				 *
				 * @param {Object} type the class to instanciate
				 * @return the instanciated class otherwise null
				 */
				getInstance : function(type) {
					return Type.getInstance.apply(Type, Type.toArray(arguments));
				},
				/**
				 * Return the Javascript's Class object for the named
				 * primitive type.
				 *
				 * @param {String} name the name of the primitive type
				 * @return the named primitive type otherwise null.
				 */
				getPrimitiveClass : function getPrimitiveClass(name) {
					var lname = name.toLowerCase();
					if (lname == "boolean")
						return Boolean;
					else if (lname == "number")
						return Number;
					else if (lname == "string")
						return String;
					return null;
				},
				/**
				 * Return thprototype chaine of the specified class
				 *
				 * @param {Object} type the class to reflect
				 * @return Array with all the specified class superclasses
				 */
				getPrototypeChain : function getPrototypeChain(type) {
					if (!type) {
						throw new TypeError("IllegalArgumentsException");
					}
					var chain = [];
					if (type.constructor == Object) {
						return chain;
					}
					var o;
					var sc = Class.getSuperTypeOf(type);
					if (sc == Object) {
						chain.push(sc);
						return chain;
					}
					while (sc != null) {
						chain.push(sc);
						sc = Class.getSuperTypeOf(sc);
						if (sc == Object) {
							chain.push(sc);
							break;
						}
					}
					return chain;
				},
				/**
				 * Return the superclass of the specified class.
				 *
				 * @param {Object} type the class to reflect
				 * @return the superclass of the specified class otherwise null
				 */
				getSuperClassOf : function getSuperClassOf(type) {
					if (type) {
						var proto = type.prototype;
						if (proto) {
							return Object.getPrototypeOf(proto);
						}
					}
					return null;
				},
				/**
				 * Return the prototype of the superclass of the specified class.
				 *
				 * @param {Object} object type the class to reflect
				 * @return the prototype of the superclass of the specified class
				 * 			otherwise null
				 */
				getSuperPrototypeOf : function getSuperPrototypeOf(type) {
					if (type) {
						var c = Object.getPrototypeOf(type).constructor;
						if (c) {
							var proto = c.prototype;
							if (proto) {
								return Object.getPrototypeOf(proto);
							}
						}
					}
					return null;
				},
				/**
				 * Add a package name prefix if the name is not absolute Remove leading
				 * "/" if name is absolute
				 *
				 * @param {Class} type the class
				 * @param {String} name the name to resolve
				 */
				resolveName : function resolveName(type, name) {
					if (name == null) {
						return name;
					}
					if (name.indexOf("/") != 0) {
						var baseName = type.getName();
						var index = baseName.lastIndexOf('.');
						if (index != -1) {
							name = baseName.substring(0, index).replace('.', '/') + "/" + name;
						}
					} else {
						name = name.substring(1);
					}
					return name;
				}
			},

			name : "",
			type : null,
			interfaces : null,
			superclass : false

		},
		namespace : SHINOBI_NAMESPACE
	});

	/*****************************
	 *
	 * SYSTEM
	 *
	 ******************************/

	/**
	 * The <code>System</code> class contains several useful class fields
	 * and methods. It cannot be instantiated.
	 *
	 * <p>Among the facilities provided by the <code>System</code> class
	 * are standard input, standard output, and error output streams;
	 * access to externally defined properties and environment
	 * variables; a means of loading files and libraries; and a utility
	 * method for quickly copying a portion of an array.
	 *
	 * @author Aime Biendo
	 */
	var System = Type.inherit({
		qname : "shinobi.System",
		subclass : {
			/** Don't let anyone instantiate this class */
			constructor : function System() {
				throw new TypeError("Illegal Instansiation Exception");
			},
			statics : {

				/*****************************
				 *
				 * PREPROCESSOR MACROS
				 *
				 ******************************/

				/**
				 * Expands to an integer starting with 0 and incrementing by 1 every time it
				 * is used in a source file or included headers of the source file.
				 * __COUNTER__ remembers its state.
				 *
				 * @return the inctrement count
				 */
				__COUNTER__ : function __COUNTER__() {
					var n = System.COUNTER;
					System.COUNTER = n + 1;
					return n;
				},
				/**
				 * Activate the DEBUG mode.
				 *
				 * @param {Boolean} state the debug mode
				 * @return the mode
				 */
				__DEBUG__ : function __DEBUG__(state) {
					if (state != undefined) {
						System.DEBUG = state;
					}
					return System.DEBUG;
				},
				/**
				 * Return the line number in the current source file. The line number is a decimal
				 * integer constant.
				 *
				 * @param {Error} ex the Exception to intercept
				 * @return the line number or -1
				 */
				__LINE__ : function __LINE__(ex) {
					try {
						var err = ex || new Error();
						if (Type.ownedProperty(err, "lineNumber")) {
							return err.lineNumber;
						} else if (Type.ownedProperty(err, "stack")) {
							var stack = err.stack;
							stack = stack.split("at")[1].split(":");
							return stack[stack.length - 2];
						}
					} catch(e) {
					}
					return -1;
				},

				/*****************************
				 *
				 * PREPROCESSOR DIRECTIVES
				 *
				 ******************************/

				/**
				 * Copies an array from the specified source array, beginning at the
				 * specified position, to the specified position of the destination array.
				 * A subsequence of array components are copied from the source
				 * array referenced by <code>src</code> to the destination array
				 * referenced by <code>dest</code>. The number of components copied is
				 * equal to the <code>length</code> argument. The components at
				 * positions <code>srcPos</code> through
				 * <code>srcPos+length-1</code> in the source array are copied into
				 * positions <code>destPos</code> through
				 * <code>destPos+length-1</code>, respectively, of the destination
				 * array.
				 * <p>
				 * If the <code>src</code> and <code>dest</code> arguments refer to the
				 * same array object, then the copying is performed as if the
				 * components at positions <code>srcPos</code> through
				 * <code>srcPos+length-1</code> were first copied to a temporary
				 * array with <code>length</code> components and then the contents of
				 * the temporary array were copied into positions
				 * <code>destPos</code> through <code>destPos+length-1</code> of the
				 * destination array.
				 * <p>
				 * If <code>dest</code> is <code>null</code>, then a
				 * <code>NullPointerException</code> is thrown.
				 * <p>
				 * If <code>src</code> is <code>null</code>, then a
				 * <code>NullPointerException</code> is thrown and the destination
				 * array is not modified.
				 * <p>
				 * Otherwise, if any of the following is true, an
				 * <code>ArrayStoreException</code> is thrown and the destination is
				 * not modified:
				 * <ul>
				 * <li>The <code>src</code> argument refers to an object that is not an
				 *     array.
				 * <li>The <code>dest</code> argument refers to an object that is not an
				 *     array.
				 * <li>The <code>src</code> argument and <code>dest</code> argument refer
				 *     to arrays whose component types are different primitive types.
				 * <li>The <code>src</code> argument refers to an array with a primitive
				 *    component type and the <code>dest</code> argument refers to an array
				 *     with a reference component type.
				 * <li>The <code>src</code> argument refers to an array with a reference
				 *    component type and the <code>dest</code> argument refers to an array
				 *     with a primitive component type.
				 * </ul>
				 * <p>
				 * Otherwise, if any of the following is true, an
				 * <code>IndexOutOfBoundsException</code> is
				 * thrown and the destination is not modified:
				 * <ul>
				 * <li>The <code>srcPos</code> argument is negative.
				 * <li>The <code>destPos</code> argument is negative.
				 * <li>The <code>length</code> argument is negative.
				 * <li><code>srcPos+length</code> is greater than
				 *     <code>src.length</code>, the length of the source array.
				 * <li><code>destPos+length</code> is greater than
				 *     <code>dest.length</code>, the length of the destination array.
				 * </ul>
				 * <p>
				 * Otherwise, if any actual component of the source array from
				 * position <code>srcPos</code> through
				 * <code>srcPos+length-1</code> cannot be converted to the component
				 * type of the destination array by assignment conversion, an
				 * <code>ArrayStoreException</code> is thrown. In this case, let
				 * <b><i>k</i></b> be the smallest nonnegative integer less than
				 * length such that <code>src[srcPos+</code><i>k</i><code>]</code>
				 * cannot be converted to the component type of the destination
				 * array; when the exception is thrown, source array components from
				 * positions <code>srcPos</code> through
				 * <code>srcPos+</code><i>k</i><code>-1</code>
				 * will already have been copied to destination array positions
				 * <code>destPos</code> through
				 * <code>destPos+</code><i>k</I><code>-1</code> and no other
				 * positions of the destination array will have been modified.
				 * (Because of the restrictions already itemized, this
				 * paragraph effectively applies only to the situation where both
				 * arrays have component types that are reference types.)
				 *
				 * @param      src      the source array.
				 * @param      srcPos   starting position in the source array.
				 * @param      dest     the destination array.
				 * @param      destPos  starting position in the destination data.
				 * @param      length   the number of array elements to be copied.
				 */
				arrayCopy : function arrayCopy(src, srcPos, destPos, length) {
					var src, srcPos = 0, dest, destPos = 0, length;
					if (arguments.length === 2) {
						src = arguments[0];
						dest = arguments[1];
						length = src.length;
					} else if (arguments.length === 3) {
						src = arguments[0];
						dest = arguments[1];
						length = arguments[2];
					} else if (arguments.length === 5) {
						src = arguments[0];
						srcPos = arguments[1];
						dest = arguments[2];
						destPos = arguments[3];
						length = arguments[4];
					}
					for (var i = srcPos, j = destPos; i < length + srcPos; i++, j++) {
						if (dest[j] !== undef) {
							dest[j] = src[i];
						} else {
							throw new Error("IndexOutOfBoundsException");
						}
					}
				},
				/**
				 * Test if the Ssytem is booted
				 *
				 * @return true otherwise false
				 */
				booted : function booted() {
					return System.BOOTED;
				},
				/**
				 * Check if the specified key value is valid
				 *
				 * @param {String} key the string to test
				 */
				checkKey : function checkKey(key) {
					if (key == null) {
						throw new Error("NullPointerException key can't be null");
					}
					if (key == "") {
						throw new Error("IllegalArgumentException key can't be empty");
					}
				},
				/**
				 * Removes the system property indicated by the specified key.
				 * <p>
				 * First, if a security manager exists, its
				 * <code>SecurityManager.checkPermission</code> method
				 * is called with a <code>PropertyPermission(key, "write")</code>
				 * permission. This may result in a SecurityException being thrown.
				 * If no exception is thrown, the specified property is removed.
				 * <p>
				 *
				 * @param {key} key the name of the system property to be removed.
				 * @return the previous string value of the system property,
				 *         or <code>null</code> if there was no property with that key.
				 */
				clearProperty : function clearProperty(key) {
					System.checkKey(key);
					return props.remove(key);
				},
				/**
				 * Return the value of a constant defined with define
				 *
				 * @param {String} identifier the name of the contant to retrieve
				 * @return the constant value otherwise an exception is thrown
				 */
				constant : function constant(identifier) {
					if (Type.ownedProperty(System.CONSTANTS, identifier)) {
						return System.CONSTANTS[identifier];
					}
					throw new Error("Invalid constant identifier " + identifier);
				},
				/**
				 * Returns the unique console object associated
				 * with the current Shinobi application, if any.
				 *
				 * @return  The system console, if any, otherwise <tt>null</tt>.
				 */
				console : function console() {
					return window.console;
				},
				/**
				 * Returns the current time in milliseconds.  Note that
				 * while the unit of time of the return value is a millisecond,
				 * the granularity of the value depends on the underlying
				 * operating system and may be larger.  For example, many
				 * operating systems measure time in units of tens of
				 * milliseconds.
				 *
				 * <p> See the description of the class <code>Date</code> for
				 * a discussion of slight discrepancies that may arise between
				 * "computer time" and coordinated universal time (UTC).
				 *
				 * @return  the difference, measured in milliseconds, between
				 *          the current time and midnight, January 1, 1970 UTC.
				 */
				currentTimeMillis : function currentTimeMillis() {
					return new Date().getTime();
				},
				/**
				 * The enumeration keyword is used to declare an enumeration, a distinct
				 * type that consists of a set of named constants called the enumerator list.
				 * Usually it is best to define an enum directly within a namespace so that
				 * all classes in the namespace can access it with equal convenience. However,
				 * an enum can also be nested within a class or struct.
				 * By default, the first enumerator has the value 0, and the value of each
				 * successive enumerator is increased by 1. For example, in the following
				 * enumeration, Sat is 0, Sun is 1, Mon is 2, and so forth.
				 *
				 * @param {String} identifier_string the enumeration id
				 * @param {String} constants_identifiers the enumeration constants
				 * @return the created enumeration
				 */
				enumeration : function enumeration(identifier_string, constants_identifiers) {
					var e;
					if (arguments.length == 2) {
						var part;
						if (constants_identifiers == "*") {
							return System.ENUM[identifier_string];
						} else if (constants_identifiers.indexOf("*.") != -1) {
							var index = constants_identifiers.indexOf("*.");
							part = constants_identifiers.substring(index, constants_identifiers.length);
							return System.ENUM[identifier_string][part];
						} else if (constants_identifiers == "") {
							var old = System.ENUM[identifier_string];
							delete System.ENUM[identifier_string];
							return old;
						}
						var c, n, p = constants_identifiers.split(",");
						var len = p.length;
						e = {};
						while (len--) {
							c = p[len];
							if (c.indexOf("=") != -1) {
								part = c.split("=");
								c = part[0];
								n = parseInt(part[1]);
								e[c] = !isNaN(n) ? n : len;
							} else {
								e[c] = len;
							}
						}
						System.ENUM[identifier_string] = e;
					} else {
						e = System.ENUM[identifier_string];
					}
					return e;
				},
				/**
				 * Error directives produce compiler-time error messages. The error messages
				 * include the argument token-string. These directives are most useful for
				 * detecting programmer inconsistencies and violation of constraints during
				 * preprocessing. When error_ directives are encountered, compilation terminates.
				 *
				 * @param {String} token_string the error message
				 */
				exception : function exception(token_string) {
					throw new Error(token_string);
				},
				/**
				 * Gets the value of the specified environment variable. An
				 * environment variable is a system-dependent external named
				 * value.
				 *
				 * @param {String} name the name of the environment variable
				 * @return the string value of the variable, or <code>null</code>
				 *         if the variable is not defined in the system environment
				 */
				getenv : function getenv(name) {
					return System.ENV[name];
				},
				/**
				 * Determines the current system properties.
				 * <p>
				 * The current set of system properties for use by the
				 * getProperty(String) method is returned as a
				 * <code>Properties</code> object. If there is no current set of
				 * system properties, a set of system properties is first created and
				 * initialized. This set of system properties always includes defualrt
				 * values. Multiple paths in a system property value are separated
				 * by the path separator character of the platform.
				 *
				 * @return the system properties otherwise null
				 */
				getProperties : function getProperties() {
					return System.props;
				},
				/**
				 * Gets the system property indicated by the specified key.
				 * <p>
				 * First, if there is a security manager, its
				 * <code>checkPropertyAccess</code> method is called with the
				 * <code>key</code> as its argument.
				 * <p>
				 * If there is no current set of system properties, a set of system
				 * properties is first created and initialized in the same manner as
				 * for the <code>getProperties</code> method.
				 *
				 * @param {String} key   the name of the system property.
				 * @param {String} def   a default value.
				 * @return the string value of the system property,
				 *         or the default value if there is no property with that key.
				 */
				getProperty : function getProperty(key, def) {
					System.checkKey(key);
					return props.getProperty(key, def);
				},
				/**
				 * Returns the same hash code for the given object as
				 * would be returned by the default method hashCode(),
				 * whether or not the given object's class overrides
				 * hashCode().
				 * The hash code for the null reference is zero.
				 *
				 * @param {Object} x object for which the hashCode is to be calculated
				 * @return  the hashCode
				 */
				identityHashCode : function identityHashCode(x) {
					if ( typeof obj === "string") {
						var hash = 0;
						for (var i = 0; i < obj.length; ++i)
							hash = hash * 31 + obj.charCodeAt(i) & 4294967295;
						return hash;
					}
					if ( typeof obj !== "object") {
						return obj & 4294967295;
					}
					if (obj.hashCode instanceof Function) {
						return obj.hashCode();
					}
					return Type.hashCode(obj.constructor);
				},
				/**
				 * Initialize any miscellenous operating system settings that need to
				 * be set for the class libraries
				 */
				initializeOSEnvironment : function initializeOSEnvironment(namespace) {
					//TODO File with system properties
					System.ENV = namespace;
					//initialize namespace env
					Package.exports({
						class_ : Class.create,
						export_ : Package.exports,
						import_ : Package.create,
						include_ : Linker.includes,
						module_ : Linker.modules,
						//namespace_ : shinobi.namespace,
						package_ : Package.definePackages
					}, namespace);

					//not booted for now
					System.BOOTED = false;
				},
				/**
				 * Initialize the system class. Called after Shinobi initialization.
				 *
				 * @param {String} profile an optional libraries to call at initialisation
				 * @param {Function} callback the completion listener of the bootlib
				 * @param {Object} namespace the named scope
				 */
				initializeSystemClass : function initializeSystemClass(profile, callback, namespace) {
					System.props = Properties.open(profile);
					//create and initailize default properties
					System.initProperties();
					//initialize Shinobi version and print it
					System.initializeVersion();
					//print properties
					System.props.list();
					// Initialize any miscellenous operating system settings that need to be
					// set for the class libraries. Currently this is no-op everywhere.
					System.initializeOSEnvironment(namespace);
					// Subsystems that are invoked during initialization can invoke
					// System.isBooted() in order to avoid doing things that should
					// wait until the application class linker has been set up.
					System.BOOTED = true;
					/*if (bootlib) {
					 // Load the boot library now in order to initialize user objects
					 var lib = System.loadLibrary(bootlib, callback, namespace);
					 return lib;
					 }*/
				},
				/**
				 * Initialize the shinobi system version.
				 * the platform version is updated, the sdk version too and the
				 * shinobi version itself has well
				 */
				initializeVersion : function initializeVersion() {
					console.log("******************************");
					var p = System.props;
					//initialize platform
					Version.init(Version, "platform", p.getProperty("platform.name"), p.getProperty("platform.version"), p.getProperty("platform.info"));
					//initialize sdk
					Version.init(Version, "sdk", p.getProperty("sdk.name"), p.getProperty("sdk.version"), p.getProperty("sdk.info"));
					//initialize Shinobi
					Version.init(Version, "shinobi", p.getProperty("shinobi.name"), p.getProperty("shinobi.version"), p.getProperty("shinobi.info"));
					//print informations
					Version.print();
					console.log("******************************");
				},
				/**
				 * Initialize the shinobi system variables :
				 * System properties. The following properties are guaranteed to be defined:
				 * <dl>
				 * <dt>project.version		<dd>project version number
				 * <dt>project.vendor		<dd>project vendor specific string
				 * <dt>project.vendor.url	<dd>project vendor URL
				 * <dt>project.home		<dd>project installation directory
				 * <dt>project.class.version	<dd>project class version number
				 * <dt>project.class.path	<dd>project classpath
				 * <dt>os.name		<dd>Operating System Name
				 * <dt>os.arch		<dd>Operating System Architecture
				 * <dt>os.version		<dd>Operating System Version
				 * <dt>file.separator	<dd>File separator ("/" on Unix)
				 * <dt>path.separator	<dd>Path separator (":" on Unix)
				 * <dt>line.separator	<dd>Line separator ("\n" on Unix)
				 * <dt>user.name		<dd>User account name
				 * <dt>user.home		<dd>User home directory
				 * <dt>user.dir		<dd>User's current working directory
				 * </dl>
				 */
				initProperties : function initProperties() {
					var loc, locparts, country, language, base, nav, slashIndex, parts, version, OSName;
					if (navigator.userLanguage) {
						// Explorer
						loc = navigator.userLanguage;
					} else if (navigator.language) {
						// FF
						loc = navigator.language;
					} else {
						//default
						loc = "en_EN";
					}
					if (loc.length == 2) {
						language = loc;
						country = loc.toUpperCase();
					} else {
						loc = loc.replace("-", "_");
						locparts = loc.split("_");
						language = locparts[0];
						country = locparts[1];
					}
					base = Linker.LOCATION_HREF;
					nav = Linker.NAVIGATOR;
					slashIndex = base.lastIndexOf("/");
					parts = nav.userAgent.split(/\s*[;)(]\s*/);
					version = /^Linux/.test(parts[3]) ? parts[6].split("/").pop() : parts[3].split(" ").pop();
					OSName = "Unknown OS";
					if (nav.appVersion.indexOf("Win") != -1) {
						OSName = "Win";
					} else if (nav.appVersion.indexOf("Mac") != -1) {
						OSName = "MacOS";
					} else if (nav.appVersion.indexOf("X11") != -1) {
						OSName = "UNIX";
					} else if (nav.appVersion.indexOf("Linux") != -1) {
						OSName = "Linux";
					} else {
						throw new Error("Unknown os");
					}
					var p = System.props;
					p.setProperty("project.home", base);
					p.setProperty("project.library.path", base + p.getProperty("project.library.path"));
					p.setProperty("project.ext.dirs", base + p.getProperty("project.ext.dirs"));
					p.setProperty("project.io.tmpdir", base + p.getProperty("project.io.tmpdir"));
					p.setProperty("project.class.path", base + p.getProperty("project.class.path"));
					p.setProperty("os.name", OSName);
					p.setProperty("os.arch", nav.platform);
					p.setProperty("os.version", version);
					p.setProperty("user.home", base);
					p.setProperty("user.dir", base + p.getProperty("user.dir"));
					p.setProperty("user.language", language);
					p.setProperty("user.region", country);
					p.setProperty("user.conf", p.getProperty("user.dir") + p.getProperty("user.conf"));
					p.setProperty("user.rsc", p.getProperty("user.dir") + p.getProperty("user.rsc"));
					p.setProperty("user.locale", p.getProperty("user.dir") + p.getProperty("user.locale"));
					p.setProperty("project.policy", p.getProperty("user.conf") + p.getProperty("project.policy"));
					p.setProperty("project.boot.class.path", p.getProperty("user.dir") + p.getProperty("project.boot.class.path"));
					p.setProperty("project.boot.library.path", p.getProperty("project.library.path") + p.getProperty("project.boot.library.path"));
				},
				/**
				 * Invoked by by System.initializeSystemClass just before returning.
				 * Subsystems that are invoked during initialization can check this
				 * property in order to avoid doing things that should wait until the
				 * application class linker has been set up.
				 *
				 * @return true if the system is booted
				 */
				isBooted : function isBooted() {
					return System.BOOTED;
				},
				/**
				 * Maps a library name into a platform-specific string representing
				 * a native library.
				 *
				 * @param  {String} libname the name of the library.
				 * @return a platform-dependent native library otherwise null.
				 */
				mapLibraryName : function mapLibraryName(libname, lib) {
					if (System.LIBRARIES[libname] == null) {
						System.LIBRARIES[libname] = lib;
					}
					return System.LIBRARIES[libname];
				},
				/**
				 * Loads a code file with the specified filename from the local file
				 * system as a dynamic library. The filename
				 * argument must be a complete path name.
				 *
				 * @param {String} filename the file to load.
				 * @param {Function} callback the completion listener.
				 * @return the code file source otherwise null
				 */
				load : function load(filename, callback) {
					return Linker.loadFile(filename, callback);
				},
				/**
				 * Loads the system library specified by the <code>libname</code>
				 * argument. The manner in which a library name is mapped to the
				 * actual system library is system dependent.
				 * <p>
				 * The call <code>System.loadLibrary(name)</code> is effectively
				 * equivalent to the call
				 * <blockquote><pre>
				 * Runtime.getRuntime().loadLibrary(name)
				 * </pre></blockquote>
				 *
				 * @param {String} libname the name of the library.
				 * @param {Function} callback the completion listener.
				 * @param {Object} namespace the named scope.
				 * @return the loaded system library
				 */
				loadLibrary : function loadLibrary(libname, callback, namespace) {
					return Linker.loadModule(libname, callback);
				},
				/**
				 * Returns the current value of the most precise available system
				 * timer, in nanoseconds.
				 *
				 * <p>This method can only be used to measure elapsed time and is
				 * not related to any other notion of system or wall-clock time.
				 * The value returned represents nanoseconds since some fixed but
				 * arbitrary time (perhaps in the future, so values may be
				 * negative).  This method provides nanosecond precision, but not
				 * necessarily nanosecond accuracy. No guarantees are made about
				 * how frequently values change. Differences in successive calls
				 * that span greater than approximately 292 years (2<sup>63</sup>
				 * nanoseconds) will not accurately compute elapsed time due to
				 * numerical overflow.
				 *
				 * <p> For example, to measure how long some code takes to execute:
				 * <pre>
				 *   var startTime = System.nanoTime() / 60;
				 *   // ... the code being measured ...
				 *   var estimatedTime = (System.nanoTime() - startTime) / 60;
				 * </pre>
				 *
				 * @return The current value of the system timer, in nanoseconds.
				 */
				nanoTime : function nanoTime() {
					if (window.performance) {
						if (window.performance.now) {
							return window.performance.now();
						} else if (window.performance.webkitNow) {
							return window.performance.webkitNow();
						}
					}
					return System.currentTimeMillis();
				},
				/**
				 * Sets the system properties to the <code>Properties</code>
				 * argument.
				 * <p>
				 * First, if there is a security manager, its
				 * <code>checkPropertiesAccess</code> method is called with no
				 * arguments. This may result in a security exception.
				 * <p>
				 * The argument becomes the current set of system properties for use
				 * by the {@link #getProperty(String)} method. If the argument is
				 * <code>null</code>, then the current set of system properties is
				 * forgotten.
				 *
				 * @param {Object} props   the new system properties.
				 */
				setProperties : function setProperties(props) {
					if (System.props == null) {
						System.props = new Properties();
						System.initProperties(props);
					} else {
						System.props.putAll(props);
					}
				},
				/**
				 * Sets the system property indicated by the specified key.
				 * <p>
				 * First, if a security manager exists, its
				 * <code>SecurityManager.checkPermission</code> method
				 * is called with a <code>PropertyPermission(key, "write")</code>
				 * permission. This may result in a SecurityException being thrown.
				 * If no exception is thrown, the specified property is set to the given
				 * value.
				 * <p>
				 *
				 * @param {String} key   the name of the system property.
				 * @param {String} value the value of the system property.
				 * @return the previous value of the system property,
				 *         or <code>null</code> if it did not have one.
				 */
				setProperty : function setProperty(key, value) {
					System.checkKey(key);
					return props.setProperty(key, value);
				},
				COUNTER : 0,
				DEBUG : false,
				LIBRARIES : {},
				ENV : {},
				BOOTED : false,
				props : null,
				//all constants
				CONSTANTS : {},
				//all Shinobi enums
				ENUM : {}
			}

		},
		namespace : SHINOBI_NAMESPACE
	});

	/*****************************
	 *
	 * LAUNCHER
	 *
	 ******************************/

	/**
	 * Implementation of this interface is intended to be the starting point of
	 * your application’s bootup process. Instead of starting your application
	 * directly in the PSVM method, as is done traditionally, you would relocate
	 * the logic for your application’s boot up sequence in a class that implements
	 * this interface. When the PSVM method is invoked by the application launcher,
	 * it would delegate the boot sequence of your application to your Launcher
	 * instance.
	 *
	 * @author Aime Biendo
	 */
	var Launcher = Type.inherit({
		qname : "Launcher",
		subclass : {
			constructor : function Launcher() {
				// if possible, use the "standard" way
				if (document.addEventListener) {
					document.addEventListener('DOMContentLoaded', Class.bind(this, this.ondomload), false);
				}
				// for Internet Explorer
				/*@cc_on @*/
				/*@if (@_win32)
				 var s = this;
				 document.write("<script id=__ie_ondomload defer src=javascript:void(0)><\/script>");
				 document.getElementById("__ie_ondomload").onreadystatechange=function() {
				 if (this.readyState=="complete") {
				 s.ondomload();
				 }
				 };
				 /*@end @*/
				setTimeout(Class.bind(this, this.domloadCheck), 100);
				// Just in case window.onload happens first, add it there, too
				this.addEventListener(window, 'load', Class.bind(this, this.ondomload));
			},
			/**
			 *
			 * @param {Object} obj
			 * @param {String} type
			 * @param {Function} listener
			 * @param {Boolean} useCapture
			 * @return
			 */
			addEventListener : function addEventListener(obj, type, listener, useCapture) {
				if (type == 'domload') {
					this.domloadEvents.push(listener);
					return true;
				}
				if (obj.addEventListener) {
					obj.addEventListener(type, listener, useCapture);
					return true;
				}
				if (obj.attachEvent) {
					return obj.attachEvent('on' + type, listener);
				}
				var f = obj['on' + type];
				obj['on' + type] = (f && typeof f == 'function') ? function() {
					f();
					fn();
				} : fn;
				return true;
			},
			/**
			 *
			 * @param {Event} evt
			 * @return
			 */
			getSrc : function getSrc(evt) {
				var s;
				evt = evt || window.event;
				if (evt.target) {
					s = evt.target;
				} else if (evt.srcElement) {
					s = evt.srcElement;
				}
				if (s.nodeType == 3) {
					// defeat Safari bug
					s = s.parentNode;
				}
				return s;
			},
			/**
			 * This is the launch interface. The method takes an array of objects
			 * that can be used to pass in arguments to launcher. The method’s
			 * signature makes easy to maintain the semantic of PSVM when using
			 * the Launcher.
			 *
			 * @param {...} vargs parameters to pass
			 */
			launch : function launch() {
				//abstract method override me on launching
			},
			/**
			 *
			 */
			ondomload : function ondomload() {
				if (this.domloadDone) {
					return;
				}
				this.domloadDone = true;
				for (var i = 0; i < this.domloadEvents.length; i++) {
					this.domloadEvents[i]();
				}
			},
			/**
			 *
			 */
			domloadCheck : function domloadCheck() {
				if (this.domloadDone) {
					return true;
				}
				var loaded = (/KHTML/i.test(navigator.userAgent)) && (/loaded|complete/.test(document.readyState));
				var eofAvail = document.getElementById && document.getElementById('domloadeof');
				// wait till the element with ID domloadeof is in the DOM or readyState=loaded on KHTML
				if (loaded || eofAvail) {
					this.ondomload();
				} else {
					// Not ready yet, wait a little more.
					setTimeout(Class.bind(this, this.domloadCheck), 100);
				}
				return true;
			},
			/**
			 *
			 * @param {Object} obj
			 * @param {String} type
			 * @param {Function} listener
			 * @param {Boolean} useCapture
			 */
			removeEventListener : function removeEventListener(obj, type, listener, useCapture) {
				if (obj.removeEventListener) {
					obj.removeEventListener(type, listener, useCapture);
					return true;
				}
				if (obj.detachEvent) {
					return obj.detachEvent('on' + type, listener);
				}
				console.log('Handler could not be removed!');
				return false;
			},

			domloadEvents : [],

			domloadDone : false
		},
		namespace : SHINOBI_NAMESPACE
	});

	/*****************************
	 *
	 * SHINOBI PACKAGE
	 *
	 ******************************/

	/**
	 * <code>Shinobi</code> is the startiing point of the API. This is the base
	 * Package of the framework living by default on the src/ folder.
	 *
	 * @see Type
	 * @see Class
	 * @see Method
	 * @see Field
	 * @see Linker
	 * @see Package
	 * @see Version
	 * @see System
	 * @see Trigger
	 * @author Aime Biendo
	 */
	var shinobi = Package.definePackages(SystemClassLinker.__PARAMETERS__()["dir"] + "-shinobi", function context(shinobi) {
		/**
		 * Make an alias of the specified symbol onto the specified namespace
		 *
		 * @param {Object} o the symbol to alias
		 * @param {String} alias the new id
		 * @param {Object} namespace the named scope
		 * @param {Linker} linker the specified linker
		 * @return the aliased symbol
		 */
		shinobi.alias = function alias(o, alias, namespace, linker) {
			namespace = Type.namespace(namespace);
			if (o == null) {
				return null;
			}
			var dir, parts, i, ns, components = Linker.extractPackageComponents(qualifiedClassName);
			dir = components.dir;
			alias = components.path;
			parts = Type.normalizeComponents(alias);
			for ( i = 0; i < parts.length; i++) {
				ns = parts[i];
				if (Type.ownedProperty(namespace, ns)) {
					namespace = namespace[ns];
				} else {
					namespace = namespace[ns] = i == parts.length - 1 ? o : Package.create(i == 0 ? (dir + ns) : ns, namespace, linker || this.getLinker());
				}
			}
			return namespace;
		};
		/**
		 * Return the bootsrap launcher
		 *
		 * @return The loader / launcher
		 */
		shinobi.getLauncher = function getLauncher() {
			return this.launcher;
		},
		/**
		 * Namespaces allow to group entities like classes, objects and functions
		 * under a name. This way the global scope can be divided in "sub-scopes",
		 * each one with its own name. Where pkg is any valid identifier and entities
		 * is the set of classes, objects and functions that are included within the
		 * namespace and identifier is is any valid identifier. The functionality of
		 * namespaces is especially useful in the case that there is a possibility that
		 * a global object or function uses the same identifier as another one, causing
		 * redefinition errors. We can declare alternate namespace aliases for existing
		 * namespaces.
		 *
		 * @param {String} identifier
		 * @param {String} alias
		 * @param {Object} namespace
		 * @param {Object} scope
		 * @return
		 */
		shinobi.namespace = function namespace(identifier, alias, namespace, scope, linker) {
			var dir, qualifier, isQualified, o, hasAliasObject, components;
			var index = identifier.indexOf("::");
			if (index != -1) {
				var tmp = identifier.split("::");
				identifier = tmp[0];
				qualifier = tmp[1];
			}
			//dir, qualifiedClassName, namespace, linker
			//get a namespace of an existing identifier from the global scope
			namespace = Package.create(identifier, namespace, linker || this.getLinker());
			if (!namespace) {
				return null;
			}
			//the second term is an object
			hasAliasObject = typeof alias == "object";
			scope = Type.namespace(scope || ( hasAliasObject ? alias : window));
			isQualified = qualifier && Type.ownedProperty(namespace, qualifier);
			//cyclic reference
			if (alias && alias == "window" || namespace == window && scope == window) {
				throw new ReferenceError("IllegalOperationException cyclic reference error " + alias);
			}
			//eval result
			o = isQualified ? namespace[qualifier] : namespace;
			//make alias
			if ( typeof alias == "string") {
				//make an alias
				o = shinobi.alias(o, alias, scope);
			}
			return o;
		};
		/**
		 * Set up the Shinobi initialization values
		 *
		 * @param {Object} namespace the default named scope
		 * @return the initialized Package
		 */
		shinobi.setup = function setup(namespace) {
			//accurate time
			var start = System.nanoTime() / 60;
			console.log("SHINOBI INIT STARTED AT " + start + " ns");
			//call prototype version of this decorated method
			this.constructor.prototype.setup.call(this);
			//make launcher
			this.launcher = new Launcher();
			//initialize systems
			System.initializeSystemClass(this.getPath() + this.profile, null, Type.namespace(namespace));
			//there is an entry point provided ?
			if (this.entryPoint != null && this.entryPoint != "") {
				//grab the main class path from src parameters
				var mainpath = SystemClassLinker.__PARAMETERS__()[this.entryPoint.toLowerCase()];

				//start listeneing domload event
				this.launcher.addEventListener(namespace, "domload", Class.bind(this, function ondomload() {
					
					//remove listener
					this.launcher.removeEventListener(namespace, "domload", ondomload);
					
					//main path exist in parameters?
					if (mainpath != null) {
						//ok add path to global linker
						this.ipath(mainpath.substring(0, mainpath.lastIndexOf("/") + 1));
						//include the main
						this.Main = Linker.includes(Linker.getBasename(mainpath));
						
						this.Main.main.apply(this.Main, [this.launcher]);
					}
					console.log("SHINOBI MAIN CALLED AFTER " + ((System.nanoTime() / 60) - start) + " ns");
				}));
			}
			console.log("SHINOBI CREATED IN " + ((System.nanoTime() / 60) - start) + " ns");
			return this;
		};
		/**
		 *
		 */
		shinobi.launcher = null;
		/**
		 *
		 */
		shinobi.Main = null;
		/**
		 *
		 */
		return shinobi.exports({
			/* Shinobi Classes */
			"Class" : Class,
			"Type" : Type,
			"ArrayUtil" : ArrayUtil,
			"Constructor" : Constructor,
			"Field" : Field,
			"Method" : Method,
			"Package" : Package,
			"Linker" : Linker,
			"SystemClassLinker" : SystemClassLinker,
			"Properties" : Properties,
			"Launcher" : Launcher,
			"System" : System,
			/* Shinobi Methods */
			"bind" : Class.bind,
			"includes" : Linker.includes,
			"modules" : Linker.modules

		}, shinobi).setup(namespace);

	}, namespace);

	//end core definitions
	return shinobi;

})(window);
