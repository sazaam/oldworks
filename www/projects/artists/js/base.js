/**
 * @author True
 */


/* TRACE*/
/* Sorry, I just happen to type 'trace' faster than any 'console.log' or 'cl', this way AS remains alive... sigh */
cl = trace = function(){	
	return function(){
		// presence of console namespace
		if(window.console && console){
			if(this.opera){ // OP
				opera.postError.apply(opera, [].slice.call(arguments)) ;
			}else if(console.firebug !== 'undefined'){ // FF
				arguments.length > 1 ? console.log(arguments) :  console.log.apply(console, arguments) ;
			}else if(console.profiles) { // CHR
				console.log.apply(console, [].slice.call(arguments)) ;
			}
		}else{
			// uncomment if you really wish alerts 
			// alert([].slice.call(arguments)) ;
		}
	}
}() ;

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

var XLoader = NS('XLoader', NS('spill.loading::XLoader', Class.$extend(function(){ 
	var d = document ;
	var brows, head,
  // Requests currently in progress, if any.
	pending = {},

  // Number of times we've polled to check whether a pending stylesheet has
  // finished loading. If this gets too high, we're probably stalled.
	pCnt = 0,

  // Queued requests.
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
				document.getElementsByTagName("head")[0].appendChild(file) ;
				
				switch(file.getAttribute('ext')){
					case 'css':// CSS TOUCHY CASE
						if(NS('Kompat').MSIE){ // IE
							// alert('MSIE') ;
							file.attachEvent("onreadystatechange", function(e){
								file.detachEvent(e.type, arguments.callee) ;
								var el = e ;
								e.target = e.srcElement;
								callback(e);
							}) ;
						}else if(NS('Kompat').Chrome || NS('Kompat').Safari){
							// alert('WEBKIT') ;
						}else if (NS('Kompat').Firefox){
							// alert('FIREFOX') ;
						}
					break;
					case 'javascript':// JS
						if(NS('Kompat').MSIE){ // IE
							file.attachEvent("onreadystatechange", function(e){
								file.detachEvent(e.type, arguments.callee) ;
								var el = e ;
								e.target = e.srcElement;
								callback(e);
							}) ;
						}else{ // OTHERS THAN IE
							file.onload = callback ;
						}
					break;
				}
				return file ;
			},
			createjscssfile:function(ns){
				var ext = NS('XLoader').detectFileExt(ns) ;
				var file ;
				if (ext == 'javascript'){ //if filename is a external JavaScript file
					file = document.createElement('script') ;
					file.setAttribute("type","text/javascript") ;
					file.setAttribute("src", ns) ;
				}
				else if (ext == "css"){ //if filename is an external CSS file
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
					urls     = p.urls;

					urls.shift();
					pCnt = 0;

					// If this is the last of the pending URLs, execute the callback and
					// start the next request in the queue (if any).
					if (!urls.length) {
						cb && cb.call(p.context, p.obj);
						pending[t] = null;
						q[t].length && load(t);
					}
				}
			},
			getBrows:function () {
				// No need to run again if already populated.
				if (brows) { return; }

				var ua = navigator.userAgent;

				brows = {
					// True if this browser supports disabling async mode on dynamically
					// created script nodes. See
					// http://wiki.whatwg.org/wiki/Dynamic_Script_Execution_Order
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
				isCSS = t === 'css' ,
				i, 
				l,
				n, 
				p,
				pendingUrls,
				u;
				
				
				//put somewhere else later
				NS('XLoader').getBrows();

				if (urls) {
					// If urls is a string, wrap it in an array. Otherwise assume it's an
					// array and create a copy of it so modifications won't be made to the
					// original.
					urls = typeof urls === 'string' ? [urls] : urls.concat();

					// Create a request object for each URL. If multiple URLs are specified,
					// the callback will only be executed after all URLs have been loaded.
					//
					// Sadly, Firefox and Opera are the only browsers capable of loading
					// scripts in parallel while preserving execution order. In all other
					// browsers, scripts must be loaded sequentially.
					//
					// All browsers respect CSS specificity based on the order of the link
					// elements in the DOM, regardless of the order in which the stylesheets
					// are actually downloaded.
					if (isCSS || brows.async || brows.gecko || brows.opera) {
						// Load in parallel.
						q[t].push({
							urls    : urls,
							callback: cb,
							obj     : obj,
							context : context
						});
					} else {
						// Load sequentially.
						for (i = 0, l = urls.length; i < l; ++i) {
							q[t].push({
								urls    : [urls[i]],
								callback: i === l - 1 ? cb : null, // callback is only added to the last URL
								obj     : obj,
								context : context
							});
						}
					}
				}

				// If a previous load request of this type is currently in progress, we'll
				// wait our turn. Otherwise, grab the next item in the queue.
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

					if (brows.ie && !isCSS) {
						n.onreadystatechange = function () {
							if (/loaded|complete/.test(n.readyState)) {
								n.onreadystatechange = null;
								_finish();
							}
						};
					} else if (isCSS && (brows.gecko || brows.webkit)) {
						// Gecko and WebKit don't support the onload event on link nodes.
						if (brows.webkit) {
							// In WebKit, we can poll for changes to document.styleSheets to
							// figure out when stylesheets have loaded.
							p.urls[i] = n.href; // resolve relative URLs (or polling won't work)
							NS('XLoader').pWebKit();
						} else {
							// In Gecko, we can import the requested URL into a <style> node and
							// poll for the existence of node.sheet.cssRules. Props to Zach
							// Leatherman for calling my attention to this technique, and to Oleg
							// Slobodskoi for an even earlier implementation.
							n.innerHTML = '@import "' + u + '";';
							NS('XLoader').pGecko(n);
						}
					} else {
						n.onload = n.onerror = _finish;
					}
					head.appendChild(n);
				}
			},
			pGecko: function (n) {
				try {
					n.sheet.cssRules;
				} catch (ex) {
					// An exception means the stylesheet is still loading.
					pCnt += 1;

					if (pCnt < 200) {
						setTimeout(function () { NS('XLoader').pGecko(n); }, 50);
					} else {
					// We've been polling for 10 seconds and nothing's happened. Stop
					// polling and finish the pending requests to avoid blocking further
					// requests.
						NS('XLoader').finish('css');
					}

					return;
				}

				// If we get here, the stylesheet has loaded.
				NS('XLoader').finish('css');
			},
			/**
				Begins polling to determine when pending stylesheets have finished loading
				in WebKit. Polling stops when all pending stylesheets have loaded or after 10
				seconds (to prevent stalls).
			*/
			pWebKit: function() {
				var css = pending.css, i;

				if (css) {
					i = sheets.length;

					// Look for a stylesheet matching the pending URL.
					while (i && --i) {
						if (sheets[i].href === css.urls[0]) {
							NS('XLoader').finish('css');
							break;
						}
					}

					pCnt += 1;

					if (css) {
						if (pCnt < 200) {
							setTimeout(NS('XLoader').pWebKit, 50);
						} else {
							// We've been polling for 10 seconds and nothing's happened, which may
							// indicate that the stylesheet has been removed from the document
							// before it had a chance to load. Stop polling and finish the pending
							// request to prevent blocking further requests.
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


/* CHAINABLES OBJECT */


var Command = NS('Command', NS('spill.command::Command', Class.$extend({
	__classvars__ : {
		version:'0.0.1',
		toString:function(){
			return '[class Command]' ;
		}
	},
	__init__ : function(thisObj, closure, params) {
		this.context = thisObj ;
		this.closure = closure ;
		return this ;
	},
	execute : function(){
		return this.closure.apply(this, [].concat(this.params)) ;
	},
	dispatchComplete : function(){
		$(this).trigger('$') ;
	},
	destroy : function(){
		this.toString =
		this.params =
		this.context =
		this.closure =
		this.execute =
		null ;
		
		delete this.toString ;
		delete this.params ;
		delete this.context ;
		delete this.closure ;
		delete this.execute ;
		
		return null ;
	},
	toString : function(){
		return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
	}
}))) ;



var CommandQueue = NS('CommandQueue', NS('spill.command::CommandQueue', Class.$extend({
	__classvars__ : {
		version:'0.0.1',
		toString:function(){
			return '[class CommandQueue]' ;
		}
	},
	__init__ : function() {
		var commands = this.commands = [];
		var queueIndex = -1;
		
		this.add = function(command) {
			commands.push(command);
        } ;
		
		
		this.addAll = function(arr) {
			commands = arr;
        } ;
		
        this.remove = function(command) {
            commands.slice(command, 1);
        } ;
        this.next = function(){
            var cq = this ;
			var ind = queueIndex + 1 ;
            var c = commands[ind] ;
			
            var r = c.execute() ;
            queueIndex = ind ;
			if(r !== null && r !== undefined) {
				$(c).bind("$", function(e){
					$(c).unbind("$", arguments.callee) ;
					if(queueIndex == commands.length - 1){
						cq.destroy() ;
					}else{
						cq.next() ;
					}
				})
			}else{
				if(queueIndex == commands.length - 1){
					cq.destroy() ;
				}else{
					cq.next() ;
				}
			}
        } ;
		
		this.execute = function() {
            this.next() ;
        } ;
        
		this.destroy = function() {
            var l = queueIndex ;
            while(l--){
				commands.splice(l, l+1)[0].destroy() ; 
            }
            queueIndex = 
            commands = 
			this.commands =
            this.add = 
            this.remove = 
            this.execute = 
            this.next = 
            null ;
            
            delete this.add ;
            delete this.remove ;
            delete this.execute ;
            delete this.next ;
            
            return null ;
        } ;
		
		return this ;
	},
	toString : function(){
		return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
	}
}))) ;


/* REQUEST OBJECT */

var Request = NS('Request', NS('spill.net::Request', Class.$extend({
	__classvars__ : {
		version:'0.0.1',
		toString:function(){
			return '[class Request]' ;
		}
	},
	__init__ : function(index, url, callback) {
		this.userdata = {};
		this.index = index;
		this.url = url;
		this.complete = function(jxhr){
			callback.apply(this, [jxhr]) ;
		};
		this.load = function(){
			var req = this ;
			
			var s = $.ajax({
			  url: this.url,
			  cache: false,
			  success: function(xhr){
			  	// don't go in there yo !
			  },
			  complete: function(xhr){
				req.complete(xhr) ;
			  },
			  error:function(xhr){
				if(Kompat.ie && xhr.readyState == 4 && xhr.status == 0)
				req.complete(xhr) ;
			  }
			});
			return this ;
		};
		
		this.destroy = function(){
			for(var s in this.userdata){
				this.userdata[s] = null ;
				delete this.userdata[s] ;
			}
			this.userdata = 
			this.index =
			this.url =
			this.complete = 
			this.load =
			this.destroy =
			null ;
			return null ;
		};
		
		return this ;
	},
	toString : function(){
		return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
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
new Toolkit() ;
