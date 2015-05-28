'use strict';
var Type = (function(){
	var DEFS = {},
	ctor_r = /function(?: (\w+))?\(/,
	tostring_r = /\[(?:object |class |interface )(\w*)\]/,
	arg_r = /\((.*)\)/,
	keep_r = /constructor|bind|clone|hashCode|hashcode|finalize|equals|toString|getClass/,
	sl = [].slice,
	retrieve = function retrieve(from, prop){
		var p = from[prop] ;
		try { return p } finally { if(prop != 'constructor') from[prop] = undefined , delete from[prop] }
	},
	guid = 0 ;
	return {
		appdomain:window,
		mergePublics:function merge(from, into){
			for (var p in from) if (p != "constructor") into[p] = from[p] ;
			return into ;
		},
		format:function format(t, l){
			if(!t) return t ; // cast away undefined & null
			if(!!t.slot) return t ; // cast away custom classes
			if(!!t.hashcode) return Type.getDefinitionByHash(t) ; // is a slot object
			if(typeof t == 'number') return Type.getDefinitionByHash(t) ;
			if(typeof t == 'string') return Type.getDefinitionByName(t) ;
			if(!!t.slice && t.slice === sl && (l = t.length)) for(var i = 0 ; i < l ; i++) t[i] = format(t[i]) ;
			return t ;
		},
		define:function define(def, apprentice, master, interfaces, qname, domain){
			var cname = Type.ctor(def) || 'Anonymous'+(++guid),
			dom = domain || Type.appdomain,
			T = Function('return function '+(cname)+'Definition(){\n\t\n}')(),
			isinterface = cname.search(/^IIII/) > -1,
			statics = retrieve(apprentice, 'statics'),
			protoinit = retrieve(apprentice, 'cinit'),
			init;
			// proto-hike it
			T.prototype = master.prototype ;
			def.constructor = T ;
			def.prototype = new T ;
			Type.mergePublics(apprentice, def.prototype) ;
			def.prototype.constructor = def ;
			// definition slot writiong
			qname = qname || cname ;
			def.slot = {
				fullqualifiedclassname:qname,
				appdomain:dom,
				constructorname:cname,
				hashcode:Type.hash(dom, qname),
				itype:isinterface,
				toString:function toString(){return qname}
			} ;
			
			// check for interfaces implementation
			Type.implement(def, interfaces, dom) ;
			// writing toString methods
			def.toString = function toString(){return '['+(def.slot.itype ? 'interface ':'class ')+qname+']'}
			def.prototype.toString = function toString(){return '[object '+qname+']'} ;
			
			// necessary inheritance (super) pointers
			def.base = master ;
			def.factory = master.prototype ;
			// hashcode set
			DEFS[def.slot.hashcode] = def ;
			// here write as alias name in local scope and as fullqualifiedclassname in global
			if(dom === Type.appdomain)
			dom[cname] = dom[qname] = def ;
			else // or as alias name and fullqualifiedclassname in local scope 
			dom[cname] = Type.appdomain[qname] = def ;
			// handling statics and static initialize
			if (!!statics) {
				init = retrieve(statics, 'initialize') ;
				Type.mergePublics(statics, def) ;
			}
			// prototype & static init triggers
			if(!!protoinit) {
				protoinit.apply(def.prototype, [dom, def]) ;
			}
			if(!!init){
				init.apply(def, [dom, def]) ;
			}
			return def ;
		},
		inherit:function inherit(qname, subclass, superclass, interfaces, domain){
			var cl = retrieve(subclass, 'constructor') ;
			var m = qname.split(/(::|[.])/) ;
			var cname = m[m.length - 1] ;
			if(cl === Object) {
				cl = Function('return function '+cname+'(){\n\t\n}')() ;
			}else{
				if(!cl.name && Type.ctor(cl) == '') throw new TypeError("a constructor method must be named when using Type.inherit " + qname);
			}
			
			superclass = Type.format(superclass) || Object ;
			interfaces = Type.format(interfaces) || [] ;
			
			if(!!subclass['domain']) domain = domain || retrieve(subclass,'domain') ;
			else domain = domain || Type.appdomain ;
			
			return Type.define(cl, subclass, superclass, interfaces, qname, domain) ;
		},
		implement:function implement(def, imp, dom){
			var c, method, cname, ints = def.interfaces = def.interfaces || [] ;
			if(!!imp.slice && imp.slice === sl) {
				var l = imp.length ;
				for(var i = 0 ; i < l ; i++) {
					c = imp[i].prototype ;
					cname = imp[i].slot.fullqualifiedclassname ;
					for (method in c) {
						if(keep_r.test(method)) continue ;
						if(!def.prototype.hasOwnProperty(method))
							throw new TypeError("NotImplementedMethodException " + cname + "::" + method + "() in class " + def.slot.fullqualifiedclassname);
					}
					ints[ints.length] = cname ;
				}
			}else{
				ints[ints.length] = imp.slot.fullqualifiedclassname ;
			}
			return def ;
		},
		mixin : function mixin(def, def2, exp) {
			for (var p in def2) if ((!!exp && exp(p)) || def2.hasOwnProperty(p)) def[p] = def2[p] ;
			return def ;
		},
		ctor:function(type){
			var s = type.toString() ;
			if(s.search(ctor_r) > -1) s = '[object '+ s.match(ctor_r)[1] +']' ;
			s = s.match(tostring_r)[1] ;
			return s ;
		},
		hash:function hash(domain, type){
			var dom = (domain === window) ? '__global__' : typeof domain == 'string' ? domain : Type.getQualifiedClassName(domain) ;
			var c, h = 0, qname = dom + '.'+ (typeof type == 'string' ? type : Type.getQualifiedClassName(type)) ;
			for (var i = 0 ; i < qname.length ; i++)
				h = 31 * ((h << 31) - h) + qname.charCodeAt(i) , h &= h ;
			return h ;
		},
		is:function is(instance, definition){
			return instance instanceof definition ;
		},
		getType:function getType(type){
			return !! type.constructor ? type.constructor.slot : type.slot ;
		},
		getDefinitionByName:function(qname, domain){
			return (domain || Type.appdomain)[qname] ;
		},
		getDefinitionByHash:function(hashcode){
			return DEFS[hashcode] ;
		},
		getQualifiedClassName:function getQualifiedClassName(type){
			return Type.getType(type) ;
		},
		getConstructorName:function getConstructorName(type){
			return Type.getType(type).constructorname ;
		}
	}
})() ;


var Class = function(ns, props, ext, impl, dom){
	return(Type.inherit(ns, props, ext, impl, dom)) ;
}
