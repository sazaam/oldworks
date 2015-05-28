// necessary for full app feature
var express = require('Express') ;
var routes = require('./routes') ;

// PAGE LOAD

var app = express() ;
	
	app.configure(function(){
		app
			.set('address', {
				home:'home',
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