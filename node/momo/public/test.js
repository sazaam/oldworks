
var ArrayUtil = Type.define({
	pkg:'utils::ArrayUtil',
	domain:Type.appdomain,
	statics:{
		slice:[].slice,
		isArray:function isArray(obj){
			return obj instanceof Array ;
		},
		argsToArray:function argsToArray(args){
			return ArrayUtil.slice.call(args) ;
		},
		indexOf:function indexOf(arr, obj){
			if('indexOf' in arr) return arr.indexOf(obj) ;
			for(var i = 0 , l = arr.length ; i < l ; i++ )
				if(arr[i] === obj) break ;
			
			return i ;
		}
	}
}) ;

// PROXY
var Proxy = Type.define(function(){
	var ns = {}, __global__ = window, returnValue = function(val, name){return val },
	toStringReg = /^\[|object ?|class ?|\]$/g ,
	DOMClass = function (obj) {
	
		if(obj.constructor !== undefined && obj.constructor.prototype !== undefined) return obj.constructor ;
		var tname = obj.tagName, kl, trans = { // Prototype.js' help here
		  "OPTGROUP": "OptGroup", "TEXTAREA": "TextArea", "P": "Paragraph","FIELDSET": "FieldSet", "UL": "UList", "OL": "OList", "DL": "DList","DIR": "Directory", "H1": "Heading", "H2": "Heading", "H3": "Heading","H4": "Heading", "H5": "Heading", "H6": "Heading", "Q": "Quote","INS": "Mod", "DEL": "Mod", "A": "Anchor", "IMG": "Image", "CAPTION":"TableCaption", "COL": "TableCol", "COLGROUP": "TableCol", "THEAD":"TableSection", "TFOOT": "TableSection", "TBODY": "TableSection", "TR":"TableRow", "TH": "TableCell", "TD": "TableCell", "FRAMESET":"FrameSet", "IFRAME": "IFrame", 'DIV':'Div', 'DOCUMENT':'Document', 'HTML':'Html', 'WINDOW':'Window'
		};
		
		if(!!!tname) {
			if(obj === window){
				tname = 'WINDOW' ;
			}else
			
			for(var s in window){
				if(obj == window[s]) {
					tname = s.toUpperCase() ;
					break ;
				}
			}
		}
		
		if(trans[tname] !== undefined) kl = (tname == 'Window') ? trans[tname] : 'HTML' + trans[tname] + 'Element' ;
		else kl = tname.replace(/^(.)(.+)$/, '$1'.toUpperCase() + '$2'.toLowerCase()) ;
		if(__global__[kl] === undefined) { 
			__global__[kl] = { } ;
			__global__[kl].prototype = document.createElement(tname)['__proto__'] ;
			__global__[kl].toString = function(){ return '[object '+kl+']' } ;
		}
		return window[kl] ;
	},
	getPropertyClosure = function(val, name, obj){
		var type = typeof val ;
		switch(type){
			case 'null': case 'undefined': case 'number': case 'string': case 'boolean':
				return function(){ return (arguments.length > 0 ) ? (obj[name] = arguments[0]) : obj[name] } ; break ;
			case 'object' :
				return function(o, o2){
					if(o !== undefined ){
						var tt = typeof o, ob = obj[name] ;
						if(tt == 'string' || tt == 'number') return (o2 === undefined) ? ob[o] : (ob[o] = o2) ;
						for(var s in o)
							ob[s] = o[s] ;
						return obj[name] ;
					}else return obj[name] ;
				} ; break ;
			case 'function' : return function(){ return obj[name].apply(obj, arguments) } ; break ;
			default : return val ; break ;
		}
	} ;
	
	return {
		pkg:'proxies',
		domain:Type.appdomain,
		statics:{
			getProxy:function(target){ return target['__proxy__'] },
			Class:function(t, o){return new Proxy(t, o, true) }
		},
		constructor:Proxy = function Proxy(target, override, toClass){
			
			var obj = target, cl = target.constructor, withoutnew = (this === __global__), tobecached = false, clvars, ret, func ;
			var name_r = /function([^\(]+)/ ;
			var getctorname = function(cl, name){ return (cl = cl.match(name_r))? cl[1].replace(' ', ''):'' } ;
			tobecached = (withoutnew) ? true : false ;
			
			cl = (!!!cl) ? DOMClass(target).toString().replace(toStringReg, '') : cl.toString().replace(toStringReg, '') ;
			if(toClass === true) {
				tobecached = true ;
				cl = cl + 'Proxy' ;
			} ;
			
			
			
			if(cl.indexOf('function ') == 0) cl = cl.match(name_r)[1].replace(/^ /, '') ;
			
			// if in cache
			if(ns[cl] !== undefined && tobecached === true) {
				ret = ns[cl] ;
				return (toClass) ? ret : new ret(target) ;
			}
			
			var tg = target.constructor === Function ? target : target.constructor ;
			
			var name ;
			if(!!!tg) name = cl ;
			else name = tg == Object ? '' : (tg.name || getctorname(tg.toString())) ;
			
			
			var tar, over ;	
			if(tar === undefined) { tar = target ; over = override}
			else if (tar !== target) {over = tar ; tar = target}
			else if(!!!over){over = override}
			
			if(!!!over) {
				over = {constructor:Function('return (function '+cl+'Proxy(){}) ;')()} ;
			}
			over.original = {} ;
			over.protoinit = function(){
				for(var s in tar) {
					if(s == 'constructor') continue ;	
					if(s == 'toString') continue ;	
					if(s == '__proxy__') continue ;	
					
					if(s in this){this.original[s] = getPropertyClosure(tar[s], s, tar) ;}
					else
						this[s] = getPropertyClosure(tar[s], s, tar) ;
				}
			} ;
			
			var out = tar['__proxy__'] = Type.define(over) ;
			out.base = tar.constructor ;
			out.factory = tar ;
			
			
			var store = function(r, ns, cl){
				if(tobecached === true) ns[cl] = r ;
				return r ;
			} ;
			
			ret = store(out, ns, cl) ;
			return (toClass) ? ret : new ret(target) ;
		}
	} ;
	
}) ;



Pkg.write('org.libspark.straw', function(){
	
	var IEvent = Type.define({
		pkg:'event::IEvent',
		domain:Type.appdomain,
		constructor:IEvent = function IEvent(type, data){
			var signature = arguments.length ;
			
			if('string' == typeof type){
				this.type = type ;
			}else if(!!type.type){
				for(var s in type)
					this[s] = type[s] ;
			}else if(!!data){
				for(var s in data)
					this[s] = data[s] ;
			}
			
			this.timeStamp = Date.now() ;
		}
	}) ;
	
	var EventDispatcher = Type.define({
		pkg:'event::EventDispatcher',
		domain:Type.appdomain,
		constructor:EventDispatcher = function EventDispatcher(tg){
			this.flag = 0 ;
			this._handlers = [] ;
			this._proxies = [] ;
			this._dispatcher = this ;
			if(!!tg) this.setDispatcher(tg) ;
		},
		_handlers:undefined,
		_addHandler:function(ind, type, closure){
			var h = this._handlers ;
			h[h.length] = {ind:ind, type:type, closure:closure} ;
			return true ;
		},
		_removeHandler:function(ind, type, closure){
			var h = this._handlers ;
			var i = (function(){
				for(var i = 0 ; i < h.length ; i++)
					if(h[i].closure === closure && h[i].ind == ind)
						return i ;
				return -1 ;
			})() ;
			if(i == -1)
				throw new Error('EventDispatcher target not registered with type : "'+ type +'" and closure : ' + closure + '.' )
			
			h.splice(i, 1) ;
			return true ;
		},
		registerFlag:function(cond, ind, closure, type){
			if(!! closure ){
				(cond) ? this._addHandler(ind, type, closure) : this._removeHandler(ind, type, closure) ;
			}
			(cond) ? this.flag |= ind : this.flag &= ~ind ;
		},
		setDispatcher:function(tg){
			if(!!tg && (!!tg.addEventListener || !!tg.attachEvent)) tg = new DOMEventDispatcherProxy(tg, this.willTrigger) ;
			// if tg comes undefined, means we want to erase behaviour,
			// but if comes with original 'this', we also want to erase proxy behaviour
			Global.setProxyListener(this, tg === this ? undefined : tg) ; 
		},
		bind:function(type, closure){
			return Global.addEL(this, type, closure) ;
		},
		unbind:function(type, closure){
			return Global.removeEL(this, type, closure) ;
		},
		trigger:function(e){
			return Global.dispatchEL(this, e) ;
		},
		willTrigger:function(e){
			e = Global.format(e) ;
			return (e & this.flag) != 0 ;
		}
	}) ;
	
	var Global = Type.define({
		pkg:'event::Global',
		domain:Type.appdomain,
		statics:{
			events:{},
			all:[],
			IEvent:IEvent,
			evtypeindex:0,
			setProxyListener:function(proxy, tg){
				var proxies ;
				
				if(proxy._dispatcher !== proxy || tg === proxy ){ // remove ici 
				
					if(proxy._dispatcher._proxies.length){
						proxies = proxy._dispatcher._proxies ;
						var i = ArrayUtil.indexOf(proxies, proxy) ;
						if(i !== -1) proxies.splice(i, 1) ;
					}
					if(proxy._dispatcher instanceof DOMEventDispatcherProxy){
					
						var handlers = proxy._handlers ;
						var l = handlers.length ;
						
						for(;l--;){
							var h = handlers[l] ;
							if(proxy.willTrigger(h.ind)){
								proxy._dispatcher.unbind(h.type, h.closure) ;
							}
						}
					}
					proxy._dispatcher = proxy ;
				}
				
				if(!!!tg) return proxy._dispatcher = proxy ;
				proxy._dispatcher = tg ;
				proxies = tg._proxies ;
				
				var i = ArrayUtil.indexOf(proxies, proxy) ;
				if(i == -1) {
					proxies.unshift(proxy) ;
					
					if(proxy._dispatcher instanceof DOMEventDispatcherProxy){
					
						var handlers = proxy._handlers ;
						var l = handlers.length ;
						
						for(;l--;){
							var h = handlers[l] ;
							if(proxy.willTrigger(h.ind)){
								proxy._dispatcher.bind(h.type, h.closure) ;
							}
						}
					}
					
				}
				
			},
			addEventType:function(type){
				var ind = Global.evtypeindex == 0 ? (Global.evtypeindex+=1) : (Global.evtypeindex <<= 1) ;
				Global.events[type] = ind ;
				
				Global.allListeners(function(proxy){
					if(!proxy.willTrigger(ind)) proxy.registerFlag(false, ind, undefined, type) ;
				})
				
				return ind ;
			},
			allListeners:function(closure){
				for(var i = 0 ; i < Global.all.length ; i++){
					var tg = Global.all[i] ;
					return closure(tg, i) ;
				}
			},
			addEL:function(tg, type, closure){
				var ind ;
				if(type in Global.events) ind = Global.events[type] ;
				else {
					ind = Global.addEventType(type) ;
				}
				tg.registerFlag(true, ind, closure, type) ;
				
				if(!!! tg.registered){
					Global.all[Global.all.length] = tg ;
					tg.registered ;
				}
				
				Global.checkDomProxy(true, tg, type, closure) ;
				
				return tg ;
			},
			removeEL:function(tg, type, closure){
				var ind ;
				if(type in Global.events) ind = Global.events[type] ;
				else {
					throw new Error('cannot remove event : ' + + 'is not registered') ;
				}
				
				Global.checkDomProxy(false, tg, type, closure) ;
				
				tg.registerFlag(false, ind, closure, type) ;
			},
			checkDomProxy:function(cond, tg, type, closure){
				if(tg._dispatcher instanceof DOMEventDispatcherProxy){
					var handlers = tg._handlers ;
					var l = handlers.length ;
					
					for(;l--;){
						var h = handlers[l] ;
						if(cond){
							
							if(h.type === type && h.closure === closure){
								tg._dispatcher.bind(type, closure) ;
							}
							
						}else{
							if(h.type === type){
								tg._dispatcher.unbind(h.type, h.closure) ;
							}
							
						}
						
					}
				}
			},
			dispatchEL:function(tg, e){
				
				if(e in Global.events){
					for(var ind in Global.events){
						var evind = Global.events[ind] ;
						
						if(tg.willTrigger(evind)){
							if(ind == e){
								Global.checkForCompatAndTrigger(tg, e) ;
							}
						}
						if(tg._proxies.length){
							
							if(ind == e){
								var proxies = tg._proxies ;
								var l = proxies.length ;
								for( ; l-- ; ){
									var p = proxies[l] ;
									Global.checkForCompatAndTrigger(p, e, tg) ;
								}
							}
							
						}
					}
				}
			},
			format:function(e){
				if('string' === typeof e) return Global.events[e] ;
				if(e instanceof Global.IEvent) return Global.events[e.type] ;
				return e ;
			},
			checkForCompatAndTrigger:function(tg, e){
				var handlers = tg._handlers ;
				var l = handlers.length ;
				
				var ind = Global.format(e) ;
				
				for(var i = 0 ; i < l ; i++){
					var h = handlers[i] ;
					if(tg.willTrigger(e) && h.type == e)
						(h.closure.apply(tg, [new Global.IEvent({target:tg, type:e})])) ;
				}
			}
		}
	}) ;
	
	var DOMEventDispatcherProxy = Type.define({
		pkg:'event::DOMEventDispatcherProxy',
		domain:Type.appdomain,
		_proxies:[],
		constructor:DOMEventDispatcherProxy = function DOMEventDispatcherProxy(tg, willTrigger){
			this._targetProxy = (tg) ;
			this.willTrigger = willTrigger ;
			return this ;
		},
		trigger:function(e){
			var s = this ;
			return ( this._targetProxy.fireEvent ) ?
				(function(){
					s._targetProxy.fireEvent('on' + e) ;	
				
				})() :
				(function(){
					if('string' === typeof e){
						var ev = document.createEvent('MouseEvents') ;
						ev.initEvent(e, true, false) ;
						e = ev ;
					}
					s._targetProxy.dispatchEvent(e) ;
				})()
		},
		bind:function bind(type, closure){
			return (!!this._targetProxy.attachEvent) ? 
				this._targetProxy.attachEvent('on'+type, closure) :
				this._targetProxy.addEventListener(type, closure, true) ;
		},
		unbind:function unbind(type, closure){
			return (!!this._targetProxy.detachEvent) ? 
				this._targetProxy.detachEvent('on'+type, closure) :
				this._targetProxy.removeEventListener(type, closure, true) ;
		}
	}) ;

})
