	
	
	var ArrayUtil = Type.define({
		pkg:'utils::ArrayUtil',
		domain:Type.appdomain,
		statics:{
			isArray:function(obj){
				return Type.is(obj, Array) ;
			},
			slice:[].slice,
			argsToArray:function(args){
				return args.length ? ArrayUtil.slice.call(args) : [] ;
			},
			indexOf:function(arr, obj){
				if(arr.hasOwnProperty('indexOf'))
				return arr.indexOf.apply(arr, [obj]) ; // FF / CHR / OP implementation
				var n = -1 ;
				var l = arr.length ;
				for(var i = 0 ; i < l ; i++ ){
					if(arr[i] == obj) {
						n = i ;
						break ;
					}
				}
				return n ;
			}
		}
	}) ;
	
	
	
	/* EVENT */
	var IEvent = Type.define({
		pkg:'event::IEvent',
		domain:Type.appdomain,
		constructor:IEvent = function IEvent(type, data){
			this.timeStamp = + (new Date()) ;
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
		}
	}) ;
	
	
	/*
	
	var DOMEventDispatcher = Type.define({
		pkg:'event::DOMEventDispatcher',
		domain:Type.appdomain,
		constructor:DOMEventDispatcher = function DOMEventDispatcher(){
			//
		},
		trigger:function(e){
			var s = this ;
			return ( this._globalTarget.fireEvent ) ?
				(function(){
					s._globalTarget.fireEvent('on' + e) ;	
				
				})() :
				(function(){
					if('string' === typeof e){
						var ev = document.createEvent('MouseEvents') ;
						ev.initEvent(e, true, false) ;
						e = ev ;
					}
					s._globalTarget.dispatchEvent(e) ;
				})()
		},
		bind:function bind(type, closure){
			
			return (!!this._globalTarget.attachEvent) ? 
				this._globalTarget.attachEvent('on'+type, closure) :
				this._globalTarget.addEventListener(type, closure, true) ;
		},
		unbind:function unbind(type, closure){
			
			return (!!this._globalTarget.detachEvent) ? 
				this._globalTarget.detachEvent('on'+type, closure) :
				this._globalTarget.removeEventListener(type, closure, true) ;
		},
		destroy:function(){
			var proxies = this._proxies ;
			var l = proxies.length ;
			for(;l--;){
				var p = proxies[l] ;
				if(Type.of(p['destroy'], 'function')) p = p.destroy() ;
				delete proxies[l] ;
			}
			
			delete this._proxies ;
			delete this._globalTarget ;
			
			return undefined ;
		}
	}) ;
	
	var EventDispatcher = Type.define({
		pkg:'event::EventDispatcher',
		domain:Type.appdomain,
		inherits:DOMEventDispatcher,
		constructor:EventDispatcher = function EventDispatcher(tg){
			
			EventDispatcher.base.apply(this, [tg]) ;
			
			this._flag = 0 ;
			this._handlers = [] ;
			this._proxies = [] ;
			this._dispatchers = [] ;
			
			if(!!tg) {
				this.setDispatcher(tg) ;
			}
		},
		setDispatcher:function(tg){
			return Global.setDispatcher(this, tg) ;
		},
		bind:function(type, closure){
			return Global.bind(this, type, Global.checkEventType(true, type), closure) ;
		},
		unbind:function(type, closure){
			return Global.unbind(this, type, Global.checkEventType(false, type), closure) ;
		},
		trigger:function(e){
			return Global.checkBeforeTrigger(this, e) ;
		},
		willTriggerNow:function(e){
			return Global.willTriggerNow(this, e) ; 
		},
		willTrigger:function(e){
			return Global.willTrigger(this, e) ; 
		},
		destroy:function(){
			if(this._dispatchers.length > 1) this.setDispatcher() ;
			
			delete this._flag ;
			delete this._handlers ;
			delete this._proxies ;
			delete this._dispatchers ;
			
			return undefined ;
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
			loop:function(arr, closure, reversed){
				
				var l = arr.length ;
				
				if(!!reversed){
					
					for(; l-- ; ){
						var p = arr[l] ;
						try{
							closure.apply(p, [p, l, arr]) ;
						}catch(e){
							trace(e) ;
						}
					}
					
				}else{
				
					for(var i = 0 ; i < l ; i++){
						var p = arr[i] ;
						try{
							closure.apply(p, [p, i, arr]) ;
						}catch(e){
							trace(e) ;
						}
					}
				
				}
			},
			_addHandler:function(tg, ind, type, closure){
				return Global._registerHandler(tg, true, ind, type, closure) ;
			},
			_removeHandler:function(tg, ind, type, closure){
				return Global._registerHandler(tg, false, ind, type, closure) ;
			},
			_registerHandler:function(tg, cond, ind, type, closure){
				
				var handlers = tg._handlers ;
				if(cond){
					
					handlers[handlers.length] = {ind:ind, type:type, closure:closure, target:tg} ;
					
					return true ;
					
				}else{
					
					var typeind = 0 , handler;
					var i = (function(){
						var n = -1 ;
						var l = handlers.length ;
						for(; l-- ; ){
							var h = handlers[l] ;
							if(!!!h) continue ;
							if(h.ind == ind) typeind++ ;
							if(h.closure === closure && h.ind == ind) handler = h, n = l ;
						}
						return n ;
					})() ;
					
					if(i == -1)
						throw new Error('EventDispatcher target not registered with type : "'+ type +'" and closure : ' + closure + '.' )
					
					delete handler.closure ;
					delete handler.type ;
					delete handler.ind ;
					delete handlers[i] ;
					
					handlers.splice(i, 1) ;
					
					return typeind < 2 ;
					
				}
			},
			_registerDispatcher:function(tg, cond, dispatcher){
				
				var dispatchers = tg._dispatchers ;
				var i = ArrayUtil.indexOf(dispatchers, dispatcher) ;
				
				if(cond){
					
					if(i == -1 && dispatcher !== tg) {
						// Dispatcher added
						dispatchers[dispatchers.length] = dispatcher ;
						
						// Proxy should register target in dispatcher's proxies list
						Global._addProxy(dispatcher, tg) ;
					}
					
					return true ;
					
				}else{
				
					if(!!dispatcher){
						
						if(i !== -1){
							// dispatcher removed
							dispatchers.splice(i, 1) ;
							
							// Proxy should also be removed from dispatcher's proxies list
							Global._removeProxy(dispatcher, tg) ;
							
							return true ;
						}
						
					}else{
						Global.loop(tg._dispatchers, function(el, i, arr){
							Global._removeDispatcher(tg, el) ;
						}, true) ;
						
						return true ;
					}
					return false ;
				}
			},
			_addDispatcher:function(tg, dispatcher){
				return Global._registerDispatcher(tg, true, dispatcher)
			},
			_removeDispatcher:function(tg, dispatcher){
				return Global._registerDispatcher(tg, false, dispatcher)
			},
			_registerProxy:function(tg, cond, proxy, force){
				
				var proxies = tg._proxies ;
				
				var i = ArrayUtil.indexOf(proxies, proxy) ;
				// not sure of that, we'll see
				if(tg === proxy && !!!force) return ;
				
				if(cond){
					if(i == -1) {
						proxies[proxies.length] = proxy ;
					}
				}else{
					if(i != -1) {
						proxies.splice(i, 1) ;
					}
				}
				
			},
			_addProxy:function(tg, proxy, force){
				return Global._registerProxy(tg, true, proxy, force) ;
			},
			_removeProxy:function(tg, proxy, force){
				return Global._registerProxy(tg, false, proxy, force) ;
			},
			generateDomProxyAlongTarget:function(p){
				
				var model ;
				
				Global.loop(Global.all, function(el, i, arr){
					if(el._targetProxy === p) {
						return (model = el) ;
					}
				}) ;
				
				if(!!! model){
					
					model = Global.all[Global.all.length] = new EventDispatcher() ;
					model.isGlobal = true ;
					model._globalTarget = p ;
					model.setDispatcher(p) ;
					
				}
				
				
				var s = new EventDispatcher() ;
				s.isProxied = true ;
				s.setDispatcher(model) ;
				
				return s ;
			},
			teardown:function(tg, model){
				Global.loop(tg._handlers, function(h){
					DOMEventDispatcher.prototype.unbind.apply(model, [h.type, h.closure]) ;
				})
				Global.loop(tg._proxies, function(p){
					Global.teardown(p, model) ;
				})
			},
			setup:function(tg, model){
				Global.loop(tg._handlers, function(h){
					DOMEventDispatcher.prototype.bind.apply(model, [h.type, h.closure]) ;
				})
				Global.loop(tg._proxies, function(p){
					Global.setup(p, model) ;
				})
			},
			setDispatcher:function(tg, proxy){
				// if proxy comes undefined, means we want to erase behaviour,
				// but if comes with original 'this', we also want to erase proxy behaviour
				var hadEvents ;
				if(proxy === undefined || proxy === tg || tg._dispatchers.length) {
					// unset(last)
					var top = Global.getTopDispatcher(tg) ;
					
					if(top.isProxied) {
						
						Global.teardown(tg, top._dispatchers[0]) ;
						
						if(top === tg) tg.isProxied = false ;
						
					}
					
					Global._removeDispatcher(tg) ;
				}
				
				if(!! proxy && proxy !== tg){ 
					// else just add 
					
					if( tg.isGlobal ) return ;
					
					
					// hack-setting if object is a Global model, doesn't have to go thru this
					if(  tg.isProxied ) return Global._addDispatcher(tg, proxy) ;
					
					if(!Type.is(proxy, EventDispatcher))
						proxy = Global.generateDomProxyAlongTarget(proxy) ;
					
					var top = Global.getTopDispatcher(proxy) ;
					if(top.isProxied){
						
						Global.setup(tg, top._dispatchers[0]) ;
						
					}
					
					Global._addDispatcher(tg, top) ;
				
				}
			},
			addEventType:function(type){
				var ind = Global.evtypeindex == 0 ? (Global.evtypeindex+=1) : (Global.evtypeindex <<= 1) ;
				Global.events[type] = ind ;
				
				return ind ;
			},
			checkEventType:function(cond, type){
				var ind
				if(type in Global.events) ind = Global.events[type] ;
				else {
					if(cond) ind = Global.addEventType(type) ;
					else throw new Error('cannot remove event : ' + + 'is not registered') ;
				}
				return ind ;
			},
			bind:function(tg, type, ind, closure){
				
				var top = Global.getTopDispatcher(tg) ;
			
				if(top.isProxied)
					if(top._dispatchers.length && tg._dispatchers[0] instanceof DOMEventDispatcher){
						var model = top._dispatchers[0] ;
						DOMEventDispatcher.prototype.bind.apply(model, [type, closure])
					}
				
				Global.registerFlag(tg, true, ind, closure, type) ;
				
				return tg ;
			},
			unbind:function(tg, type, ind, closure){
				
				var top = Global.getTopDispatcher(tg) ;
				
				if(top.isProxied)
					if(top._dispatchers.length && tg._dispatchers[0] instanceof DOMEventDispatcher){
						var model = top._dispatchers[0] ;
						DOMEventDispatcher.prototype.unbind.apply(model, [type, closure])
					}
				
				Global.registerFlag(tg, false, ind, closure, type) ;
				
				return tg ;
			},
			registerFlag:function(tg, cond, ind, closure, type){
				
				var allowed = true ;
				if(!! closure ){
					allowed = (cond) ? Global._addHandler(tg, ind, type, closure) : Global._removeHandler(tg, ind, type, closure) ;
				}
				if(cond) {
					tg._flag |= ind ;
				}else{
					if(allowed){
						tg._flag &= ~ind ;
					}
				}
			},
			willTriggerNow:function(tg, e, resultAsArr){
				e = Global.format(e) ;
				var cond = (e & tg._flag) != 0 ;
				// if(tg instanceof DOMEventDispatcherProxy) cond = true ;
				// return resultAsArr ? {arr:cond ? tg._handlers : [], cond:cond} : cond ;
				return cond ;
			},
			hasTriggeringProxies:function(tg, e){
				var cond = false ;
				
				Global.loop(tg._proxies, function(p, i, arr){
					cond = cond || Global.hasTriggeringProxies(p, e) ;
				})
				
				cond = cond || Global.willTriggerNow(tg, e) ;
				
				return cond ;
			},
			getTopDispatcher:function(tg){
			
				if(tg.isProxied){
					
					return tg ;
					
				}else if(!!tg._dispatchers && tg._dispatchers.length){
				
					// !!! has to be safe with no DOM EventDispatcher case
					tg = Global.getTopDispatcher(tg._dispatchers[0]) ;
					
				}
				
				return tg ;
			},
			willTrigger:function(tg, e, withDispatcher, top){
				
				
				e = Global.format(e) ;
				var cond = false ;
				
				var top = top || Global.getTopDispatcher(tg) ;
				
				if(top.isProxied) return withDispatcher ? {dispatcher:top, cond:true} : true ;
				
				if(top === tg) {
					
					Global.loop(top._proxies, function(p, i, arr){
						
						cond = cond || Global.hasTriggeringProxies(p, e) ;
						
					}) ;
					
				}else{
					cond = cond || Global.willTrigger(top, e, false, top) ;
				}
				
				if(withDispatcher === true) return {dispatcher:top, cond:cond} ;
				
				return cond ;
			},
			fire:function(tg, e){
				
				Global.loop(tg._handlers, function(h, j, handlers){
					if(!!!h) return ;
					if(h.type == e && tg.willTriggerNow(e))
						(h.closure.apply(tg, [new Global.IEvent({target:h.target, type:e, currentTarget:tg})])) ;
				})
				
			},
			checkBeforeTrigger:function(tg, e, force){
				
				var obj = !! force ? force : Global.willTrigger(tg, e, true) ;
				
				var dispatcher = obj.dispatcher ;
				
				if(obj.cond){
					Global.trigger(obj.dispatcher, e) ;
				}
				
			},
			trigger:function(tg, e){
				
				if( tg.isProxied ){
					
					DOMEventDispatcher.prototype.trigger.apply(tg._dispatchers[0], [e]) ;
					
				}else{
					
					Global.triggerDown(tg, e)
					
				}
				
			},
			triggerDown:function(tg, e){
				
				if(Global.willTriggerNow(tg, e)) Global.fire(tg, e) ;
				
				if(tg._proxies.length)
				Global.loop(tg._proxies, function(p, i, arr){
					
					if(Global.willTriggerNow(p, e)) Global.triggerDown(p, e) ;
					
				}) ;
				
			},
			format:function(e){
				if('string' === typeof e) return Global.events[e] ;
				if(e instanceof Global.IEvent) return Global.events[e.type] ;
				return e ;
			}
		}
	}) ;
	
	
	*/
	
	
	var DOMEventDispatcher = Type.define({
		pkg:'event::DOMEventDispatcher',
		domain:Type.appdomain,
		constructor:DOMEventDispatcher = function DOMEventDispatcher(){
			//
		},
		trigger:function(e){
			var s = this ;
			return ( this._globalTarget.fireEvent ) ?
				(function(){
					s._globalTarget.fireEvent('on' + e) ;	
				
				})() :
				(function(){
					if('string' === typeof e){
						var ev = document.createEvent('MouseEvents') ;
						ev.initEvent(e, true, false) ;
						e = ev ;
					}
					s._globalTarget.dispatchEvent(e) ;
				})()
		},
		bind:function bind(type, closure){
			
			return (!!this._globalTarget.attachEvent) ? 
				this._globalTarget.attachEvent('on'+type, closure) :
				this._globalTarget.addEventListener(type, closure, true) ;
		},
		unbind:function unbind(type, closure){
			
			return (!!this._globalTarget.detachEvent) ? 
				this._globalTarget.detachEvent('on'+type, closure) :
				this._globalTarget.removeEventListener(type, closure, true) ;
		},
		destroy:function(){
			var proxies = this._proxies ;
			var l = proxies.length ;
			for(;l--;){
				var p = proxies[l] ;
				if(Type.of(p['destroy'], 'function')) p = p.destroy() ;
				delete proxies[l] ;
			}
			
			delete this._proxies ;
			delete this._globalTarget ;
			
			return undefined ;
		}
	}) ;
	
	var EventDispatcher = Type.define({
		pkg:'event::EventDispatcher',
		domain:Type.appdomain,
		inherits:DOMEventDispatcher,
		constructor:EventDispatcher = function EventDispatcher(tg){
			
			EventDispatcher.base.apply(this, [tg]) ;
			
			this._flag = 0 ;
			this._handlers = [] ;
			this._proxies = [] ;
			this._dispatchers = [] ;
			
			if(!!tg) {
				this.setDispatcher(tg) ;
			}
		},
		setDispatcher:function(tg){
			return Global.setDispatcher(this, tg) ;
		},
		bind:function(type, closure){
			return Global.bind(this, type, Global.checkEventType(true, type), closure) ;
		},
		unbind:function(type, closure){
			return Global.unbind(this, type, Global.checkEventType(false, type), closure) ;
		},
		trigger:function(e){
			return Global.checkBeforeTrigger(this, e) ;
		},
		willTriggerNow:function(e){
			return Global.willTriggerNow(this, e) ; 
		},
		willTrigger:function(e){
			return Global.willTrigger(this, e) ; 
		},
		destroy:function(){
			if(this._dispatchers.length > 1) this.setDispatcher() ;
			
			delete this._flag ;
			delete this._handlers ;
			delete this._proxies ;
			delete this._dispatchers ;
			
			return undefined ;
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
			loop:function(arr, closure, reversed){
				
				var l = arr.length ;
				
				if(!!reversed){
					
					for(; l-- ; ){
						var p = arr[l] ;
						try{
							closure.apply(p, [p, l, arr]) ;
						}catch(e){
							trace(e) ;
						}
					}
					
				}else{
				
					for(var i = 0 ; i < l ; i++){
						var p = arr[i] ;
						try{
							closure.apply(p, [p, i, arr]) ;
						}catch(e){
							trace(e) ;
						}
					}
				
				}
			},
			_addHandler:function(tg, ind, type, closure){
				return Global._registerHandler(tg, true, ind, type, closure) ;
			},
			_removeHandler:function(tg, ind, type, closure){
				return Global._registerHandler(tg, false, ind, type, closure) ;
			},
			_registerHandler:function(tg, cond, ind, type, closure){
				
				var handlers = tg._handlers ;
				if(cond){
					
					handlers[handlers.length] = {ind:ind, type:type, closure:closure, target:tg} ;
					
					return true ;
					
				}else{
					
					var typeind = 0 , handler;
					var i = (function(){
						var n = -1 ;
						var l = handlers.length ;
						for(; l-- ; ){
							var h = handlers[l] ;
							if(!!!h) continue ;
							if(h.ind == ind) typeind++ ;
							if(h.closure === closure && h.ind == ind) handler = h, n = l ;
						}
						return n ;
					})() ;
					
					if(i == -1)
						throw new Error('EventDispatcher target not registered with type : "'+ type +'" and closure : ' + closure + '.' )
					
					delete handler.closure ;
					delete handler.type ;
					delete handler.ind ;
					delete handlers[i] ;
					
					handlers.splice(i, 1) ;
					
					return typeind < 2 ;
					
				}
			},
			_registerDispatcher:function(tg, cond, dispatcher){
				
				var dispatchers = tg._dispatchers ;
				var i = ArrayUtil.indexOf(dispatchers, dispatcher) ;
				
				if(cond){
					
					if(i == -1 && dispatcher !== tg) {
						// Dispatcher added
						dispatchers[dispatchers.length] = dispatcher ;
						
						// Proxy should register target in dispatcher's proxies list
						Global._addProxy(dispatcher, tg) ;
					}
					
					return true ;
					
				}else{
				
					if(!!dispatcher){
						
						if(i !== -1){
							// dispatcher removed
							dispatchers.splice(i, 1) ;
							
							// Proxy should also be removed from dispatcher's proxies list
							Global._removeProxy(dispatcher, tg) ;
							
							return true ;
						}
						
					}else{
						Global.loop(tg._dispatchers, function(el, i, arr){
							Global._removeDispatcher(tg, el) ;
						}, true) ;
						
						return true ;
					}
					return false ;
				}
			},
			_addDispatcher:function(tg, dispatcher){
				return Global._registerDispatcher(tg, true, dispatcher)
			},
			_removeDispatcher:function(tg, dispatcher){
				return Global._registerDispatcher(tg, false, dispatcher)
			},
			_registerProxy:function(tg, cond, proxy, force){
				
				var proxies = tg._proxies ;
				
				var i = ArrayUtil.indexOf(proxies, proxy) ;
				// not sure of that, we'll see
				if(tg === proxy && !!!force) return ;
				
				if(cond){
					if(i == -1) {
						proxies[proxies.length] = proxy ;
					}
				}else{
					if(i != -1) {
						proxies.splice(i, 1) ;
					}
				}
				
			},
			_addProxy:function(tg, proxy, force){
				return Global._registerProxy(tg, true, proxy, force) ;
			},
			_removeProxy:function(tg, proxy, force){
				return Global._registerProxy(tg, false, proxy, force) ;
			},
			generateDomProxyAlongTarget:function(p){
				
				var model ;
				
				Global.loop(Global.all, function(el, i, arr){
					if(el._targetProxy === p) {
						return (model = el) ;
					}
				}) ;
				
				if(!!! model){
					
					model = Global.all[Global.all.length] = new EventDispatcher() ;
					model.isGlobal = true ;
					model._globalTarget = p ;
					model.setDispatcher(p) ;
					
				}
				
				
				var s = new EventDispatcher() ;
				s.isProxied = true ;
				s.setDispatcher(model) ;
				
				return s ;
			},
			teardown:function(tg, model){
				Global.loop(tg._handlers, function(h){
					DOMEventDispatcher.prototype.unbind.apply(model, [h.type, h.closure]) ;
				})
				Global.loop(tg._proxies, function(p){
					Global.teardown(p, model) ;
				})
			},
			setup:function(tg, model){
				Global.loop(tg._handlers, function(h){
					DOMEventDispatcher.prototype.bind.apply(model, [h.type, h.closure]) ;
				})
				Global.loop(tg._proxies, function(p){
					Global.setup(p, model) ;
				})
			},
			setDispatcher:function(tg, proxy){
				// if proxy comes undefined, means we want to erase behaviour,
				// but if comes with original 'this', we also want to erase proxy behaviour
				var hadEvents ;
				if(proxy === undefined || proxy === tg || tg._dispatchers.length) {
					// unset(last)
					var top = Global.getTopDispatcher(tg) ;
					
					if(top.isProxied) {
						
						Global.teardown(tg, top._dispatchers[0]) ;
						
						if(top === tg) tg.isProxied = false ;
						
					}
					
					Global._removeDispatcher(tg) ;
				}
				
				if(!! proxy && proxy !== tg){ 
					// else just add 
					
					if( tg.isGlobal ) return ;
					
					
					// hack-setting if object is a Global model, doesn't have to go thru this
					if(  tg.isProxied ) return Global._addDispatcher(tg, proxy) ;
					
					if(!Type.is(proxy, EventDispatcher))
						proxy = Global.generateDomProxyAlongTarget(proxy) ;
					
					var top = Global.getTopDispatcher(proxy) ;
					if(top.isProxied){
						
						Global.setup(tg, top._dispatchers[0]) ;
						
					}
					
					Global._addDispatcher(tg, top) ;
				
				}
			},
			addEventType:function(type){
				var ind = Global.evtypeindex == 0 ? (Global.evtypeindex+=1) : (Global.evtypeindex <<= 1) ;
				Global.events[type] = ind ;
				
				return ind ;
			},
			checkEventType:function(cond, type){
				var ind
				if(type in Global.events) ind = Global.events[type] ;
				else {
					if(cond) ind = Global.addEventType(type) ;
					else throw new Error('cannot remove event : ' + + 'is not registered') ;
				}
				return ind ;
			},
			bind:function(tg, type, ind, closure){
				
				var top = Global.getTopDispatcher(tg) ;
			
				if(top.isProxied)
					if(top._dispatchers.length && tg._dispatchers[0] instanceof DOMEventDispatcher){
						var model = top._dispatchers[0] ;
						DOMEventDispatcher.prototype.bind.apply(model, [type, closure])
					}
				
				Global.registerFlag(tg, true, ind, closure, type) ;
				
				return tg ;
			},
			unbind:function(tg, type, ind, closure){
				
				var top = Global.getTopDispatcher(tg) ;
				
				if(top.isProxied)
					if(top._dispatchers.length && tg._dispatchers[0] instanceof DOMEventDispatcher){
						var model = top._dispatchers[0] ;
						DOMEventDispatcher.prototype.unbind.apply(model, [type, closure])
					}
				
				Global.registerFlag(tg, false, ind, closure, type) ;
				
				return tg ;
			},
			registerFlag:function(tg, cond, ind, closure, type){
				
				var allowed = true ;
				if(!! closure ){
					allowed = (cond) ? Global._addHandler(tg, ind, type, closure) : Global._removeHandler(tg, ind, type, closure) ;
				}
				if(cond) {
					tg._flag |= ind ;
				}else{
					if(allowed){
						tg._flag &= ~ind ;
					}
				}
			},
			willTriggerNow:function(tg, e, resultAsArr){
				e = Global.format(e) ;
				var cond = (e & tg._flag) != 0 ;
				// if(tg instanceof DOMEventDispatcherProxy) cond = true ;
				// return resultAsArr ? {arr:cond ? tg._handlers : [], cond:cond} : cond ;
				return cond ;
			},
			hasTriggeringProxies:function(tg, e){
				var cond = false ;
				
				Global.loop(tg._proxies, function(p, i, arr){
					cond = cond || Global.hasTriggeringProxies(p, e) ;
				})
				
				cond = cond || Global.willTriggerNow(tg, e) ;
				
				return cond ;
			},
			getTopDispatcher:function(tg){
			
				if(tg.isProxied){
					
					return tg ;
					
				}else if(!!tg._dispatchers && tg._dispatchers.length){
				
					// !!! has to be safe with no DOM EventDispatcher case
					tg = Global.getTopDispatcher(tg._dispatchers[0]) ;
					
				}
				
				return tg ;
			},
			willTrigger:function(tg, e, withDispatcher, top){
				
				
				e = Global.format(e) ;
				var cond = false ;
				
				var top = top || Global.getTopDispatcher(tg) ;
				
				if(top.isProxied) return withDispatcher ? {dispatcher:top, cond:true} : true ;
				
				if(top === tg) {
					
					Global.loop(top._proxies, function(p, i, arr){
						
						cond = cond || Global.hasTriggeringProxies(p, e) ;
						
					}) ;
					
				}else{
					cond = cond || Global.willTrigger(top, e, false, top) ;
				}
				
				if(withDispatcher === true) return {dispatcher:top, cond:cond} ;
				
				return cond ;
			},
			fire:function(tg, e){
				
				Global.loop(tg._handlers, function(h, j, handlers){
					if(!!!h) return ;
					if(h.type == e && tg.willTriggerNow(e))
						(h.closure.apply(tg, [new Global.IEvent({target:h.target, type:e, currentTarget:tg})])) ;
				})
				
			},
			checkBeforeTrigger:function(tg, e, force){
				
				var obj = !! force ? force : Global.willTrigger(tg, e, true) ;
				
				var dispatcher = obj.dispatcher ;
				
				if(obj.cond){
					Global.trigger(obj.dispatcher, e) ;
				}
				
			},
			trigger:function(tg, e){
				
				if( tg.isProxied ){
					
					DOMEventDispatcher.prototype.trigger.apply(tg._dispatchers[0], [e]) ;
					
				}else{
					
					Global.triggerDown(tg, e)
					
				}
				
			},
			triggerDown:function(tg, e){
				
				if(Global.willTriggerNow(tg, e)) Global.fire(tg, e) ;
				
				if(tg._proxies.length)
				Global.loop(tg._proxies, function(p, i, arr){
					
					if(Global.willTriggerNow(p, e)) Global.triggerDown(p, e) ;
					
				}) ;
				
			},
			format:function(e){
				if('string' === typeof e) return Global.events[e] ;
				if(e instanceof Global.IEvent) return Global.events[e.type] ;
				return e ;
			}
		}
	}) ;
	