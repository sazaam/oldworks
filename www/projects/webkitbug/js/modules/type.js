
(function Shinobi(domain) {
	
	var sl = Array.prototype.slice ;
	var hasProto = !!domain.Window && '__proto__' in domain.Window ; // check IE's support of Prototypes
	var Type = {
		
		/**
		 * Check settings on Prototype to be made
		 * Must be resolved along seperate support methods (cross-browser).
		 *
		 * @param {Object} definition the type declaration
		 * @param {Object} type the desired superclass
		 * @return the defined type with '__proto__' rightly set
		 */
		setProto : function setProto(def, ctor) {
			
			if(hasProto){
				if (!Type.ownedProperty(def, "__proto__")) {
					def["__proto__"] = {} ;
				}
				def.__proto__ = typeof ctor == "function" ? ctor.prototype : ctor ;
			}else{
				if(!def.hasOwnProperty('prototype'))
					def.prototype = {} ;
			}
			
			return def ;
		},
		mergePublics:function merge(from, into){
			
			for (p in from)
				if (p != "constructor") into[p] = from[p] ;
			
		},
		/**
		 * Define a type into an instance of the specified type. Before the type
		 * can be used it must be resolved.
		 *
		 * @param {Object} definition the type declaration
		 * @param {Object} type the desired superclass
		 * @return the defined type
		 */
		define : function define(definition, type) {
			var p, s, o, statics = definition["statics"],
			body = Type.setProto(definition, definition.constructor) ;
			
			// smart switch to make the anonymous object the base for our class
			definition = body.constructor ;
			
			// replace/set clean prototype ; // why ?!!!
			definition.prototype = new (type || function T(){}) ;
			
			// find static-meant declarations
			if (!!statics) {
				Type.mergePublics(statics, definition) ;
				delete body["statics"] ;
			}
			
			// now write proto
			Type.mergePublics(body, definition.prototype) ;
			
			return definition ;
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
				return null ;
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
		 * @param {Object} domain the named scope
		 * @return the instanciated type otherwise null
		 */
		getInstance : function getInstance(type, domain/*, ... parameters : Array*/) {
			try {
				var a, T, args, domain = Type.getDomain(domain);
				if ( typeof type == "string") {
					T = Type.getTypeByName(type, domain);
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
					return eval("var f = domain[fName]; new f(" + args.join(",") + ")");
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
		 * @param {Object} domain
		 * @return the type object for the class or interface with the specified
		 * 			name.
		 */
		getTypeByName : function getTypeByName(name, domain) {
			if (!name || typeof name != "string") {
				return null;
			}
			if (Type.ownedProperty( domain = Type.getDomain(domain), name)) {
				return domain[name];
			}
			var i, ns, p = Type.normalizeComponents(name), len = p.length;
			for ( i = 0; i < len; i++) {
				if (( ns = p[i]) && !( domain = domain[ns])) {
					return null;
				}
			}
			return domain ;
		},
		/**
		 * Returns a hash code value for the specified type.
		 *
		 * @param {Object} type the object to calculate hascode
		 * @return a hash code value for the specified type
		 */
		hashCode : function hashCode(type) {
			var c ;
			var hash = 0 ;
			var qualifiedClassName = Type.getClassName( typeof type == "function" ? type : type.constructor) ;
			if (qualifiedClassName.length == 0) {
				return hash ;
			}
			for ( i = 0; i < qualifiedClassName.length; i++) {
				c = qualifiedClassName.charCodeAt(i) ;
				hash = 31 * ((hash << 31) - hash) + c ;
				hash = hash & hash ;
			}
			return hash ;
		},
		/**
		 * The implements method is used in a type declaration to indicate that
		 * the class being declared provides implementations for all methods declared
		 * in the specified interfaces whose name are listed.
		 *
		 * @param {Object} definition the type being declared
		 * @param {Array} interfaces list of interfaces to implements
		 * @param {Object} domain the global scope where live the being
		 * 		declared
		 * @return the implemented type
		 */
		implement : function implement(type, interfaces, domain) {
			if (type == null) {
				return null;
			}
			interfaces = interfaces || [];
			var c, method, cname, len = interfaces ? interfaces.length : 0;
			domain = Type.getDomain(domain);
			type.interfaces = [];
			while (len--) {
				c = interfaces[len];
				if ( typeof c == "string") {
					cname = c;
					c = Type.getTypeByName(cname, domain);
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
		 * @param {Object} domain the global scope where live the type
		 * @return the created type otherwise null
		 */
		inherit : function inherit(/*qname, superclass, subclass, interfaces, domain*/) {
			// future new type base declaration
			var T = function T(){} ;
			// right arguments setting
			var qname, superclass, subclass, interfaces, domain ;
			var qname = arguments[0] ;
			var subclass = arguments[1] || {} ;
			var superclass = arguments[2] || Object ;
			var interfaces = arguments[3] || [] ;
			var domain = Type.getDomain(arguments[4]) ;
			
			var isinterface = qname.search("@") != -1 ;
			//default subclass
			subclass = !subclass ? o : ( typeof subclass == "string" ? (Type.getTypeByName(subclass) || o) : subclass) ;
			//default superclass
			superclass = !superclass ? Object : ( typeof superclass == "string" ? (Type.getTypeByName(superclass) || Object) : ( typeof superclass != "function" ? superclass.constructor : superclass)) ;
			
			// writing ...
			//set prototype of the new Type
			T.prototype = superclass.prototype ;
			// famous 'no-need to define' case avoiding
			if(subclass.constructor == Function) subclass.prototype = new T ;
			else subclass = Type.define(subclass, T) ;
			
			
			subclass.slot = qname ;
			subclass.base = superclass ;
			subclass.itype = isinterface ;
			subclass.factory = superclass.prototype ;
			subclass.prototype.constructor = subclass ;
			
			// interfaces
			subclass = Type.implement(subclass, interfaces, domain) ;
			
			// write extra toString method
			Type.toStringify(subclass) ;
			
			var parts = Type.normalizeComponents(qname) ;
			var nsname = parts.length >= 2 ? parts.splice(0, parts.length - 1).join(".") : "" ;
			
			var ns = nsname == "" ? domain : Type.getTypeByName(nsname, domain) ;
			
			var c = ns ? (ns[parts[parts.length - 1]] = subclass) : subclass ;
			
			var c = subclass ;
			
			//// PERHAPS ONE OF THE TWO ONLY ARE REALLY NEEDE HERE ?...
			if (c.prototype.cinit) {
				trace(c)
				c.prototype.cinit.apply(c.prototype, [c, domain]) ;
				delete c.prototype.cinit ;
			}
			
			if (c.prototype.iinit) {
				c.prototype.iinit.apply(c.prototype, [c.prototype]) ;
				delete c.prototype.iinit ;
			}
			
			return c ;
		},
		toStringify:function(cl){
			cl.toString = function toString() {
				return (cl.itype ? "[interface " : "[class ") + cl.slot + "]" ;
			};
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
		getDomain : function getDomain(ns, defaults) {
			return ns || defaults || window ;
		},
		/**
		 * Normalise a fully qualified class name.
		 *
		 * @param {Object} qualifiedClassName the name to normalize
		 * @return the normalized domain
		 */
		normalize : function normalize(qualifiedClassName) {
			return qualifiedClassName.replace(/\/|\$|::/g, ".") ;
		},
		/**
		 * Return a splited normalised fully qualified class name.
		 *
		 * @param {Object} qualifiedClassName the name to normalize and split
		 * @return the splited normalized domain
		 */
		normalizeComponents : function normalizeComponents(qualifiedClassName) {
			return Type.normalize(qualifiedClassName).split(".") ;
		},
		/**
		 * Tests if the specified objects are equals
		 *
		 * @param {Object} obj1 the first type to test
		 * @param {Object} obj2 the second type to test
		 * @return true otherwise false
		 */
		objectEquals : function objectEquals(obj1, obj2) {
			var i ;
			for (i in obj1) {
				if (Type.ownedProperty(obj1, i)) {
					if (!Type.ownedProperty(obj2, i)) {
						return false ;
					}
					if (obj1[i] != obj2[i]) {
						return false ;
					}
				}
			}
			for (i in obj2) {
				if (Type.ownedProperty(obj2, i)) {
					if (!Type.ownedProperty(obj1, i)) {
						return false ;
					}
					if (obj1[i] != obj2[i]) {
						return false ;
					}
				}
			}
			return true ;
		},
		ownedProperty : function ownedProperty(type, name) {
			if ('hasOwnProperty' in type) {
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
			return sl.call(parameters) ;
		}
	};

	return domain["Type"] = Type ;

})(window);