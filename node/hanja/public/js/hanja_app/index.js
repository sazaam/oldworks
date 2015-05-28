
// necessary for full app feature
var express = require('Express') ;
var routes = require('./routes') ;
// var routes = require('Routes') ;



var WindowProxy = new Proxy.Class(window, {
	statics:{
		initialize:function(){
			trace('initing WindowProxy class', this) ;
			return this ;
		}
	},
	constructor:WindowProxy = function WindowProxy(over){
		trace('window proxy init') ;
		return this ;
	},
	// rewrite custom addEventListener
	bind:function bind(type, closure){
		return (!!window.attachEvent) ? 
			WindowProxy.factory.attachEvent('on'+type, closure) :
			WindowProxy.factory.addEventListener(type, closure, true) ;
	},
	unbind:function unbind(type, closure){
		return (!!window.detachEvent) ? 
			WindowProxy.factory.detachEvent('on'+type, closure) :
			WindowProxy.factory.removeEventListener(type, closure, true) ;
	},
	// rewrite custom setTimeout
	setTimeout:function setTimeout(closure, time){
		return WindowProxy.factory.setTimeout(closure, time) ;
	}
}) ;

/* creates an instance of that class , no need to re-assign proxy's target in constructor params */
var wproxy = new WindowProxy() ;

var loadclosure ;
wproxy.bind('load', loadclosure = function loadclosure(e){ // will call wproxy's override instead
	
	wproxy.unbind('load',  loadclosure) ;
	
	// var path = 'http://hanja.naver.com/ac' ;
	var path = 'http://openapi.naver.com/search' ;
	// var query = encodeURIComponent('½Å»õ°Ô') ;
	var query = '%EC%86%90%EC%9E%90%EC%86%90' ;
	var target = 'movie' ;
	
	
	// new Request('/naver/?path=' + path + '&query=' + query + '&target=' + target, 
	new Request("http://jpdic.naver.com/search.nhn?query=" + query, 
		function(jxhr, req){
			trace('FILSDEPUTE')
			trace(req)
			trace(jxhr.response)
	}, {
		post_method:'GET'
	}).load();
	
	/* wproxy.setTimeout(function(){
		
		var box = $('<div id="proxyexample">').addClass('abs zindex10 right0 left0 padding darkBG lightest').appendTo('.frame').css({'top':0})[0] ;
		
		var s = new Proxy(box) ;
		trace(s)
		s.innerHTML('!!! SUCCESS !!!') ;
		
	}, 30) ; */
})



var app = express() ;
	
	app.configure(function(){
		app
			.set('view engine', 'jade')
			.set('views', '/js/jade/')
			.set('title', 'Hanja Translator')
			.set('address', {
				home:'',
				base:__parameters.base,
				useLocale:true
			}) ;
	})
	// PAGE LOAD
	.listen('load', function siteload(e){
		app.discard('load', siteload) ;
		// WHEN REALLY STARTS
		
		if(app.isReady())
			app
				.createClient()
				.get('/', routes)
				.initJSAddress() ;
			
		else // WHEN REAL DEEPLINK ARRIVES WITHOUT HASH, RELOAD W/ HASH
			app.createClient() ;
		
	})
	.listen('unload', function siteunload(e){
		// PAGE UNLOAD
		app.discard('load', siteunload) ;
		app.destroy() ;
	}) ;