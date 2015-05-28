'use strict' ;
(function(){
	
	var name_r = /function([^\(]+)/, pkg_r = /::(.+)$/, abs_r = /^\//, sl = Array.prototype.slice, DEFS = {}, PKG_SEP = '::',
	getctorname = function(cl, name){ return (cl = cl.match(name_r))? cl[1].replace(' ', ''):'' },
	retrieve = function retrieve(from, prop, p){ try { p = from[prop] ; return p } finally { if(prop != 'constructor') from[prop] = undefined , delete from[prop] }},
	merge = function(from, into){ for(var s in from) if(s != 'constructor'){ into[s] = from[s]; from[s] = undefined;} },
	PKG = {} ;
	var Type = {
		globals:{},
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
		getDefinitionByName:function(qname, domain){ return (domain || Type.appdomain)[qname] || Type.globals[qname] || DEFS[Type.hash(qname)]},
		getDefinitionByHash:function(hashcode){ return DEFS[hashcode] },
		getAllDefinitions:function getAllDefinitions(){ return DEFS },
		getQualifiedClassName:function getQualifiedClassName(type){ return Type.getType(type).toString() },
		getFullQualifiedClassName:function getFullQualifiedClassName(type){ return Type.getType(type).fullqualifiedclassname }
	}
	
	var Pkg = {
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
		definition:function definition(path){ return PKG[path] || Type.globals[path] },
		getAllDefinitions:function getAllDefinitions(){ return PKG }
	}
	
	// GLOBALS
	window.trace = function trace(){
		if(window.console === undefined) return arguments[arguments.length - 1] ;
		if('apply' in console.log) console.log.apply(console, arguments) ;
		else console.log([].concat([].slice.call(arguments))) ;
		return arguments[arguments.length - 1] ;
	}
	
	window.Type = Type ;
	window.Pkg = Pkg ;
	window.global = window ;
	
	
	Pkg.write('core', function(){
		
		var sl = Array.prototype.slice,
		toArray = function(arr){
			var p = [] ;
			var l = arr.length ;
			while(l--){
				p.unshift(arr[l]) ;
			}
			return p ;
		} ;
		
		var checkBase = function checkBase(){
			var scripts ;
			var scriptsH = toArray(document.getElementsByTagName("head")[0].getElementsByTagName("script")) ;
			if(!!document.getElementsByTagName("body")[0]){ // if is called within head or within body
				var scriptsB = toArray(document.getElementsByTagName("body")[0].getElementsByTagName("script")) ;
				scripts = scriptsH.concat(scriptsB) ;
			}else{
				scripts = scriptsH ;
			}
			
			var l = scripts.length ;
			var scr, root ;
			while(l--){
				var scr = scripts[l] ;
				root = scr.getAttribute('src') ;
				if(/struct.js/.test(root)) break ;
			}
			
			return {
				root:root.replace(/struct.js\?[^\?]+$/, ''),
				app:root.replace(/[^\?]+\?(app|main)=/, ''),
				base:window.location.href
			}
		}
		
		
		var pathes = checkBase() ;
		
		var base = pathes.base ;
		var app = pathes.app ;
		var root = pathes.root ;
		
		var main = './'+app ;
		
		var ModuleLoader = Type.define(function(){
			var bank = [
				function () {return new XMLHttpRequest()},
				function () {return new ActiveXObject("Msxml2.XMLHTTP")},
				function () {return new ActiveXObject("Msxml3.XMLHTTP")},
				function () {return new ActiveXObject("Microsoft.XMLHTTP")}
			] ;
			var cache = {} ;
			var generateXHR = function () {
				var xhttp = false;
				var l = bank.length ;
				for (var i = 0 ; i < l ; i++) {
					try {
					   xhttp = bank[i]();
					}
					catch (e) {
					   continue;
					}
					break;
				}
				return xhttp;
			} ;
			
			return {
				statics:{
					root:root
				},
				pkg:'load',
				domain:Type.globals,
				constructor:ModuleLoader = function ModuleLoader(url, complete, postData){
					var r = generateXHR() ;
					if (!r) return ;
					this.request = r ;
					this.url = ModuleLoader.root + url ;
					this.complete = complete ;
					this.userData = {
						post_data:postData,
						post_method:postData ? "POST" : "GET",
						ua_header:{ua:'User-Agent',ns:'XMLHTTP/1.0'},
						post_data_header: postData !== undefined ? {content_type:'Content-type',ns:'application/x-www-form-urlencoded'} : undefined 
					} ;	
				},
				destroy:function destroy(){
					var ud = this.userData ;
					for(var n in ud){
						ud[n] = undefined ;
						delete ud[n] ;
					}
					this.descriptor =
					this.response = 
					this.userData =
					this.url =
					this.request =
					undefined ;
					
					delete this.descriptor ;
					delete this.response ;
					delete this.userData ;
					delete this.url ;
					delete this.request ;

					return undefined ;
				},
				load:function load(url, async, force){
					var r = this.request ;
					var th = this ;
					var ud = this.userData ;
					var complete = this.complete ;
					
					var loc = !!url ? ModuleLoader.root + url : this.url ;
					
					if(loc in cache){
						this.response = cache[loc] ;
						if(async && !!th.complete) th.complete(r, th) ;
						return this ;
					}
					
					if(async === false){
						ud['post_method'] = 'GET' ;
						
						r.open(ud['post_method'], loc, false) ;                             
						r.onreadystatechange = function () {
							if (r.readyState != 4) return;
							if (r.status != 200 && r.status != 304) {
								if(!!th.onerror) th.onerror(r) ;
								return ;
							}
						}
						r.send(null) ;
						this.response = cache[loc] = this.request.responseText ;
						if(!!th.complete) th.complete(r, th) ;
						return this ;   
					}else{
						r.open(ud['post_method'] , loc, async || true) ;
						if (ud['post_data_header'] !== undefined) r.setRequestHeader(ud['post_data_header']['content_type'],ud['post_data_header']['ns']) ;
						r.onreadystatechange = function () {
							if (r.readyState != 4) return;
							if (r.status != 200 && r.status != 304) {
								if(!!th.onerror) th.onerror(r) ;
								return ;
							}
							th.response = cache[loc] = th.request.responseText ;
							if(!!th.complete) th.complete(r, th) ;
						}
						if (r.readyState == 4) return ;
						r.send(ud['postData']) ;
						return this ;
					}
				}
			} ;
		}) ;
		
		// Original Node.js API Classes
		
		var Module = Type.define({
			pkg:'modules',
			constructor:Module = function Module(id, filename){
				this.id = id ;
				this.filename = filename ;
				this.loaded = false ;
				this.exports = {} ;
			},
			destroy:function destroy(){
				
			}
		}) ;
		
		var OS = Type.define(function(){
			return {
				pkg:'sys',
				statics:{
					type:function type(){return 'Windows'}
				},
				constructor:OS = function OS(){}
			} ;
		}) ;
		
		var Path = Type.define(function(){
			return {
				pkg:'path',
				sep:OS.type() == 'Windows' ? '\\' : '/' ,
				constructor:Path = function Path(){},
				normalize:function normalize(p){},
				join:function join(/*...*/){},
				resolve:function resolve(){},
				relative:function relative(){},
				dirname:function dirname(p){},
				basename:function basename(p, ext/*[ext]*/){},
				extname:function extname(p, ext/*[ext]*/){}
			} ;
		}) ;
		
		var Assert = Type.define(function(){
			return {
				pkg:'test',
				constructor:Assert = function Assert(){
					
				},
				fail:function fail(actual, expected, message, operator){
					
					
				},
				equal:function equal(actual, expected, message/*Arr*/){},
				notEqual:function notEqual(actual, expected, message/*Arr*/){},
				deepEqual:function deepEqual(actual, expected, message/*Arr*/){},
				notDeepEqual:function notDeepEqual(actual, expected, message/*Arr*/){},
				strictEqual:function strictEqual(actual, expected, message/*Arr*/){},
				notStrictEqual:function notStrictEqual(actual, expected, message/*Arr*/){},
				throws:function throws(block, error/*Arr*/, message/*Arr*/){},
				doesNotThrow:function doesNotThrow(block, error/*Arr*/, message/*Arr*/){},
				ifError:function ifError(value){},
			} ;
		}) ;
		
		var cache = {} ;
		var path_r = /^[.]{0,2}\// ;
		var ext_r = /[.](js)$/ ;
		
		var as_file = function as_file(filename){
			var url = filename ;
			
			var mod = new ModuleLoader(url).load(undefined, false) ;
			var resp = mod.response ;
			var oldpath = Type.hackpath ;
			var module ;
			if(new RegExp(url+" not found").test(resp)) return as_dir(filename) ;
			
			if(filename == main) require.main = module ;
			
			Type.hackpath = '' ;
			module = new Module(filename, url) ;
			var r = new Function('module', '__filename', '__dirname', 'with(module){'+resp + '};return module;')(module, url, ModuleLoader.root) ;
			Type.hackpath = oldpath ;
			return r ;
		}
		
		var as_dir = function as_dir(filename){
			var baseurl = filename +'/' ;
			var url = baseurl + 'package.json' ;
			var mod = new ModuleLoader(url).load(undefined, false) ;
			var module ;
			var resp = mod.response ;
			var old = ModuleLoader.root ;
			var oldpath = Type.hackpath ;
			var r ;
			if(new RegExp(url+" not found").test(resp)){
				url =  baseurl + 'index.js' ;
				mod.load(url, false) ;
				resp = mod.response ;
				
				if(new RegExp(url+" not found").test(resp)) throw new Error('ModuleNotFoundError', url) ;
				
				Type.hackpath = '' ;
				ModuleLoader.root += baseurl ;
				module = new Module(filename, url) ;
				r = new Function('module', '__filename', '__dirname', 'with(module){'+resp + '};return module;')(module, url, ModuleLoader.root) ;
				ModuleLoader.root = old ;
				Type.hackpath = oldpath ;
			}else{
				var params = new Function('return '+resp)() ;
				url = baseurl + params.main ;
				mod.load(url, false) ;
				resp = mod.response ;
				
				if(new RegExp(url+" not found").test(resp)) throw new Error('ModuleNotFoundError', url) ;
				
				Type.hackpath = '' ;
				ModuleLoader.root += url.replace(/\/[^\/]+$/, '/') ;
				module = new Module(filename, url) ;
				r = new Function('module', '__filename', '__dirname', 'with(module){' + resp + '};return module;')(module, url, ModuleLoader.root) ;
				ModuleLoader.root = old ;
				Type.hackpath = oldpath ;
			}
			
			return r ;
		}
		
		var as_node_mods = function as_node_mods(filename){
			var baseurl = 'node_modules/' ;
			var url = baseurl + filename ;
			var mod = new ModuleLoader(url).load(undefined, false)
			var resp = mod.response ;
			var module ;
			var old = ModuleLoader.root ;
			var oldpath = Type.hackpath ;
			
			if(new RegExp(url+" not found").test(resp)) throw new Error('ModuleNotFoundError', url) ;
			
			Type.hackpath = '' ;
			ModuleLoader.root += baseurl ;
			module = new Module(filename, url) ;
			var r = new Function('module', '__filename', '__dirname', 'with(module){' + resp + '}; return module;')(module, url, ModuleLoader.root) ;
			ModuleLoader.root = old ;
			Type.hackpath = oldpath ;
			
			return r ;
		}
		
		// REQUIRE
		var require = window.require = function require(id){ // id is always string
			var s ;
			
			if(!!(s = cache[id])) return s instanceof Module ? s.exports : s ;
			// if id is core module [ended inevitabely in window]
			if(!!(s = window[id])) return s ;
			
			if(!!(s = Type.getDefinitionByName(id))) return s ;
			// if is present as name/id in Type definitions
			else if(!!(s=Type.getDefinitionByName(id))) return s ; 
			else if(path_r.test(id)){ // as_file
				// is path requested
				if(ext_r.test(id)) s = as_file(id) ;
				else s = as_dir(id) ;
			}else if(ext_r.test(id)){ 
				s = as_node_mods(id) ;
			}else{ // as_directory
				s = as_dir(id) ;
			}
			cache[id] = s ;
			return s.exports ;
		}
		require.cache = cache ;
		require(main) ;
		
	}) ;
	
})() ;






