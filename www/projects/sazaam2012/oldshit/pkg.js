'use strict';
var Type = (function(){
	var name_r = /function([^\(]+)/, pkg_r = /::(.+)$/, abs_r = /^\//, sl = Array.prototype.slice, DEFS = {}, PKG_SEP = '::',
	getctorname = function(cl, name){ return (cl = cl.match(name_r))? cl[1].replace(' ', ''):'' },
	retrieve = function retrieve(from, prop, p){ try { p = from[prop] ; return p } finally { if(prop != 'constructor') from[prop] = undefined , delete from[prop] }},
	merge = function(from, into){ for(var s in from) if(s != 'constructor') into[s] = from[s], delete from[s] } ;
	return {
		appdomain:window,
		guid:0,
		format:function format(t, l){
			if(!t) return t ; // cast away undefined & null
			if(!!t.slot) return t ; // cast away custom classes
			if(!!t.hashcode) return Type.getDefinitionByHash(t) ; // is a slot object
			if(typeof t == 'number') return Type.getDefinitionByHash(t) ;
			if(typeof t == 'string') return Type.getDefinitionByName(t) ;
			if(!!t.slice && t.slice === sl && (l = t.length)) for(var i = 0 ; i < l ; i++) t[i] = format(t[i]) ;
			return t ;
		},
		hash:function hash(qname){
			for (var i = 0 , h = 0 ; i < qname.length ; i++) h = 31 * ((h << 31) - h) + qname.charCodeAt(i), h &= h ;
			return h ;
		},
		define:function define(properties){
			if(typeof properties == 'function') return Type.define(properties()) ;
			var staticinit ;
			var domain = retrieve(properties, 'domain') ;
			var superclass = retrieve(properties, 'inherits') ;
			var interfaces = retrieve(properties, 'interfaces') ;
			var statics = retrieve(properties, 'statics') ;
			var protoinit = retrieve(properties, 'protoinit') ;
			var def = retrieve(properties, 'constructor') ;
			var pkg = retrieve(properties, 'pkg') || '' ;
			var name = def == Object ? '' : (def.name || getctorname(def.toString())).replace(/Constructor$/, '') ;
			
			if(pkg_r.test(pkg)) pkg = pkg.replace(pkg_r, function(){name = arguments[1]; return ''}) ;
			if(!!Type.hackpath) pkg = abs_r.test(pkg) ? pkg.replace(abs_r, '') : pkg !='' ? Type.hackpath +'.'+ pkg : Type.hackpath ;
			if(name == '' ) name = 'Anonymous'+(++Type.guid) ;
			if(def == Object) def = Function('return function '+name+'(){\n\t\n}')() ;
			// set defaults
			var writable = !!domain ;
			domain = domain || Type.appdomain ;
			superclass = Type.format(superclass) || Object ;
			interfaces = Type.format(interfaces) || [] ;
			
			// set hashCode here
			var qname = pkg == '' ? name : pkg + PKG_SEP + name ;
			var hash = Type.hash(qname) ;
			// write classes w/ hash reference and if domain is specified, in domain
			(DEFS[hash] = def).slot = {
				appdomain:domain,
				qualifiedclassname:name,
				pkg:pkg,
				fullqualifiedclassname:qname,
				hashcode:hash,
				toString:function toString(){return 'Type@'+qname+'Definition'}
			} ;
			def.toString = function toString(){return '['+'class '+qname+']'}
			writable && (domain[name] = def) ; // Alias checks, we don't want our anonymous classes to endup in window or else
			(!!Type.hackpath) && Pkg.register(qname, def) ;
			var T = function(){
				// set base & factory references
				def.base = superclass ;
				def.factory = superclass.prototype ;
				// write overrides
				merge(properties, this) ;
				this.constructor = def ;
			}
			T.prototype = superclass.prototype ;
			def.prototype = new T() ;
			// protoinit 
			if (!!protoinit) protoinit.apply(def.prototype, [def, domain]) ;
			if (!!statics) {
				staticinit = retrieve(statics, 'initialize') ;
				merge(statics, def) ;
			}
			// static initialize
			if(!!staticinit) staticinit.apply(def, [def, domain]) ;
			Type.implement(def, interfaces.concat(superclass.slot ? superclass.slot.interfaces || [] : []), domain) ;
			return def ;
		},
		implement:function implement(def, imp, dom){
			var c, method, cname, ints = def.slot.interfaces = def.slot.interfaces || [] ;
			if(!!imp.slice && imp.slice === sl) {
				for(var i = 0, l = imp.length ; i < l ; i++) {
					c = imp[i].prototype , cname = imp[i].slot.fullqualifiedclassname ;
					for (method in c) {
						if(keep_r.test(method)) continue ;
						if(!def.prototype.hasOwnProperty(method)) throw new TypeError("NotImplementedMethodException ::" + method + "() in class " + def.slot.fullqualifiedclassname) ;
					}
					ints[ints.length] = cname ;
				}
			}else ints[ints.length] = imp.slot.fullqualifiedclassname ;
			return def ;
		},
		is:function is(instance, definition){ return instance instanceof definition },
		getType:function getType(type){ return (!!type.constructor && !!type.constructor.slot) ? type.constructor.slot : type.slot || 'unknown_type'},
		getDefinitionByName:function(qname, domain){ return (domain || Type.appdomain)[qname] || DEFS[Type.hash(qname)]},
		getDefinitionByHash:function(hashcode){ return DEFS[hashcode] },
		getAllDefinitions:function getAllDefinitions(){ return DEFS },
		getQualifiedClassName:function getQualifiedClassName(type){ return Type.getType(type).toString() },
		getFullQualifiedClassName:function getFullQualifiedClassName(type){ return Type.getType(type).fullqualifiedclassname }
	}
})() ;
var Pkg = (function(){
	var PKG = {} , sl = Array.prototype.slice, abs_r = /^\// ;
	
	return {
		register:function register(path, def){
			if(!!def.slot) // is already result of Type.define()
				path = def.slot.fullqualifiedclassname ;
			else {
				def.pkg = path ;
				def = Type.define(def) ;
				path = def.slot.fullqualifiedclassname ;
			}
			return (PKG[path] = def) ;
		},
		write:function write(path, obj){
			var oldpath = Type.hackpath ;
			try{
				// if obj is an Array
				if(obj.slice === sl) {
					for(var i = 0 , arr = [], l = obj.length ; i < l ; i ++)
						// if is an anonymous object, but with named References to write
						arr[arr.length] = write(path, obj[i]) ;
					return arr[arr.length - 1] ;
				}
				// if a function is passed
				else if(typeof obj == 'function'){
					if(!!obj.slot) return Pkg.register(path, obj) ;
					Type.hackpath = !!oldpath && !abs_r.test(path) ? oldpath + '.' +path : path.replace(abs_r, '') ;
					var o = new (obj)() ;
					return (!!o) ? !!o.slot ? write(path, o) : undefined : undefined ;
				}
				// if anonymous object is passed
				else return Pkg.register(path, obj) ;
			}catch(e){ trace(e) } finally {
				Type.hackpath = oldpath ; if(!!!oldpath) delete Type.hackpath ;
			}
		},
		definition:function definition(path){ return PKG[path] },
		getAllDefinitions:function getAllDefinitions(){ return PKG }
	}
})() ;


