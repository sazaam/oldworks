
(function(name, definition){
	
	if ('function' === typeof define){ // AMD
		define(definition) ;
	} else if ('undefined' !== typeof module && module.exports) { // Node.js
		module.exports = ('function' === typeof definition) ? definition() : definition ;
	} else {
		if(definition !== undefined) this[name] = ('function' === typeof definition) ? definition() : definition ;
	}

})('app', (function(){


	// necessary for full app feature
	var express = require('Express') ;
	var routes = require('./routes') ;

	// PAGE LOAD
	var app = express() ;
	
	app
		.configure(function(){
			app
				.set('view engine', 'jade')
				.set('views', '/js/jade/')
				.set('address', {
					home:'',
					base:'undefined' !== typeof __parameters ? __parameters.base : location.protocol + '//' + location.host + location.pathname,
					useLocale:true
				}) ;
		})
		.listen('load', function(e){
			
			app.discard('load', arguments.callee) ;
			
			// WHEN ADDRESS SYSTEM REALLY STARTS
			if(app.isReady())
				app
					.createClient()
					.get('/', routes)
					.initJSAddress() ;
				
			else // WHEN REAL DEEPLINK ARRIVES WITHOUT HASH, RELOAD W/ HASH
				app.createClient() ;
			
		})
		.listen('unload', function(e){
			// PAGE UNLOAD
			// app.discard('load',arguments.callee) ;
			app.destroy() ;
		}) ;
		
	

	return app ;
})()) ;