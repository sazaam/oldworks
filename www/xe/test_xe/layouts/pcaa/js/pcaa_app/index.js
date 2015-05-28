// $.datepicker = {} ;
// $.datepicker.regional = {} ;
// $.datepicker.setDefaults = function(){} ;

// necessary for full app feature
var express = require('Express') ;
// if(window != window.top) return ;

var app = express() ;
	
	app.configure(function(){
		app
			.set('title', 'PCAA')
			.set('address', {
				home:'',
				base:__parameters.base.replace(/(test_xe\/).+/, '$1'),
				useLocale:false
			}) ;
	})
	// PAGE LOAD
	.listen('load', function siteload(e){
		app.discard('load', siteload) ;
		// console.clear() ;
		var routes = require('./pcaa_app/routes') ;
		
		$('.dyncont').remove() ;
		$('.nested').height('0em').removeClass('dispNone') ;
		// return ;
		
		// WHEN REALLY STARTS
		if(app.isReady())
			
			app
				.createClient()
				.get('/', routes)
				.initJSAddress() ;
			
		else // WHEN REAL DEEPLINK ARRIVES WITHOUT HASH, RELOAD W/ HASH
			
			app.createClient() ;
			
	}) ;
	/* .listen('unload', function siteunload(e){
		// PAGE UNLOAD
		app.discard('load', siteunload) ;
		app.destroy() ;
	}) ; */