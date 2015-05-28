/**
 * @author saz
 */


/* TRACE*/
cl = trace =  function(){
	// alert(window.console)
	// presence of console namespace
	if(window.console && console){
		if(this.opera){ // OP
			opera.postError.apply(opera, [].slice.call(arguments)) ;
		}else if(console.firebug !== 'undefined'){ // FF & IEw/console
			arguments.length > 1 ? console.log([].slice.call(arguments)) :  (console.log.apply===undefined) ? console.log([].slice.call(arguments)) : console.log.apply(console, arguments) ;
		}else if(console.profiles) { // CHR
			console.log.apply(console, [].slice.call(arguments)) ;
		}
	}else{
		// uncomment if you really wish alerts 
		// alert([].slice.call(arguments)) ;
	}
} ;
/* KOMPAT */
var Kompat = NS('Kompat', NS('spill.detect::Kompat', Class.$extend({
	__classvars__ : {
		version:0.1,
		kompat:null,
		namespaces:{
			ie: /MSIE [\d.]+/i,
			chr : /Chrome.[\d.]+/i,
			ff : /Firefox.[\d.]+/i,
			// safmob : /[\d.]+ Mobile Safari/i,
			saf : /[\d.]+ Safari/i,
			op : /Opera/i
		},
		workspaces:{
			win: /WINDOWS(?= NT ([\d.]+))/i,
			mac : /Mac OS/,
			ios : /iP[ao]d|iPhone/i,
			chr : /CrOS/,
			android : /Android/,
			linux : /Linux/
		},
		test:function(){
			return NS('Kompat').kompat = NS('Kompat').kompat || function(){
				var kompat = NS('Kompat').kompat = NS('Kompat').kompat || NS('Kompat')() ;
				var ua = navigator.userAgent ;
				var arr, p, version, name, os, osversion, ns, x, y;
				var namespaces = NS('Kompat').namespaces ;
				for(var s in namespaces){
					x = namespaces[s] ;
					if(arr = x.exec(ua)){
						p = arr[0].replace('/', ' ') ;
						version = p.replace(/[ A-Z]*/gi, '') ;
						if(version === ''){
						var vtest = /Version\/([\d.]+$)/ ;
							if(vtest.test(ua)){
								ua.replace(vtest, function($1, $2, $3){
									version = $2 ;
								});
							}else version = "unknown" ;
						}
						name = p.replace(version, '').replace(' ', '') ;
						ns = s ;
						break ;
					}
				}
				kompat.ns = ns ;
				kompat.name = name ;
				kompat.version = version ;
				var workspaces = NS('Kompat').workspaces ;
				for(var w in workspaces){
					y = workspaces[w] ;
					if(y.test(ua)){
						ua.replace(y, function($1, $2, $3){
							if($2) osversion = $2 ;
							os = $1 ;
						});
						break;
					}
				}
				if(!os) os = "unknown" ;
				if(!osversion) osversion = "unknown" ;
				kompat.os = os ;
				kompat.osversion = osversion ;
				NS('Kompat')[os] = NS('Kompat')[w] = true ;
				NS('Kompat')[ns] = NS('Kompat')[name] = true ;
				
				document.body.className = document.body.className === '' ? name : ' '+ name ;
				return kompat ;
			}()
		}, 
		getName: function(){return NS('Kompat').kompat.name},
		getVersion: function(){return NS('Kompat').kompat.version},
		getOs: function(){return NS('Kompat').kompat.os},
		getOsVersion: function(){
			return NS('Kompat').kompat.osversion
		},
		toString:function(){
			return "[class "+this.ns +"]" ;
		}
	},
	__init__:function(){
		this.ns = '' ;
		this.name = '' ;
		this.version = '' ;
		return this ;
	},
	toString : function(){
		return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
	}
}))) ;
/* XLOADER */ 
var XLoader = NS('XLoader', NS('spill.loading::XLoader', Class.$extend(function(){
	var d = document ;
	var brows, head,
	pending = {},
	pCnt = 0,
	q = {css: [], js: []},
	sheets = d.styleSheets;
	return {
		__classvars__ : {
			version:0.1,
			fileSupport:{
				'javascript':/[.]js$/i,
				'css':/[.]css$/i
			},
			detectFileExt:function(ns){
				var o = NS('XLoader').fileSupport ;
				for(var s in o){
					if(o[s].test(ns)) return s ;
				}
				throw new Error('extension is not supported folr loading...') ;
			},
			loadjscssfile:function(ns, callback){
				var file =  NS('XLoader').createjscssfile(ns) ;
				
				
				switch(file.getAttribute('ext')){
					case 'css':
						document.getElementsByTagName("head")[0].appendChild(file) ;
						if(NS('Kompat').MSIE){
							file.attachEvent("onreadystatechange", function(e){
								file.detachEvent(e.type, arguments.callee) ;
								var el = e ;
								e.target = e.srcElement;
								callback(e);
							}) ;
						}else if(NS('Kompat').Chrome || NS('Kompat').Safari){
							
						}else if (NS('Kompat').Firefox){
							
						}
					break;
					case 'javascript':
						
						document.body.appendChild(file) ;
						if(NS('Kompat').MSIE){
							file.attachEvent("onreadystatechange", function(e){
								file.detachEvent(e.type, arguments.callee) ;
								var el = e ;
								e.target = e.srcElement;
								callback(e);
							}) ;
						}else{
							file.onload = callback ;
						}
					break;
				}
				return file ;
			},
			createjscssfile:function(ns){
				var ext = NS('XLoader').detectFileExt(ns) ;
				var file ;
				if (ext == 'javascript'){
					file = document.createElement('script') ;
					file.setAttribute("type","text/javascript") ;
					file.setAttribute("src", ns) ;
				}
				else if (ext == "css"){
					file = document.createElement("link") ;
					file.setAttribute("rel", "stylesheet") ;
					file.setAttribute("type", "text/css") ;
					file.setAttribute("href", ns) ;
				}
				file.setAttribute('ext', ext) ;
				return file ;
			},
			createNode:function(name, ats) {
				var n = d.createElement(name), a;
				for (a in ats) {
				  if (ats.hasOwnProperty(a)) {
					n.setAttribute(a, ats[a]);
				  }
				}
				return n;
			},
			finish:function(t) {
				var p = pending[t], cb, urls ;
				if (p) {
					cb = p.callback;
					urls = p.urls;
					
					urls.shift();
					pCnt = 0;
					
					if (!urls.length) {
						cb && cb.call(p.context, p.obj);
						pending[t] = null;
						q[t].length && this.load(t);
					}
				}
			},
			getBrows:function () {
				if (brows) { return; }

				var ua = navigator.userAgent;

				brows = {
					async: d.createElement('script').async === true
				};

				(brows.webkit = /AppleWebKit\//.test(ua))
				|| (brows.ie = /MSIE/.test(ua))
				|| (brows.opera = /Opera/.test(ua))
				|| (brows.gecko = /Gecko\//.test(ua))
				|| (brows.unknown = true);
			},
			load:function(t, urls, cb, obj, context) {
				var _finish = function () { 
					NS('XLoader').finish(t); 
				},
				isCSS = t === 'css' ,i, l, n, p, pendingUrls, u;
				
				NS('XLoader').getBrows();
				if (urls) {
					urls = typeof urls === 'string' ? [urls] : urls.concat();
					if (isCSS || brows.async || brows.gecko || brows.opera) {
						q[t].push({
							urls    : urls,
							callback: cb,
							obj     : obj,
							context : context
						});
					} else {
						for (i = 0, l = urls.length; i < l; ++i) {
							q[t].push({
								urls    : [urls[i]],
								callback: i === l - 1 ? cb : null,
								obj     : obj,
								context : context
							});
						}
					}
				}

				if (pending[t] || !(p = pending[t] = q[t].shift())) return;

				head || (head = d.head || d.getElementsByTagName('head')[0]);
				pendingUrls = p.urls;

				for (i = 0, l = pendingUrls.length ; i < l ; ++i) {
					u = pendingUrls[i];

					if (isCSS) {
						n = brows.gecko ? NS('XLoader').createNode('style') : NS('XLoader').createNode('link', {
							href: u,
							rel : 'stylesheet'
						});
					} else {
						n = NS('XLoader').createNode('script', {src: u});
						n.async = false;
					}

					n.className = 'xload';
					n.setAttribute('charset', 'utf-8');
					n.setAttribute('source', u) ;
					if (brows.ie && !isCSS) {
						n.onreadystatechange = function () {
							if (/loaded|complete/.test(n.readyState)) {
								n.onreadystatechange = null;
								_finish();
							}
						};
					} else if (isCSS && (brows.gecko || brows.webkit)) {
						if (brows.webkit) {
							p.urls[i] = n.href;
							NS('XLoader').pWebKit();
						} else {
							n.innerHTML = '@import "' + u + '";';
							NS('XLoader').pGecko(n);
						}
					} else {
						n.onload = n.onerror = _finish;
					}
					isCSS ? head.appendChild(n) : d.body.appendChild(n) ;
				}
			},
			pGecko: function (n) {
				try {
					n.sheet.cssRules;
				} catch (ex) {
					pCnt += 1;

					if (pCnt < 200) {
						setTimeout(function () { NS('XLoader').pGecko(n); }, 50);
					} else {
						NS('XLoader').finish('css');
					}

					return;
				}
				NS('XLoader').finish('css');
			},
			pWebKit: function() {
				var css = pending.css, i;

				if (css) {
					i = sheets.length;
					while (i && --i) {
						if (sheets[i].href === css.urls[0]) {
							NS('XLoader').finish('css');
							break;
						}
					}

					pCnt += 1;

					if (css) {
						if (pCnt < 50) {
							setTimeout(NS('XLoader').pWebKit, 50);
						} else {
							NS('XLoader').finish('css');
						}
					}
				}
			},
			css: function (urls, callback, obj, context) {
				NS('XLoader').load('css', urls, callback, obj, context);
			},
			js: function (urls, callback, obj, context) {
				NS('XLoader').load('js', urls, callback, obj, context);
			},
			toString:function(){
				return "[class "+this.ns+"]" ;
			}
		},
		init:function(){
			return this ;
		}
	} // END OF OBJECT
}()))) ;

/* EVENT */  
var EventDispatcher = NS('EventDispatcher', NS('spill.events::EventDispatcher', Class.$extend({
	__classvars__ : {
		version:'0.0.1',
		exposeImplementation : Object.prototype.toString,
		Handler : { 
			indexOf : function (arr, fct) {
				var idx = (arr.length - 1);
				while (idx > -1) {
					if (arr[idx] === fct) break;
					--idx;
				}
				return idx;
			}
		},
		Event : function (target, type) { 
			this.constructor = EventDispatcher.Event; 
			this.target = target;
			this.type = type;
			this.timeStamp = new Date();
		},
		EventListener : function (target, type, handler) { 
			this.constructor = EventDispatcher.EventListener; 
			var defaultEvent = new EventDispatcher.Event(target, type); 
			this.handleEvent = function (evt) {
				if ((typeof evt == "object") && evt) {
					evt.target = defaultEvent.target;
					evt.type = defaultEvent.type;
					evt.timeStamp = defaultEvent.timeStamp;
				} else {
					evt = {
						target: defaultEvent.target,
						type: defaultEvent.type,
						timeStamp: defaultEvent.timeStamp
					};
				}
				handler(evt);
			};
			this.getType = function () {
				return type;
			};
			this.getHandler = function () {
				return handler;
			};
		},
		EventTarget:function(){
			var eventMap = {} ;
			var removeEventListener = (function (type, handler) { 
				var event = eventMap[type], successfully = false;
				if (event) {
					var handlers = event.handlers,
					listeners = event.listeners,
					idx = EventDispatcher.Handler.indexOf(handlers, handler);
					if (idx >= 0) {
						handlers.splice(idx, 1);
						listeners.splice(idx, 1);
						successfully = true;
					}
				}
				return successfully;
			});
			this.addEventListener = (function (type, handler) {
				var reference;
				if (type && EventDispatcher.isString(type) && EventDispatcher.isFunction(handler)) {

					var event = eventMap[type], listener = new EventDispatcher.EventListener(this, type, handler);
					if (event) {

						var handlers = event.handlers,
						listeners = event.listeners,
						idx = EventDispatcher.Handler.indexOf(handlers, handler);

						if (idx == -1) {
							handlers.push(listener.getHandler()); 
							listeners.push(listener);

							reference = listener;
						} else {
							reference = listeners[idx];
						}
					} else {
						event = eventMap[type] = {};
						event.handlers = [listener.getHandler()];
						event.listeners = [listener];

						reference = listener;
					}
				}
				return reference;
			});
			this.removeEventListener = (function (typeOrListener, handler) { 
				return ((EventDispatcher.isString(typeOrListener) && EventDispatcher.isFunction(handler) && removeEventListener(typeOrListener, handler)) || ((typeOrListener instanceof EventDispatcher.EventListener) && removeEventListener(typeOrListener.getType(), typeOrListener.getHandler())) || false);
			});
			this.dispatchEvent = (function (evt) {
				var successfully = false,
				type = (((typeof evt == "object") && (typeof evt.type == "string") && evt.type) || ((typeof evt == "string") && evt)),
				event = (type && eventMap[type]);

				if (event) {
					var listeners = (event && event.listeners), len = ((listeners && listeners.length) || 0), idx = 0;

					if (len >= 1) {
						while (idx < len) {
							listeners[idx++].handleEvent(evt); // handle event dispatching serially - recommended if handler-processing is not that time consuming.
						}
						successfully = true;
					}
				}
				return successfully;
			});
		},
		stringify : function (obj) { return ((obj && obj.toString && obj.toString()) || "")},
		isBoolean : (function () {
			var regXBaseClass = (/^\[object\s+Boolean\]$/);
			return (function (obj) {
				return regXBaseClass.test(EventDispatcher.exposeImplementation.call(obj));
			});
		})(),
		isString : (function () {
			var regXBaseClass = (/^\[object\s+String\]$/);
			return (function (obj) { 

			  return regXBaseClass.test(EventDispatcher.exposeImplementation.call(obj));
			});
		})(),
		isFunction : function (obj) {
			return ((typeof obj == "function") && (typeof obj.call == "function") && (typeof obj.apply == "function")); // x-frame-safe and also filters e.g. mozillas [[RegExp]] implementation.
		},
		matches:null,
		register:function(obj){
			if ((typeof obj.addEventListener == "function") || obj.attachEvent || (typeof obj.removeEventListener == "function") || obj.detachEvent || (typeof obj.dispatchEvent == "function") || obj.fireEvent) 
			return obj ;
			EventDispatcher.EventTarget.call(obj);
			return obj ;
		},
		unregister:function (obj) {
			this.matches = this.matches || (function(){
				var psd = new EventDispatcher.EventTarget() ;
				return {
					addListener : psd.addEventListener.toString(),
					removeListener :psd.removeEventListener.toString(),
					dispatchEvent : psd.dispatchEvent.toString()
				} ;
			})() ;
			if (this.stringify(obj.addEventListener) === this.matches.addListener)
			delete obj.addEventListener;
			if (this.stringify(obj.removeEventListener) === this.matches.removeListener)
			delete obj.removeEventListener;
			if (this.stringify(obj.dispatchEvent) === this.matches.dispatchEvent)
			delete obj.dispatchEvent;

			return obj ;

		},
		toString:function(){
			return '[class EventDispatcher]' ;
		}
	},
	__init__ : function() {
		throw new Error('should not be instanciated... EventDispatcher') ;
		return false ;
	}
}))) ;
/* NET */
var Request = NS('Request', NS('spill.net::Request', Class.$extend({
	__classvars__ : {
		version:'0.0.1',
		namespaces : [
			function () {return new XMLHttpRequest()},
			function () {return new ActiveXObject("Msxml2.XMLHTTP")},
			function () {return new ActiveXObject("Msxml3.XMLHTTP")},
			function () {return new ActiveXObject("Microsoft.XMLHTTP")}
		],
		generateXHR:function () {
			var xhttp = false;
			var bank = NS('spill.net::Request').namespaces ;
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
		},
		toString:function(){
			return '[class Request]' ;
		}
	},
	__init__ : function(url, complete, postData) {
		var r = this.__classvars__.generateXHR();		
		if (!r) return;
		this.request = r ;
		this.url = url ;
		this.complete = complete ;
		this.userData = {
			post_data:postData,
			post_method:postData ? "POST" : "GET",
			ua_header:{ua:'User-Agent',ns:'XMLHTTP/1.0'},
			post_data_header: postData !== undefined ? {content_type:'Content-type',ns:'application/x-www-form-urlencoded'} : null 
		} ;
	},
	load : function(url){
		var r = this.request ;
		var th = this ;
		var ud = this.userData ;
		var complete = this.complete ;
		r.open(ud['post_method'] , url || this.url, true);
		r.setRequestHeader(ud['ua_header']['ua'],ud['ua_header']['ns']);
		if (ud['post_data_header'] !== null) r.setRequestHeader(ud['post_data_header']['content_type'],ud['post_data_header']['ns']);
		r.onreadystatechange = function () {
			if (r.readyState != 4) return;
			if (r.status != 200 && r.status != 304) {
				return;
			}
			th.complete(r, th);
		}
		if (r.readyState == 4) return ;
		r.send(ud['postData']);
		return this ;
	},
	destroy : function(){
		var ud = this.userData ;
		for(var n in ud){
			ud[n] = null ;
			delete ud[n] ;
		}
		
		this.userData =
		this.url =
		this.request =
		
		null ;
		
		delete this.userData ;
		delete this.url ;
		delete this.request ;
		
		return null ;
	},
	toString : function(){
		return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
	}
}))) ;
/* CHAINABLES */
var Command = NS('Command', NS('spill.command::Command', Class.$extend({
	__classvars__ : {
		version:'0.0.1',
		toString:function(){
			return '[class Command]' ;
		}
	},
	__init__ : function(thisObj, closure, params) {
		var args = [].slice.call(arguments) ;
		this.context = args.shift() ;
		this.closure = args.shift() ;
		this.params = args ;
		this.depth = '$' ;
		this.dispatcher = EventDispatcher.register(this) ;
		
		return this ;
	},
	execute : function(){
		
		var r = this.closure.apply(this, [].concat(this.params)) ;
		
		if(r !== null && r !== undefined) {
			this.dispatcher = r ;
			return this ;
		}
		
		return null ;
	},
	dispatchComplete : function(){
		this.dispatcher.dispatchEvent(this.depth) ;
	},
	destroy : function(){
		
		EventDispatcher.unregister(this.dispatcher) ;
		
		this.params =
		this.context =
		this.closure =
		this.depth =
		this.dispatcher =
		
		null ;
		
		delete this.params ;
		delete this.context ;
		delete this.closure ;
		delete this.depth ;
		delete this.dispatcher ;
		
		return null ;
	},
	toString : function(){
		return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
	}
}))) ;

var CommandQueue = NS('CommandQueue', NS('spill.command::CommandQueue', Command.$extend({
	__classvars__ : {
		version:'0.0.1',
		toString:function(){
			return '[class CommandQueue]' ;
		}
	},
	__init__ : function() {
		this.commands = [] ;
		this.commandIndex = -1 ;
		this.depth = '$' ;
		
		var cq = this ;
		
		this.add = function(){
			var args = arguments ;
			var l = args.length ;
			switch(l)
			{
				case 0:
					throw new Error('cannot add an null object, ...commandQueue') ;
				break;
				case 1:
					var arg = args[0] ;
					var isCommand = arg instanceof Command ;
					if(isCommand){
					    cq.commands[cq.commands.length] = arg ;
					}else{ // must be an array of commands
					    if(0 in arg) arguments.callee.apply(null, arg) ;
					}
				break;
				default :
					for(var i = 0 ; i < l ; i++ ){
						arguments.callee(args[i]) ;
					}
				break;
			}
			
		}
		
		if(arguments.length > 0 ) this.add(arguments[0]) ;
		
		this.dispatcher = EventDispatcher.register(this) ;
		return this ;
	},
	reset : function(){
		if(this.commands !== undefined){
			var commands = this.commands ;
			var l = commands.length ;
			while (l--) {
				var comm = commands[l];
				if(comm instanceof CommandQueue) comm.commandIndex = -1 ;
			}
		}
		this.commandIndex = -1 ;
		return this ;
	},
	next : function(){
		var cq = this ;
		var ind = this.commandIndex ;
		ind ++ ;
		
		var c = this.commands[ind] ;
		if(c === undefined){
			trace('commandQueue did not found command and will return, since command stack is empty...') ;
			setTimeout(function(){cq.dispatchComplete()}, 0) ; 
			return this
		}
		
		c.depth = this.depth + '$' ;
		
		var r = c.execute() ;
		
		if(r === undefined || r === null){
			this.commandIndex = ind ;
			if(ind == this.commands.length - 1){
				this.dispatchComplete() ;
			}else{
				this.next() ;
			}
		}else{
			var type = c.depth ;
			
			
			r.addEventListener(type, function(){
				r.removeEventListener(type, arguments.callee) ;
				cq.commandIndex = ind ;
				if(ind == cq.commands.length - 1){
					cq.dispatchComplete() ;
				}else{
					cq.next() ;
				}
			})
		}				
		
		return this ;
	},
	execute : function(){
		return this.next() ;
	},
	destroy : function(){
		
		if(this.commands !== undefined){
			var commands = this.commands ;
			var l = commands.length ;
			while (l--) {
				commands.pop().destroy() ;
			}
			this.commands = this.commandIndex = null ;
			delete this.commands ;
			delete this.commandIndex ;
		}
		
		EventDispatcher.unregister(this.dispatcher) ;
		
		this.next =
		this.add =
		this.dispatcher =
		this.depth =
		
		null ;
		
		delete this.next ;
		delete this.add ;
		delete this.dispatcher ;
		delete this.depth ;
		
		return null ;
	},
	toString : function(){
		return '[ object CommandQueue ]';
	}
}))) ;

var WaitCommand = NS('WaitCommand', NS('spill.command::WaitCommand', Command.$extend({
	__classvars__ : {
		version:'0.0.1',
		toString:function(){
			return '[class WaitCommand]' ;
		}
	},
	__init__ : function(time) {
		this.time = time ;
		this.depth = '$' ;
		this.dispatcher = EventDispatcher.register(this) ;
		this.uid = -1 ;
		return this ;
	},
	execute : function(){
		var w = this ;
		this.uid = setTimeout(function(){
			w.dispatchComplete() ;
			this.uid = -1 ;
		}, this.time) ;
		
		return this ;
	},
	destroy : function(){
		
		if(this.uid !== -1){
			clearTimeout(this.uid) ;
			this.uid = -1 ;
		}
		
		EventDispatcher.unregister(this.dispatcher) ;
		
		this.uid =
		this.time =
		this.depth =

		null ;
		
		delete this.uid ;
		delete this.time ;
		delete this.depth ;
		
		return null ;
	},
	toString : function(){
		return '[ object WaitCommand ]';
	}
}))) ;

var AjaxCommand = NS('AjaxCommand', NS('spill.commands::AjaxCommand', Command.$extend({
	__classvars__ : {
		version:'0.0.1',
		toString:function(){
			return '[class AjaxCommand]' ;
		}
	},
	__init__ : function(url, success, postData) {
		this.url = url ;
		this.success = success ;
		this.postData = postData ;
		this.depth = '$' ;
		this.dispatcher = EventDispatcher.register(this) ;
		return this ;
	},
	execute : function(){
		var w = this ;
		this.request = new Request(this.url, function(jxhr, r){
			w.success.apply(w, [jxhr, r]) ;
		}, this.postData) ;
		// here the trick
		setTimeout(function(){w.request.load()}, 0) ;
		return this ;
	},
	destroy : function(){
		if(this.request) this.request.destroy() ;
		
		EventDispatcher.unregister(this) ;
		
		this.request =
		this.success =
		this.url =
		this.postData =
		this.depth =
		this.dispatcher =
		
		null ;
		
		delete this.request ;
		delete this.success ;
		delete this.url ;
		delete this.postData ;
		delete this.depth ;
		delete this.dispatcher ;
		
		return null ;
	},
	toString : function(){
		return '[ object AjaxCommand > ' + this.url + ' ]';
	}
}))) ;






var Toolkit = NS('Toolkit', NS('spill.toolKit::Toolkit', Class.$extend({
	__classvars__ : {
		version:'0.0.1', 
		Qexists : function(sel) {
			sel = sel instanceof $ ? sel : $(sel) ;
			return (sel.length > 0) ;
		} ,
		toString:function(){
			return '[class Toolkit]' ;
		}
	},
	__init__ : function() {
		NS('Kompat').test() ;
		return this ;
	},
	toString : function(){
		return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
	}
}))) ;


var HTMLString = NS('HTMLString', NS('saz.dom::HTMLString', Class.$extend({
	__classvars__ : {
		version:'0.0.1',
		toString:function(){
			return '[class HTMLString]' ;
		},
		getTags:function(o, tag){
			var nodes = [] ;
			var reg = new RegExp('\(<'+tag+'[^>]*>\)(.*)(<\\/'+tag+'>)') ;
			o.replace(reg, function($0, $1, $2, $3, $4){
				var node = nodes[nodes.length] = {} ;
				node['html'] = $0 ;
				node['innerHTML'] = $2 ;
				node['opener'] = $1 ;
				node['closer'] = $3 ;
				return '' ;
			});
			return nodes ;
		}
	},
	__init__ : function(str) {
		
		this.source = str ;
		
		var comments = this.comments = [] ;
		var s = str ;
		s = s.replace(/\n|\r|\t/g, '').replace(/<!--(.*?)-->/gm, function($1){
			comments[comments.length] = $1 ;
			return '' ;
		});
		var head = this.head = HTMLString.getTags(s, 'head')[0] ;
		var body = this.body = HTMLString.getTags(s, 'body')[0] ;
		var stylesheets = this.stylesheets = head.innerHTML.match(/(<link[^>]*(rel="stylesheet")[^>]*\/>)/g) ;
		var scripts = this.scripts = [] ;
		body.plainHTML = body.innerHTML.replace(/<script[^>]*>(.*?)<\/script>/g, function($1){
			scripts[scripts.length] = $1 ;
			return '' ;
		}) ;
		return this ;
	},
	toString : function(){
		return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
	}
}))) ;


var Template = NS('Template', NS('saz.net::Template', Class.$extend({
	__classvars__ : {
		version:'0.0.1',
		toString:function(){
			return '[class Template]' ;
		}
	},
	__init__ : function(responseText) {
		var template = this ;
		this.stylesremoval = false ;
		
		
		var html = this.html = new HTMLString(responseText) ;
		
		this.response = html.body.plainHTML ;
		
		var originalstylesheets = html.stylesheets ;
		var originalscripts = html.scripts ;
		var css = this.css = [] ;
		var js = this.js = [] ;
		
		
		var l = originalstylesheets.length ;
		for(var i = 0 ; i < l ; i++ ){
			var style = originalstylesheets[i] ;
			var href = style.match(/[^="']*.css/i)[0] ;
			if(!$('.xload[source="'+ href +'"]').size() > 0){
				css[css.length] = href ;
			}
		}
		
		var l = originalscripts.length ;
		var scrRE = /[^="']*.js/i ;
		for(var i = 0 ; i < l ; i++ ){
			var script = originalscripts[i] ;
			if(scrRE.test(script)){// has src
				var href = script.match(/[^="']*.js/i)[0] ;
				if(!$('.xload[source="'+ href +'"]').size() > 0){
					js[js.length] = script ;
				}
			}else{
				js[js.length] = script ;
			}
		}
		return this ;
	},
	load:function(closure, params){
		var params = [].slice.call(arguments) ;
		closure = params.shift() ;
		var t = this ;
		NS('XLoader').css(this.css, function(){
			t.response = $(t.response) ;
			closure.apply(t, params) ;
		}) ;
		return this ;
	},
	init:function(instanciators){
	    this.instanciators = [].slice.call(arguments) ;
		var t = this ;
		var js = t.js ;
		var l = js.length ;
		for(var i= 0 ; i < l ; i++){
			var ex = $(js[i]) ;
			if(ex.html() === ''){
			    $(document.body).append(ex) ;
			}else{
			    eval(ex.html()) ;
			}
		}
		return this ;
	},
	unload:function(closure, params){
		var t = this ;
		var params = [].slice.call(arguments) ;
		closure = params.shift() ;
		
		if(!!t.stylesremoval){
			var s = $('style.xload, link.xload');
			t.response.empty().remove() ;
			s.remove() ;
			NS('XLoader').css(ALLCSS, function(){				
				if(Object.isFunction(closure)) closure.apply(t, params) ;
			}) ;
		}else{
			var s = $('style.xload, link.xload') ;
			var m = s.filter(function(i, el){
				return t.css.indexOf(el.getAttribute('source')) != -1 ;
			});
			m.remove() ;
			t.response.empty().remove() ;
			if(Object.isFunction(closure)) closure.apply(t, params) ;
		}
		return this ;
	},
	toString : function(){
		return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
	}
}))) ;




new Toolkit() ;



