'use strict' ;
//////////////// URLS
var URL = (function(){
	var addressreg = /^(((http|ftp)s?:)\/\/([\w\d.-]+(:(\d+))?))?\/(([a-z0-9-]{2,}\/)*)?([#]\/|)?([a-z\/]{2}\/)?([^?]*)([?].+)?$/i ;
	var specialreg = /^[.]*(\/)/ ;
	var doublereg = /[.]{2,}\//g ;
	var slashreg = /^\// ;
	var absreg = /http(s)?:\/\// ;

	return function(str){
		
		var u = this ;
		
		switch(true){
			case typeof(str) == 'string' :
				// REMAINS A STRING
			break ;
			case str === undefined :
			case trace(str === window) :
				str = window.location.href ;
			break ;
			case !!str.nodeName && str.nodeName == 'A' && !!str.href :
				str = target.href ;
			break ;
		}
		
		u.go = function(str){
			
			if(!!u.absolute){
				
				if(!specialreg.test(str) && !absreg.test(str)) str = './'+str ;
				if(specialreg.test(str)){
					var t = slashreg.test(str) ? u.originroot : u.absoluteroot ;
					if(doublereg.test(str)){
						str = str.replace(doublereg, function(){
							t = t.replace(/[^\/]+\/$/g, '') ;
							return '' ;
						})
						str = t + '' + str.replace(slashreg, '') ;
					}else{
						str = t + '' + str.replace(specialreg, '') ;
					}
				}else{
					
				}		
			}
			
			if(!absreg.test(str) && !!u.originroot){
				str = u.originroot + str ;
			}
			u.absolute = str ;
				u.path = str.replace(addressreg, function(){
				var $$ = [].slice.call(arguments) ;
				u.base = ($$[1] || '') + '/' ;
				u.protocol = $$[3] || '' ;
				u.host = $$[4] || '' ;
				u.port = $$[6] || '' ;


				u.qs = $$[12] || '' ;
				u.loc = $$[10] || '';
				u.hash = $$[9] || '';
				u.root = ($$[7] || '')  ;
				u.absoluteroot = u.absolute.replace(''+u.path+'', '') ;

				return $$[11] || '' ;
			}) ;
			return this ;
		}
		u.go(str) ;
		u.originroot = u.absoluteroot ;
		u.toString = function()
		{
			return this.absolute ;
		}
	}
})() ;

//////////////// LOADING SCRIPTS
var Loader = (function(){
	var namespaces = [
		function () {return new XMLHttpRequest()},
		function () {return new ActiveXObject("Msxml2.XMLHTTP")},
		function () {return new ActiveXObject("Msxml3.XMLHTTP")},
		function () {return new ActiveXObject("Microsoft.XMLHTTP")}
	] ;
	var generateXHR = function () {
		var xhttp = false;
		var bank = namespaces ;
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
	var l = function Loader(url, complete, postData){
		var r = generateXHR() ;
		if (!r) return ;
		this.request = r ;
		this.url = url ;
		this.complete = complete ;
		this.userData = {
			post_data:postData,
			post_method:postData ? "POST" : "GET",
			ua_header:{ua:'User-Agent',ns:'XMLHTTP/1.0'},
			post_data_header: postData !== undefined ? {content_type:'Content-type',ns:'application/x-www-form-urlencoded'} : undefined 
		} ;	
	} ;
	l.prototype.destroy = function(){
		var ud = this.userData ;
		for(var n in ud){
			ud[n] = undefined ;
			delete ud[n] ;
		}

		this.userData =
		this.url =
		this.request =
		undefined ;

		delete this.userData ;
		delete this.url ;
		delete this.request ;

		return undefined ;
	}
	l.prototype.load = function(url, async){
		var r = this.request ;
		var th = this ;
		var ud = this.userData ;
		var complete = this.complete ;
		
		if(async === false){
			ud['post_method'] = 'GET' ;
			r.open(ud['post_method'], url || this.url, false) ;                             
			r.send(null) ;
			
			if(!!th.complete) th.complete(r, th) ;
			return this ;   
		}else{
			r.open(ud['post_method'] , url || this.url, async || true) ;
			if (ud['post_data_header'] !== undefined) r.setRequestHeader(ud['post_data_header']['content_type'],ud['post_data_header']['ns']) ;
				r.onreadystatechange = function () {
				if (r.readyState != 4) return;
				if (r.status != 200 && r.status != 304) {
				return ;
				}
				if(!!th.complete) th.complete(r, th) ;
			}
			if (r.readyState == 4) return ;
			r.send(ud['postData']) ;
			return this ;
		}
	} ;
	return l ;
})() ;

var XApp = function(params){
	
	var app = this, XBase , XModulesBase ;
	
	// LINE-ASSOCIATED DEBUG POSSIBLE ONLY IN FIREFOX
	
	
	var arr = params['apps'] || [] ;
	var root = params['root'] || '' ;
	var debug = params['debug'] || true ;
	var modulespath = params['modulespath'] || './modules/' ;
	
	var DEBUG = params['debug'] || false , asyncs ;
	if(DEBUG && !(/Firefox/.test(navigator.userAgent))) alert('not correct browser to debug, use Firefow instead')
	
	XBase = app.base = new URL() ;
	XBase.go(root) ;
	
	XModulesBase = app.modulesbase = new URL(XBase.absoluteroot) ;
	XModulesBase.go(modulespath) ;
	
	root = XBase.absoluteroot ;
	modulespath = XModulesBase.absoluteroot ;
	
	var xloaded = app.loaded = {} , concatenated = '' ;
	
	var appendScript = function(str, elName){
		var body= document.getElementsByTagName(elName || 'body')[0];
		var script= document.createElement('script');
		script.type= 'text/javascript' ;
		if(DEBUG) script.src = str ;
		else script.text = str ;
		body.appendChild(script) ;
	} ;
	
	var parseScript = app.parseScript = function(ll){
		var evalstr = ll.request.responseText ;
		var resp = evalstr.replace(/[\t\r\n]/g, '') ;
		var dependancies , exports ;
		resp.replace(/var __dependancies__ *= *(\[([^\]]*)\]) *;/, function(){
			dependancies = arguments[1] ;
			return '' ;
		}) ;
		
		if(!!dependancies){
			dependancies = eval(dependancies) ;
			var l = dependancies.length ;
			for(var i = 0 ; i < l ; i++){
				var dep = dependancies[i] ;
				if(!!xloaded[dep.name]) continue ;
				
				var uurl = XModulesBase.absoluteroot + dep.url ;
				var load = new Loader(uurl) ;
				xloaded[dep.name] = load ;
				
				load.load(undefined, false) ;
				parseScript(load) ;
			}
		}
		
		if(DEBUG) appendScript(ll.url, 'head') ;
		else concatenated += ';\n' + evalstr + ';\n' ;
	} ;
	
	
	
	var len = arr.length ;
	
	for(var j = 0 ; j < len ; j++){
		var mod = arr[j] ;
		if(!!xloaded[mod.name]) continue ;
		var url = XBase.absoluteroot + mod.url ;
		var lload = arr[j] = new Loader(url) ;
		xloaded[mod.name] = lload ;
	
		lload.load(undefined, false) ;
		parseScript(lload) ;
	}
	
	if(DEBUG){
		
		
	}else{
		setTimeout(function(){
			appendScript(concatenated, 'head') ;
			concatenated = '' ;
		}, 0) ;
	}
	
	return this ;
}
